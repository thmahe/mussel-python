# Download required packages
FROM ubuntu:22.04 as sources

ARG PYTHON_VERSION

RUN apt-get update &&  \
    apt-get install -y wget lsb-core && \
    wget -O /tmp/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/$(lsb_release -sc)/winehq-$(lsb_release -sc).sources && \
    wget -O /tmp/python-installer-amd64.exe "https://www.python.org/ftp/python/${PYTHON_VERSION}/python-${PYTHON_VERSION}-amd64.exe"

# Use the official Ubuntu 14.04 base image
FROM ubuntu:22.04

RUN apt-get update &&  \
    apt-get install -y --no-install-recommends winbind xvfb ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=sources /tmp/winehq-archive.key /etc/apt/keyrings/winehq-archive.key
COPY --from=sources /etc/apt/sources.list.d/ /etc/apt/sources.list.d/

RUN dpkg --add-architecture i386 && apt-get update && \
    apt-get install -y --no-install-recommends winehq-stable  && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN adduser --home /home/mussel --disabled-password --disabled-login mussel

COPY entrypoint_windows.sh /entrypoint.sh
COPY --from=sources /tmp/python-installer-amd64.exe /tmp/python-installer-amd64.exe
RUN mkdir /src && chown mussel /tmp/python-installer-amd64.exe /src /entrypoint.sh

USER mussel

ENV WINEDEBUG="-all"

RUN xvfb-run sh -c "export WINEDLLOVERRIDES='winemenubuilder.exe,mscoree,mshtml=' ;\
                    wine reg add 'HKLM\Software\Microsoft\Windows NT\CurrentVersion' /v CurrentVersion /d 10.0 /f ; \
                    wine reg add 'HKCU\Software\Wine\DllOverrides' /v winemenubuilder.exe /t REG_SZ /d '' /f ; \
                    wineserver -w" && \
    xvfb-run sh -c "wine /tmp/python-installer-amd64.exe /quiet TargetDir=C:\\Python \
                      Include_doc=0 InstallAllUsers=1 PrependPath=1; \
                      wineserver -w" && \
    rm /tmp/python-installer-amd64.exe

RUN wine C:\\Python\\python.exe -m pip install pip --upgrade && \
    wine C:\\Python\\python.exe -m pip install pyinstaller==6.0.0

ENV WINEPATH=${WINEPATH};C:\Python\Scripts

WORKDIR /src
ENTRYPOINT ["/entrypoint.sh"]
