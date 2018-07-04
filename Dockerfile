FROM alpine:latest
RUN cd /tmp \
  && apk add --update wget ca-certificates make g++ autoconf libstdc++ \
  && export SSDB_VERSION=master \
  && wget -O ssdb-src.tar.gz "https://github.com/ideawu/ssdb/archive/${SSDB_VERSION}.tar.gz" \
  && tar -zxf ssdb-src.tar.gz \
  && cd ssdb-$SSDB_VERSION \
  && make \
  && make install PREFIX=/ssdb \
  && sed -e 's@ip:.*@ip: 0.0.0.0@' \
    -e 's@level:.*@level: info@' \
    -e 's@output:.*@output: stdout@' \
    -e 's@cache_size:.*@cache_size: 64@' \
    -e 's@write_buffer_size:.*@write_buffer_size: 16@' \
    -e 's@binlog:.*@binlog: no@' \
    -i /ssdb/ssdb.conf \
  && apk del wget ca-certificates make g++ autoconf \
  && rm -rf /tmp /var/cache/apk/*
EXPOSE 8888
VOLUME /ssdb/var
CMD ["/ssdb/ssdb-server", "/ssdb/ssdb.conf"]