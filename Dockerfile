# Altered to use clean Canonical image
FROM ubuntu:14.04

# ORIGINAL MAINTAINER Ilya Stepanov <dev@ilyastepanov.com>
MAINTAINER Dustin Lee <dlee35@gmail.com>

# This information is a merge of the hackpad repo from Ilya Stepanov <dev@ilyastepanov.com>
# and the official github repo from Dropbox to build an updated
# and working container to test Hackpad

RUN apt-get -qq update && \
    apt-get install -qqy git \
    wget \
    openjdk-7-jdk \
    scala && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -d /home/hackpad hackpad
RUN mkdir /home/hackpad
RUN chown hackpad:hackpad /home/hackpad

WORKDIR /home/hackpad

RUN git clone https://github.com/dropbox/hackpad.git && rm -rf hackpad/.git
COPY exports.sh hackpad/bin/exports.sh

RUN mkdir -p lib/ data/logs/
RUN wget https://cdn.mysql.com/archives/mysql-connector-java-5.1/mysql-connector-java-5.1.34.tar.gz && \
    tar -xzvf mysql-connector-java-5.1.34.tar.gz && \
    mv mysql-connector-java-5.1.34/mysql-connector-java-5.1.34-bin.jar lib/ && \
    rm mysql-connector-java-5.1.34.tar.gz && \
    rm -rf mysql-connector-java-5.1.34/

RUN ./hackpad/bin/build.sh

COPY start.sh start.sh
RUN chmod +x start.sh

EXPOSE 9000

CMD '/home/hackpad/start.sh'
