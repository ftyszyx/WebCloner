# Web Cloner

一个使用Flutter开发的桌面应用程序，用于克隆网站、捕获截图并生成网页目录。

## 功能特性

- **账号管理**: 管理不同平台的账号和凭据
- **任务管理**: 创建和管理网页克隆任务
- **网页爬取**:  爬取用户需要的网站，遍历网站中所有的链接地址
- **截图功能**: 自动捕获网页截图 
- **目录生成**: 自动生成网页目录文件

## 为什么做这个
不知道大家有没有经历过，曾经风靡一时的社交平台突然关闭，那些记录着我们青春的文字、照片，瞬间消失不见。我的校内网账号就是这样，关停后，所有的日志、照片都成了永远的遗憾。
这件事让我意识到，在这个快速变化的时代，任何东西都可能转瞬即逝。QQ空间、微信公众号、各种内容平台，谁能保证它们永远存在呢？与其被动等待，不如主动出击！
于是，我决定自己做一个工具，把那些我想留住的文字、图片，统统备份到本地！
我的需求很简单：

- 备份那些精彩的文章：比如雪球上释老毛的文章，每次读都受益匪浅，必须保存下来！
- 突破订阅制平台的限制：花钱买了会员，却没时间看完所有内容？没关系，我把它们全部保存下来，慢慢享用！

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


## 其它 

### 图标生成：

ImageMagick:

```
magick app4.svg -background none  -define icon:auto-resize="256,128,64,48,32,16" app_icon.ico
```

### 生成hive adapter

```
flutter packages pub run build_runner build

```

### 多语言

```
https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization
```

fltter pub get 或者 flutter run会自动生成相关文件
也可以通过 flutter gen-l10n  生成


## 使用说明
 
安装包地址：
https://github.com/ftyszyx/WebCloner/releases

启动
第一次启动会下载一次chrome资源

程序首页
[图片]
两个功能，一个是账号管理，一个是任务管理
举例说明

新浪博客（感觉快倒闭了）
 
 
## 许可证

本项目采用MIT许可证。

## 贡献

欢迎提交Issue和Pull Request来改进这个项目。

## 联系方式

如有问题或建议，请通过GitHub Issues联系我们。
邮箱：whyzi@qq.com

qq: 2246855973

qq群： 572194495

公众号

![qrcode_for_gh_ece64bbdb799_258](https://github.com/user-attachments/assets/c8e715dd-4d7f-4b8d-884d-67a2c29961b9)

  


