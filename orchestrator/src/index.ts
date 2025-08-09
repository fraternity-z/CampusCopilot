import express from 'express';
import pino from 'pino';
import pinoHttp from 'pino-http';
import Joi from 'joi';
import { chromium, Browser } from 'playwright';
import { Readability } from '@mozilla/readability';
import { JSDOM } from 'jsdom';

const logger = pino({ level: process.env.LOG_LEVEL || 'info' });
const app = express();
app.use(express.json({ limit: '1mb' }));
app.use(pinoHttp({ logger }));

let browser: Browser | null = null;

async function getBrowser() {
    if (!browser) {
        browser = await chromium.launch({ headless: true });
    }
    return browser;
}

type Engine = 'google' | 'bing' | 'baidu' | 'searxng' | 'exa' | 'bocha';

const searchSchema = Joi.object({
    query: Joi.string().min(1).required(),
    subQueries: Joi.array().items(Joi.string().min(1)).default([]),
    engines: Joi.array()
        .items(Joi.string().valid('google', 'bing', 'baidu', 'searxng', 'exa', 'bocha'))
        .default(['google']),
    maxResults: Joi.number().integer().min(1).max(10).default(5),
    language: Joi.string().optional(),
    region: Joi.string().optional()
});

app.post('/search', async (req, res) => {
    const { value, error } = searchSchema.validate(req.body);
    if (error) {
        return res.status(400).json({ error: error.message });
    }

    const { query, subQueries, engines, maxResults } = value as {
        query: string;
        subQueries: string[];
        engines: Engine[];
        maxResults: number;
    };

    const usedQueries = subQueries && subQueries.length > 0 ? subQueries.slice(0, 6) : [query];

    try {
        const browser = await getBrowser();
        const context = await browser.newContext({ userAgent: UA_POOL[Math.floor(Math.random() * UA_POOL.length)] });
        const page = await context.newPage();

        const results: any[] = [];
        const tasks = [] as Promise<void>[];

        for (const engine of engines) {
            for (const q of usedQueries) {
                tasks.push(
                    (async () => {
                        const serp = await fetchSerp(page, engine, q, maxResults);
                        for (const item of serp) {
                            // 抓取正文并抽取摘要
                            const detail = await fetchContent(page, item.url);
                            results.push({
                                engine,
                                title: item.title,
                                url: item.url,
                                displayLink: new URL(item.url).host,
                                snippet: detail.excerpt || item.snippet,
                                extracted_text: detail.text,
                                favicon: `https://www.google.com/s2/favicons?sz=64&domain_url=${encodeURIComponent(item.url)}`,
                                score: item.score
                            });
                        }
                    })()
                );
            }
        }

        // 并行抓取，限制并发：简单批处理
        const batchSize = 4;
        for (let i = 0; i < tasks.length; i += batchSize) {
            await Promise.all(tasks.slice(i, i + batchSize));
        }

        await context.close();

        // 去重：按 URL
        const dedup = Object.values(
            results.reduce((acc, cur) => {
                const key = cur.url.split('#')[0];
                if (!acc[key] || acc[key].score < cur.score) acc[key] = cur;
                return acc;
            }, {} as Record<string, any>)
        ) as any[];

        // 简单排序：score 降序
        dedup.sort((a, b) => (b.score || 0) - (a.score || 0));

        res.json({ results: dedup.slice(0, maxResults * engines.length) });
    } catch (e: any) {
        req.log.error({ err: e }, 'search failed');
        res.status(500).json({ error: e.message || String(e) });
    }
});

// ---- 简易实现：SERP 与正文抓取 ----
async function fetchSerp(page: import('playwright').Page, engine: Engine, q: string, maxResults: number) {
    const query = encodeURIComponent(q);
    let url = '';
    if (engine === 'google') url = `https://www.google.com/search?q=${query}`;
    else if (engine === 'bing') url = `https://www.bing.com/search?q=${query}`;
    else if (engine === 'baidu') url = `https://www.baidu.com/s?wd=${query}`;
    else if (engine === 'searxng') url = `https://searxng.site/search?q=${query}`; // 示例公共实例，建议自建
    else if (engine === 'exa') url = `https://exa.ai/search?q=${query}`; // 若需 API 建议改为其 API
    else if (engine === 'bocha') url = `https://bocha.ai/search?q=${query}`;

    await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 20000 });

    // 极简选择器（易碎，生产请自定义适配器）
    const selectors: Record<Engine, string> = {
        google: 'a h3',
        bing: 'li.b_algo h2 a',
        baidu: 'div.result h3 a, div.c-container h3 a',
        searxng: 'a.result-link',
        exa: 'a',
        bocha: 'a'
    } as any;

    const titleLinks = await page.locator(selectors[engine]).all();
    const items: { title: string; url: string; snippet: string; score: number }[] = [];
    for (const el of titleLinks.slice(0, maxResults)) {
        const title = (await el.textContent())?.trim() || '';
        const href = await el.evaluate((a: any) => a.closest('a')?.href || a.href || '');
        if (!href || !title) continue;
        items.push({ title, url: href, snippet: '', score: 1 });
    }
    return items;
}

async function fetchContent(page: import('playwright').Page, url: string) {
    try {
        await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 20000 });
        const html = await page.content();
        const dom = new JSDOM(html, { url });
        const reader = new Readability(dom.window.document);
        const article = reader.parse();
        return { text: article?.textContent || '', excerpt: article?.excerpt || '' };
    } catch {
        return { text: '', excerpt: '' };
    }
}

const UA_POOL = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15'
];

const port = Number(process.env.PORT || 8080);
app.listen(port, () => logger.info(`orchestrator listening on :${port}`));

process.on('SIGINT', async () => {
    if (browser) await browser.close();
    process.exit(0);
});


