FROM ubuntu:bionic

WORKDIR /tmp
ENV DEBIAN_FRONTEND noninteractive

# Packages
RUN apt update
RUN apt install -y build-essential libsqlite3-dev \
    sqlite3 bzip2 libbz2-dev zlib1g-dev libssl-dev openssl \
    libgdbm-dev libgdbm-compat-dev liblzma-dev libreadline-dev \
    libncursesw5-dev libffi-dev uuid-dev git curl wget zip \
    tzdata locales libdbus-glib-1-2
RUN apt clean

# Install google-chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb
RUN apt update
RUN apt -y install /tmp/google-chrome-stable_current_amd64.deb --fix-missing
RUN rm -f /tmp/google-chrome-stable_current_amd64.deb

# Install chromedriver
RUN wget https://chromedriver.storage.googleapis.com/92.0.4515.107/chromedriver_linux64.zip -O /tmp/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver_linux64.zip
RUN mv chromedriver /usr/bin/
RUN chmod +x /usr/bin/chromedriver
RUN rm -f /tmp/chromedriver_linux64.zip

# Install geckodriver
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.29.1/geckodriver-v0.29.1-linux64.tar.gz -O /tmp/geckodriver-v0.29.1-linux64.tar.gz
RUN tar -xvf /tmp/geckodriver-v0.29.1-linux64.tar.gz
RUN mv geckodriver /usr/bin/ && chmod +x /usr/bin/geckodriver
RUN rm -f /tmp/geckodriver-v0.29.1-linux64.tar.gz

# Install firefox
RUN wget http://ftp.mozilla.org/pub/firefox/releases/90.0.2/linux-x86_64/es-MX/firefox-90.0.2.tar.bz2
RUN tar -xvf firefox-90.0.2.tar.bz2 && mv firefox /usr/local/bin/
RUN ln -s /usr/local/bin/firefox/firefox /usr/bin/firefox

# Encoding and locales system
RUN locale-gen es_MX.UTF-8
ENV LANG es_MX.UTF-8
ENV LANGUAGE es_MX:es
ENV LC_ALL es_MX.UTF-8

# Setting for timezone
RUN echo "America/Mexico_City" > /etc/timezone
RUN rm -f /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

RUN useradd -u 1001 -s /bin/bash -d /app/ roboto
USER roboto
WORKDIR /app

# Install pyenv
RUN curl https://pyenv.run | /bin/bash

ENV HOME /app
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

ARG PYVERSION=3.8.2

RUN pyenv install $PYVERSION
RUN pyenv global $PYVERSION
RUN pyenv rehash
RUN pip install --upgrade pip
RUN pip install selenium==3.14.0

COPY --chown=roboto:roboto test/chrome.py /tmp
COPY --chown=roboto:roboto test/firefox.py /tmp

ENTRYPOINT ["/bin/bash"]
