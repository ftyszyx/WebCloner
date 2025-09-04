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

### 4. 运行应用

```bash
flutter run -d windows
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
3. 输入任务名称和网站URL
4. 启动、暂停或删除任务


## 输出文件

克隆任务完成后，会在应用数据目录下生成以下文件：


## 技术栈

- **前端框架**: Flutter
- **状态管理**: GetX
- **本地存储**: Hive
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

## 许可证

本项目采用MIT许可证。

## 贡献

欢迎提交Issue和Pull Request来改进这个项目。

## 联系方式

如有问题或建议，请通过GitHub Issues联系我们。

## 多语言

```
https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization
```

fltter pub get 或者 flutter run会自动生成相关文件
也可以通过 flutter gen-l10n  生成


## todos
1. 爬取方式可以分两种类型：
    通用方式（现在的形式）
    定制方式，不同的网站，定制化采集，同时保存makdown和图片

1. chrome 资源不打进包里，打开软件时下载，减小包体(ok)



## 其它 

### 图标生成：

ImageMagick:

```
magick app4.svg -background none  -define icon:auto-resize="256,128,64,48,32,16" app_icon.ico
```