FROM python:3

MAINTAINER Alex Olieman <alex@olieman.net>

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update \
    && apt-get install -y \
       libsnappy-dev \
       zlib1g-dev \
       libbz2-dev \
       libgflags-dev \
       liblz4-dev \
       libzstd-dev \
    && apt-get clean

RUN mkdir /build \
    && cd /build \
    && git clone https://github.com/facebook/rocksdb.git \
    && cd rocksdb \
    && INSTALL_PATH=/usr make install-shared \
    && rm -rf /build

WORKDIR /usr/src/app

# to avoid pip cache, this needs to be falsy
ENV PIP_NO_CACHE_DIR=false
COPY Pipfile ./
COPY Pipfile.lock ./
RUN pip install Cython pipenv
RUN pipenv install --system

RUN mkdir same_thing
RUN mkdir /downloads
COPY ./same_thing ./same_thing

CMD [ "python", "-m same_thing.loader" ]