# Web Cloner

一个使用Flutter开发的桌面应用程序，用于克隆网站、捕获截图并生成网页目录。

## 功能特性

- **账号管理**: 管理不同平台的账号和凭据
- **任务管理**: 创建和管理网页克隆任务
- **网页克隆**: 支持单页面、多页面和全站克隆
- **截图功能**: 自动捕获网页截图
- **HTML保存**: 保存网页HTML内容
- **目录生成**: 自动生成网页目录文件

## 系统要求

- Windows 10/11
- Flutter 3.35.0 或更高版本
- Dart 3.8.1 或更高版本

## 安装和运行

### 1. 克隆项目

```bash
git clone <repository-url>
cd WebCloner
```

### 2. 安装依赖

```bash
flutter pub get
```

### 3. 生成Hive适配器

```bash
flutter packages pub run build_runner build
```

### 4. 运行应用

```bash
flutter run -d windows
```

## 项目结构

```
lib/
├── main.dart                 # 应用入口
├── models/                   # 数据模型
│   ├── account.dart         # 账号模型
│   └── task.dart            # 任务模型
├── modules/                  # 功能模块
│   ├── home/                # 主页面
│   ├── account/             # 账号管理
│   └── task/                # 任务管理
├── services/                 # 服务层
│   ├── account_service.dart # 账号服务
│   ├── task_service.dart    # 任务服务
│   └── web_clone_service.dart # 网页克隆服务
├── routes/                   # 路由配置
│   └── app_pages.dart       # 应用路由
├── utils/                    # 工具类
│   ├── common.dart          # 通用工具
│   └── logger.dart          # 日志工具
└── widgets/                  # 通用组件
    ├── account_form_dialog.dart # 账号表单对话框
    └── task_form_dialog.dart    # 任务表单对话框
```

## 使用说明

### 账号管理

1. 点击"Account Management"进入账号管理页面
2. 点击"Add Account"添加新账号
3. 填写账号名称、用户名、密码和平台信息
4. 可以编辑、删除和启用/禁用账号

### 任务管理

1. 点击"Task Management"进入任务管理页面
2. 点击"Create Task"创建新任务
3. 选择克隆类型：
   - **Single Page**: 克隆单个页面
   - **Multiple Pages**: 克隆多个页面
   - **Full Website**: 克隆整个网站
4. 输入任务名称和网站URL
5. 启动、暂停或删除任务

### 克隆类型

- **单页面克隆**: 适合只需要单个页面截图和HTML的情况
- **多页面克隆**: 适合需要克隆网站中特定页面的情况
- **全站克隆**: 自动爬取网站结构并克隆所有页面

## 输出文件

克隆任务完成后，会在应用数据目录下生成以下文件：

```
cloned_sites/
└── [task_id]/
    ├── page_001.png         # 页面截图
    ├── page_001.html        # 页面HTML
    ├── page_002.png
    ├── page_002.html
    └── directory.txt        # 网页目录
```

## 技术栈

- **前端框架**: Flutter
- **状态管理**: GetX
- **本地存储**: Hive
- **网络请求**: HTTP
- **桌面支持**: window_manager
- **UI组件**: Material Design 3

## 开发说明

### 添加新功能

1. 在`models/`目录下创建数据模型
2. 在`services/`目录下创建对应的服务类
3. 在`modules/`目录下创建UI页面
4. 在`routes/`目录下添加路由配置

### 数据库操作

项目使用Hive作为本地数据库，所有模型类都需要：

1. 继承`HiveObject`
2. 使用`@HiveType`注解
3. 为每个字段添加`@HiveField`注解
4. 运行`build_runner`生成适配器代码

## 许可证

本项目采用MIT许可证。

## 贡献

欢迎提交Issue和Pull Request来改进这个项目。

## 联系方式

如有问题或建议，请通过GitHub Issues联系我们。
