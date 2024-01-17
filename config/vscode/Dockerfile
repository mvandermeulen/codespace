FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive

# Install Tools
RUN apt-get update && \
	apt-get install -y zsh curl git ca-certificates gnupg apt-transport-https openjdk-17-jdk && \
	chsh --shell /usr/bin/zsh root

# Install Code-Server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install Swift
RUN curl -s https://archive.swiftlang.xyz/install.sh | bash && \
	apt-get install -y swiftlang

VOLUME /root

CMD code-server --auth none --bind-addr 0.0.0.0:8080