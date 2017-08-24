FROM golang

RUN git clone https://github.com/containernetworking/plugins.git

WORKDIR plugins
RUN ./build.sh

RUN mkdir -p /opt/cni/bin && cp bin/* /opt/cni/bin
VOLUME /opt/cni/bin
