# Time Zone Switcher App

一个简单实用的Windows托盘应用程序，用于防止屏幕锁定，同时允许屏幕保护程序运行。

## 功能特点

- 防止屏幕锁定功能（允许屏幕保护程序运行）
- 系统托盘图标，方便操作
- 轻量级应用，资源占用少

## 系统要求

- Windows 10/11
- .NET 6.0 运行时

## 安装方法

### 方法一：直接下载

1. 从[Releases](https://github.com/您的用户名/TimeZoneSwitcherApp/releases)页面下载最新版本
2. 解压缩文件
3. 运行TimeZoneSwitcherApp.exe

### 方法二：从源代码编译

1. 克隆仓库：`git clone https://github.com/您的用户名/TimeZoneSwitcherApp.git`
2. 使用Visual Studio 2022或更高版本打开解决方案
3. 编译并运行项目

## 使用说明

1. 启动应用程序后，它将在系统托盘中显示图标
2. 右键点击图标，选择以下选项：
   - "Enable Prevent Lock Screen"：启用防止屏幕锁定功能
   - "Disable Prevent Lock Screen"：禁用防止屏幕锁定功能
   - "Exit"：退出应用程序

## 注意事项

- 防止屏幕锁定功能会增加电脑功耗

## 版本历史

### 版本 1.1.0 (2024年07月08日)
- 移除了时区切换功能
- 修改了屏幕锁定防止机制，现在允许屏幕保护程序运行

### 版本 1.0.0 (2023年12月15日)

- 初始版本发布
- 支持快速切换美国东部时间和欧洲阿姆斯特丹时间
- 添加防止屏幕锁定功能

## 许可证

[MIT License](LICENSE)

## 贡献

欢迎提交问题和拉取请求！