FROM rovjuvano/rust-lang:1.4.0

RUN : \
 && curl -o src.tar.gz -L https://static.rust-lang.org/dist/rustc-1.4.0-src.tar.gz \
 && tar xzf src.tar.gz \
 && mv rustc-* /usr/src/rustc \
 && rm -rf *.tar.gz \
 && :

RUN : \
 && curl -o dist.tar.gz -L https://github.com/phildawes/racer/archive/master.tar.gz \
 && tar xzf dist.tar.gz \
 && (cd racer-* && cargo build --release) \
 && cp racer-*/target/release/racer /usr/local/bin/ \
 && rm -rf racer-* \
 && rm -rf *.tar.gz \
 && :

ENV RUST_SRC_PATH=/usr/src/rustc/src
