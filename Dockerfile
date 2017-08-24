from golang

RUN git clone https://github.com/containernetworking/plugins.git

WORKDIR plugins
RUN ./build.sh

RUN mkdir /opt/bin/cni && cp bin/* /opt/bin/cni
VOLUME /opt/bin/cni
