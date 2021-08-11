#!/usr/bin/env python
# -*- coding: utf-8 -*-
import time
import logging

from selenium import webdriver

logging.basicConfig(
    datefmt='%Y-%m-%d %H:%M:%S',
    level=logging.DEBUG
)

options = webdriver.ChromeOptions()
options.add_argument("window-size=1920x1480")
options.add_argument('--no-sandbox')
options.add_argument('--disable-gpu')
options.add_argument('--ignore-certificate-errors')
options.add_argument('--disable-dev-shm-usage')
options.add_argument('--single-process')
options.add_argument('--user-data-dir=/tmp/user-data')
options.add_argument('--data-path=/tmp/data-path')
options.add_argument('--homedir=/tmp')
options.add_argument('--disk-cache-dir=/tmp/cache-dir')
options.add_argument('--headless')

browser = webdriver.Chrome(chrome_options=options)
browser.get("https://www.python.org/")
time.sleep(3)
browser.save_screenshot("my_screenshot.png")
browser.close()

