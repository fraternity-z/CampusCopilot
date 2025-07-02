# AI Assistant

模块化跨平台AI助手 - 支持多AI供应商、RAG知识库和智能体管理

## 🚀 自动化构建与发布

本项目已配置完整的CI/CD工作流，支持自动构建APK、IPA、EXE文件并发布release：

### 📱 支持平台
- ✅ **Android** (APK/AAB)
- ✅ **iOS** (IPA)  
- ✅ **Windows** (EXE/MSIX)

### 🔄 自动化功能
- **持续集成**: 每次PR和推送都会自动运行测试和构建检查
- **自动发布**: 推送版本标签时自动构建所有平台并发布GitHub Release
- **签名构建**: 支持生产级签名构建，可直接上传应用商店

### 🎯 快速发布
创建版本标签即可自动发布：
```bash
git tag v1.0.0
git push origin v1.0.0
```

详细使用指南请查看：[CI/CD工作流指南](docs/CI-CD-Guide.md)

---

*原有内容保持不变*

# Anywherechat

