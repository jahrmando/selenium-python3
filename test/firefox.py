#!/usr/bin/env python
# -*- coding: utf-8 -*-
import time
import logging
from selenium import webdriver
from selenium.webdriver.firefox.options import Options

logging.basicConfig(
    datefmt='%Y-%m-%d %H:%M:%S',
    level=logging.DEBUG
)

options = Options()
options.headless = True
options.add_argument('--no-sandbox')
options.add_argument("window-size=1920x1480")
options.add_argument('--disable-gpu')
options.add_argument('--ignore-certificate-errors')
options.add_argument('--disable-dev-shm-usage')
options.add_argument('--single-process')
options.add_argument('--user-data-dir=/tmp/user-data')
options.add_argument('--data-path=/tmp/data-path')
options.add_argument('--homedir=/tmp')
options.add_argument('--disk-cache-dir=/tmp/cache-dir')

browser = webdriver.Firefox(options=options)
browser.set_page_load_timeout(300.0)
browser.get("https://www.python.org/")
time.sleep(3)
browser.close()

