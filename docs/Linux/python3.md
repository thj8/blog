## online install

```
yum install -y wget gcc make zlib-devel libffi-devel openssl openssl-devel python-pip initscripts mariadb-devel vim nmap-ncat.x86_64
    
wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz -o /tmp/Python-3.7.3.tgz

tar xf /tmp/Python-3.7.3.tgz -C /tmp/ && \
    cd /tmp/Python-3.7.3 && ./configure && \
    make && make install && \
    cd / && rm -rf /tmp/Python-3.7.3.tgz  && rm -rf /tmp/Python-3.7.3 && \
    rm -rf /usr/bin/python && \
    ln -s /usr/local/bin/python3.7 /usr/bin/python && \
    sed -i "s/python/python2.7/" /usr/bin/yum && \
    sed -i "s/python/python2.7/" /usr/libexec/urlgrabber-ext-down
```
