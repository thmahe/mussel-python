FROM ubuntu:14.04 as build

ARG OPEN_SSL_VERSION
ARG PYTHON_VERSION

RUN apt-get update && apt install -y software-properties-common gdebi-core curl tar build-essential zlib1g-dev libbz2-dev libffi-dev

RUN curl --insecure -O https://www.openssl.org/source/openssl-${OPEN_SSL_VERSION}.tar.gz && \
    tar -xvzf openssl-${OPEN_SSL_VERSION}.tar.gz

RUN cd openssl-${OPEN_SSL_VERSION} && \
    ./config shared --prefix=/usr/local/ && \
    make build_sw -j && \
    make -j install_sw

RUN ldconfig /usr/local/lib64/ && bash -c "find / | grep 'libssl.so.3'" && openssl version
RUN openssl version

RUN curl -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar -xvzf Python-${PYTHON_VERSION}.tgz && \
    mkdir Python-${PYTHON_VERSION}/lib && \
    bash -c "cp /openssl-${OPEN_SSL_VERSION}/*.{so,so.3,a,pc} /Python-${PYTHON_VERSION}/lib"

RUN cd Python-${PYTHON_VERSION} && \
    export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64/ && \
    ./configure \
        --with-openssl=/openssl-${OPEN_SSL_VERSION} \
        --prefix=/opt/python \
        #--enable-optimizations \
        --enable-shared && \
    make -j && \
    make install -j

FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install binutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /opt/python/ /opt/python/
COPY --from=build /usr/local/lib64 /usr/local/lib64
COPY --from=build /usr/local/lib /usr/local/lib

RUN ldconfig /usr/local/lib /usr/local/lib64 /opt/python/lib

RUN adduser --home /home/mussel --disabled-password --disabled-login mussel
COPY entrypoint_linux.sh /entrypoint.sh
RUN mkdir /src && chown mussel /src /entrypoint.sh

USER mussel

ENV PATH=${PATH}:/home/mussel/.local/bin

RUN /opt/python/bin/python3 -m pip install pip --upgrade && \
    /opt/python/bin/python3 -m pip install pyinstaller==6.0.0

WORKDIR /src
ENTRYPOINT ["/entrypoint.sh"]
