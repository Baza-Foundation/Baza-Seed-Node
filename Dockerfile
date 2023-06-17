FROM ubuntu:20.04
RUN groupadd -r -g 999 baza && useradd -r -g baza -u 999 baza
ENV GOSU_VERSION 1.14
RUN set -eux; \
    # save list of currently installed packages for later so we can clean up
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates wget; \
    if ! command -v gpg; then \
    apt-get install -y --no-install-recommends gnupg2 dirmngr; \
    elif gpg --version | grep -q '^gpg (GnuPG) 1\.'; then \
    # "This package provides support for HKPS keyservers." (GnuPG 1.x only)
    apt-get install -y --no-install-recommends gnupg-curl; \
    fi; \
    rm -rf /var/lib/apt/lists/*; \
    \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    \
    # verify the signature
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    command -v gpgconf && gpgconf --kill all || :; \
    rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    \
    # clean up fetch dependencies
    apt-mark auto '.*' > /dev/null; \
    [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    \
    chmod +x /usr/local/bin/gosu; \
    # verify that the binary works
    gosu --version; \
    gosu nobody true
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends wget xz-utils
RUN set -eux; \
    mkdir /baza-bin; \
    cd /baza-bin; \
    wget --no-check-certificate https://github.com/Baza-Foundation/baza-coin/releases/download/0.0.1.9/baza-0.0.1.9-linux.tar.xz; \
    tar -xvf "baza-0.0.1.9-linux.tar.xz"; \
    cp bazad /bin
RUN rm -rf /baza-bin
RUN mkdir /data && chown baza:baza /data && chmod 777 /data
VOLUME /data
WORKDIR /data
RUN mkdir -p /etc/baza
COPY config.json /etc/baza/
COPY docker-entrypoint.sh /bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bazad", "-c", "/etc/baza/config.json"]
