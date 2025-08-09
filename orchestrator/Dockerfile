FROM mcr.microsoft.com/playwright:v1.46.0-jammy

WORKDIR /app
COPY package.json tsconfig.json ./
RUN npm ci --omit=dev
COPY src ./src
RUN npx tsc -p .

EXPOSE 8080
CMD ["node", "dist/index.js"]


