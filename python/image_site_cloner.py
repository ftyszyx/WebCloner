import os
import time
import json
from urllib.parse import urljoin, urlparse
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.edge.options import Options as EdgeOptions
from selenium.webdriver.firefox.options import Options as FirefoxOptions
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


class ImageSiteCloner:
    def __init__(self, base_url, output_dir="cloned_images", max_pages=100, delay=1, cookies=None):
        self.base_url = base_url
        self.domain = urlparse(base_url).netloc
        self.output_dir = output_dir
        self.max_pages = max_pages
        self.delay = delay
        self.cookies = cookies or []
        self.visited_urls = []
        self.urls_to_visit = [base_url]
        os.makedirs(output_dir, exist_ok=True)
        os.makedirs(os.path.join(output_dir, "screenshots"), exist_ok=True)
        os.makedirs(os.path.join(output_dir, "pages"), exist_ok=True)

        # 如果没有提供cookies，尝试从配置文件加载
        if not self.cookies:
            self.load_cookies_from_config()

    def load_cookies_from_config(self):
        """从配置文件加载cookies"""
        try:
            config_file = "cookies_config.json"
            if os.path.exists(config_file):
                with open(config_file, "r", encoding="utf-8") as f:
                    config = json.load(f)

                print(f"domain: {self.domain} loadcookies")
                site_config = config.get(self.domain)
                if site_config:
                    self.cookies = site_config.get("cookies", [])
                    print(f"✓ 从配置文件加载了 {len(self.cookies)} 个cookies")
        except Exception as e:
            print(f"加载cookies配置失败: {e}")

    def setup_driver(self):
        # 优先尝试 Chrome（Selenium Manager 自动管理驱动）
        try:
            chrome_options = ChromeOptions()
            chrome_options.add_argument("--headless=new")
            chrome_options.add_argument("--no-sandbox")
            chrome_options.add_argument("--disable-dev-shm-usage")
            chrome_options.add_argument("--disable-gpu")
            chrome_options.add_argument("--window-size=1920,1080")
            chrome_options.add_argument("--hide-scrollbars")
            chrome_binary = os.getenv("CHROME_BINARY")
            if chrome_binary:
                chrome_options.binary_location = chrome_binary
            driver = webdriver.Chrome(options=chrome_options)
        except Exception:
            # 回退到 Edge（使用系统已安装的 Edge）
            try:
                edge_options = EdgeOptions()
                edge_options.add_argument("--headless=new")
                edge_options.add_argument("--window-size=1920,1080")
                edge_options.add_argument("--hide-scrollbars")
                driver = webdriver.Edge(options=edge_options)
            except Exception:
                # 回退到 Firefox
                firefox_options = FirefoxOptions()
                firefox_options.add_argument("-headless")
                driver = webdriver.Firefox(options=firefox_options)

        # 添加cookies
        if self.cookies:
            self.add_cookies(driver)

        return driver

    def add_cookies(self, driver):
        """添加cookies到浏览器"""
        try:
            # 首先访问目标网站，这样才能设置cookies
            driver.get(self.base_url)
            time.sleep(2)

            for cookie in self.cookies:
                try:
                    if isinstance(cookie, dict):
                        # 如果cookie是字典格式
                        if "name" in cookie and "value" in cookie:
                            driver.add_cookie(cookie)
                        else:
                            print(f"跳过无效cookie格式: {cookie}")
                    elif isinstance(cookie, str):
                        # 如果cookie是字符串格式（如 "name=value"）
                        if "=" in cookie:
                            name, value = cookie.split("=", 1)
                            driver.add_cookie({"name": name.strip(), "value": value.strip(), "domain": self.domain})
                        else:
                            print(f"跳过无效cookie字符串: {cookie}")
                except Exception as e:
                    print(f"添加cookie失败: {cookie}, 错误: {e}")

            print(f"成功添加 {len([c for c in self.cookies if isinstance(c, dict) and 'name' in c and 'value' in c])} 个cookies")
        except Exception as e:
            print(f"添加cookies时出错: {e}")

    def normalize_url(self, href, current_url):
        if not href:
            return None
        if href.startswith("#"):
            return None
        if href.startswith(("http://", "https://")):
            return href
        return urljoin(current_url, href)

    def is_same_domain(self, url):
        return urlparse(url).netloc == self.domain

    def capture_fullpage_screenshot(self, driver, save_path):
        try:
            total_height = driver.execute_script(
                "return Math.max(document.body.scrollHeight, document.documentElement.scrollHeight, document.body.offsetHeight, document.documentElement.offsetHeight, document.body.clientHeight, document.documentElement.clientHeight);"
            )
            driver.set_window_size(1920, max(1080, total_height))
        except Exception:
            pass
        driver.save_screenshot(save_path)

    def create_page_view(self, title, image_rel_path, page_rel_path):
        html = f"""<!DOCTYPE html><html lang=\"zh-CN\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><title>{title}</title><style>body{{margin:0;background:#111;color:#eee;font-family:system-ui,-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica,Arial;}}.bar{{position:sticky;top:0;background:#1e1e1e;border-bottom:1px solid #333;padding:8px 12px;display:flex;gap:8px;align-items:center;}}a{{color:#61dafb;text-decoration:none}}.wrap{{display:flex;justify-content:center;padding:16px;}}img{{max-width:100%;height:auto;box-shadow:0 2px 16px rgba(0,0,0,.5);background:#222}}</style></head><body><div class=\"bar\"><a href=\"../index.html\">返回索引</a><span>— {title}</span></div><div class=\"wrap\"><img src=\"{image_rel_path}\" alt=\"{title}\"></div></body></html>"""
        with open(page_rel_path, "w", encoding="utf-8") as f:
            f.write(html)

    def create_index(self, records):
        items = []
        for i, r in enumerate(records):
            items.append(f"<li><a href=\"pages/{r['page_file']}\">{i+1}. {r['title']}</a> — <small>{r['url']}</small></li>")
        html = (
            """<!DOCTYPE html><html lang=\"zh-CN\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><title>截图镜像索引</title><style>body{max-width:980px;margin:0 auto;padding:24px;font-family:system-ui,-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica,Arial}h1{margin:0 0 16px}ul{list-style:none;padding:0;margin:0;display:grid;gap:10px}li{padding:10px;border:1px solid #ddd;border-radius:6px}a{text-decoration:none;color:#0078d4}</style></head><body><h1>截图镜像索引</h1><ul>"""
            + "".join(items)
            + """</ul></body></html>"""
        )
        with open(os.path.join(self.output_dir, "index.html"), "w", encoding="utf-8") as f:
            f.write(html)

    def run(self):
        driver = self.setup_driver()
        records = []
        try:
            while self.urls_to_visit and len(self.visited_urls) < self.max_pages:
                url = self.urls_to_visit.pop(0)
                if url in self.visited_urls:
                    continue
                if not self.is_same_domain(url):
                    continue
                print(f"处理: {url}")
                driver.get(url)
                try:
                    WebDriverWait(driver, 15).until(EC.presence_of_element_located((By.TAG_NAME, "body")))
                except Exception:
                    pass
                time.sleep(self.delay)
                title = driver.title or url
                img_name = f"{len(self.visited_urls)+1:05d}.png"
                page_name = f"{len(self.visited_urls)+1:05d}.html"
                img_path = os.path.join(self.output_dir, "screenshots", img_name)
                page_path = os.path.join(self.output_dir, "pages", page_name)
                self.capture_fullpage_screenshot(driver, img_path)
                self.create_page_view(title, f"../screenshots/{img_name}", page_path)
                records.append(
                    {
                        "url": url,
                        "title": title,
                        "image": f"screenshots/{img_name}",
                        "page_file": page_name,
                    }
                )
                self.visited_urls.append(url)
                # 采集部分链接（防止过多）
                try:
                    anchors = driver.find_elements(By.CSS_SELECTOR, "a[href]")
                    for a in anchors[:200]:
                        try:
                            href = a.get_attribute("href")
                            n = self.normalize_url(href, url)
                            if n and self.is_same_domain(n) and n not in self.visited_urls and n not in self.urls_to_visit:
                                self.urls_to_visit.append(n)
                        except Exception:
                            pass
                except Exception:
                    pass
                time.sleep(self.delay)
            # 输出索引与数据
            self.create_index(records)
            with open(os.path.join(self.output_dir, "records.json"), "w", encoding="utf-8") as f:
                json.dump(records, f, ensure_ascii=False, indent=2)
            print(f"完成，共截图 {len(records)} 页，输出目录: {self.output_dir}")
        finally:
            driver.quit()


def main():
    print("=== ImageSiteCloner - 截图镜像工具 ===")
    url = "https://www.315lz.com/forum-2-1.html"
    max_pages = 20000
    delay = 2
    out = "cloned_images"
    cloner = ImageSiteCloner(url, output_dir=out, max_pages=max_pages, delay=delay)
    cloner.run()


if __name__ == "__main__":
    main()
