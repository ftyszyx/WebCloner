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
    def __init__(self, base_url, output_dir="cloned_images", max_pages=100, delay=1):
        self.base_url = base_url
        self.domain = urlparse(base_url).netloc
        self.output_dir = output_dir
        self.max_pages = max_pages
        self.delay = delay
        self.visited_urls = []
        self.urls_to_visit = [base_url]
        os.makedirs(output_dir, exist_ok=True)
        os.makedirs(os.path.join(output_dir, "screenshots"), exist_ok=True)
        os.makedirs(os.path.join(output_dir, "pages"), exist_ok=True)

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
            return webdriver.Chrome(options=chrome_options)
        except Exception:
            pass
        # 回退到 Edge（使用系统已安装的 Edge）
        try:
            edge_options = EdgeOptions()
            edge_options.add_argument("--headless=new")
            edge_options.add_argument("--window-size=1920,1080")
            edge_options.add_argument("--hide-scrollbars")
            return webdriver.Edge(options=edge_options)
        except Exception:
            pass
        # 回退到 Firefox
        firefox_options = FirefoxOptions()
        firefox_options.add_argument("-headless")
        return webdriver.Firefox(options=firefox_options)

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
            items.append(
                f"<li><a href=\"pages/{r['page_file']}\">{i+1}. {r['title']}</a> — <small>{r['url']}</small></li>"
            )
        html = (
            """<!DOCTYPE html><html lang=\"zh-CN\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><title>截图镜像索引</title><style>body{max-width:980px;margin:0 auto;padding:24px;font-family:system-ui,-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica,Arial}h1{margin:0 0 16px}ul{list-style:none;padding:0;margin:0;display:grid;gap:10px}li{padding:10px;border:1px solid #ddd;border-radius:6px}a{text-decoration:none;color:#0078d4}</style></head><body><h1>截图镜像索引</h1><ul>"""
            + "".join(items)
            + """</ul></body></html>"""
        )
        with open(
            os.path.join(self.output_dir, "index.html"), "w", encoding="utf-8"
        ) as f:
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
                    WebDriverWait(driver, 15).until(
                        EC.presence_of_element_located((By.TAG_NAME, "body"))
                    )
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
                            if (
                                n
                                and self.is_same_domain(n)
                                and n not in self.visited_urls
                                and n not in self.urls_to_visit
                            ):
                                self.urls_to_visit.append(n)
                        except Exception:
                            pass
                except Exception:
                    pass
                time.sleep(self.delay)
            # 输出索引与数据
            self.create_index(records)
            with open(
                os.path.join(self.output_dir, "records.json"), "w", encoding="utf-8"
            ) as f:
                json.dump(records, f, ensure_ascii=False, indent=2)
            print(f"完成，共截图 {len(records)} 页，输出目录: {self.output_dir}")
        finally:
            driver.quit()


def main():
    print("=== ImageSiteCloner - 截图镜像工具 ===")
    url = input("请输入要镜像的根URL: ").strip()
    if not url:
        print("请输入有效URL")
        return
    if not url.startswith(("http://", "https://")):
        url = "https://" + url
    try:
        max_pages = int(input("最大页面数(默认50): ").strip() or 50)
    except Exception:
        max_pages = 50
    try:
        delay = float(input("请求间隔秒(默认1): ").strip() or 1)
    except Exception:
        delay = 1
    out = input("输出目录(默认cloned_images): ").strip() or "cloned_images"
    cloner = ImageSiteCloner(url, output_dir=out, max_pages=max_pages, delay=delay)
    cloner.run()


if __name__ == "__main__":
    main()
