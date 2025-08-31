#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
WebCloner 启动脚本（截图镜像版）
"""


def show_menu():
    """显示菜单"""
    print("=" * 50)
    print("      WebCloner - 截图镜像工具 (仅图片模式)")
    print("=" * 50)
    print("1. 启动截图镜像版本")
    print("2. 管理Cookies配置")
    print("3. 退出")
    print("=" * 50)


def run_image_cloner():
    """运行截图镜像版本"""
    try:
        from image_site_cloner import main

        main()
    except ImportError as e:
        print(f"错误: 无法导入截图镜像版本: {e}")
        print("需要: selenium")
    except Exception as e:
        print(f"运行错误: {e}")


def run_cookies_manager():
    """运行cookies管理器"""
    try:
        from cookies_config import run_cookies_manager

        run_cookies_manager()
    except ImportError as e:
        print(f"错误: 无法导入cookies管理器: {e}")
    except Exception as e:
        print(f"运行错误: {e}")


def main():
    """主函数"""
    while True:
        show_menu()
        choice = input("请选择 (1-3): ").strip()

        if choice == "1":
            print("\n启动截图镜像版本...")
            run_image_cloner()
        elif choice == "2":
            print("\n启动Cookies管理器...")
            run_cookies_manager()
        elif choice == "3":
            print("退出程序")
            break
        else:
            print("无效选择，请重新输入")

        if choice in ["1", "2"]:
            input("\n按回车键继续...")


if __name__ == "__main__":
    main()
