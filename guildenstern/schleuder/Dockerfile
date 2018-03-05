FROM debian

RUN apt-get update && \
    apt-get install -y ruby-dev gnupg2 libgpgme-dev libsqlite3-dev libssl-dev build-essential haveged wget

RUN wget https://0xacab.org/schleuder/schleuder/raw/master/gems/schleuder-3.2.1.gem && \
    gpg --recv-key 0xB3D190D5235C74E1907EACFE898F2C91E2E6E1F3 && \
    gpg --verify schleuder-3.2.1.gem.sig && \
    gem install schleuder-3.2.1.gem && \
    schleuder install

ENTRYPOINT ["/bin/bash"]

CMD ["-l"]
