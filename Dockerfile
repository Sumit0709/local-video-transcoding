FROM ubuntu:focal

RUN /usr/bin/apt-get update && \
    /usr/bin/apt-get install -y curl && \
    /usr/bin/apt-get install -y ffmpeg && \
    /usr/bin/apt-get install -y awscli

WORKDIR /home/app

# Copy script
COPY transcode.sh /home/app

ENTRYPOINT [ "/home/app/transcode.sh" ]