# WebCloner - 截图镜像工具

一个专注于“将网页渲染并保存为图片”的镜像工具。无需处理 JS/CSS 依赖，离线预览稳定。程序会自动遍历同域链接，逐页截图并生成索引与查看页。

## 特性
- **整页截图**：渲染后按全页高度保存 PNG
- **自动索引**：生成 `index.html` 汇总所有页面
- **查看页面**：每页生成独立查看 HTML，便于翻阅
- **同域遍历**：仅抓取同域链接，防止跑飞

## 安装
需要 Python 3.8+
```bash
pip install selenium
```
Windows 使用 Edge/Chrome 自带浏览器即可；若使用 Firefox，请确保本机安装了 Firefox。

## 使用
- 方式一：启动器
```bash
python run.py
```
选择“启动截图镜像版本”。

- 方式二：直接运行
```bash
python image_site_cloner.py
```
按照提示输入：根URL、最大页面数、请求间隔秒、输出目录（默认 `cloned_images`）。

## 输出结构
```
cloned_images/
├─ index.html            # 索引页
├─ records.json          # 记录原始URL与标题
├─ screenshots/          # 截图PNG
└─ pages/                # 查看HTML（引用对应截图）
```

## 故障排查
- 若报 “不是有效的 Win32 应用程序”，通常是驱动/浏览器位数不匹配。已使用 Selenium Manager 自动管理驱动；仍有问题时：
  - 指定 Chrome 路径：
    ```bash
    set CHROME_BINARY=C:\Path\To\chrome.exe
    python run.py
    ```
  - 尝试改用 Edge/Firefox（脚本会自动回退）。
- 如需长页面滚动加载再截图、登录后截图等，可提需求扩展。

## 许可证
仅供学习与研究使用，请遵守目标网站条款与法律法规。
