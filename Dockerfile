# version 1.0

FROM ubuntu:latest
MAINTAINER Jose G. Faisca <jose.faisca@gmail.com>

ENV IMAGE dnschain/dnschain 

# Nodejs version
ENV VERSION 4

# DNSChain configuration variables
ENV DNS_PORT 5333
ENV HTTP_PORT 8000
ENV TLS_PORT 4443
ENV OLDDNS_ADDR 8.8.8.8   

# Namecoin configuration variables
ENV RPC_USER rpc
ENV RPC_PASS secret
ENV RPC_PORT 8336
ENV RPC_CONNECT 127.0.0.1

ARG DEBIAN_FRONTEND=noninteractive

# -- Install main independencies -- 
RUN apt-get update && apt-get install -y \
curl git python make gcc g++ iproute2 dnsutils 
RUN curl -sL https://deb.nodesource.com/setup_$VERSION.x | bash\ 
	&& apt-get install -y nodejs \
	&& npm config set unsafe-perm true \
	&& npm install -g coffee-script

# -- Install DNSChain --
RUN npm install -g dnschain \
	&& npm config set unsafe-perm false

# -- Change terminal emulator --
RUN echo "" >> ~/.bashrc \
        && echo "# change terminal emulator." >> ~/.bashrc \
        && echo "export TERM=xterm" >> ~/.bashrc

# -- Clean --
RUN cd / \
        && apt-get autoremove -y \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

COPY run.sh /usr/local/bin/
ENTRYPOINT ["run.sh"]

EXPOSE $DNS_PORT/udp $HTTP_PORT/tcp $TLS_PORT/tcp
VOLUME ["/etc/dnschain", "/data/namecoin"]
CMD ["/usr/bin/dnschain"]
