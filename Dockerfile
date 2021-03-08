FROM ubuntu:focal

# some environment variables
ENV TZ="Europe/Berlin"
ENV TERM="xterm-256color"
ENV GOSBOT_KEY="REPLACE WITH YOUR INSTALLATION KEY"
ENV GOSBOT_PORT="513"
ENV GOSBOT_UPDATE="true"

# add files
ADD ./start.sh /root/start.sh

# install some dependencies and configure time
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y software-properties-common wget tzdata cron sudo apt-transport-https php php-json zip unzip libopus-dev ffmpeg python3-pip youtube-dl tmux locales locales-all \
    && ln -snf /usr/bin/pip3 /usr/bin/pip \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure -f noninteractive tzdata \
    && chmod u+x /root/start.sh

RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O /root/packages-microsoft-prod.deb \
    && dpkg -i /root/packages-microsoft-prod.deb \
    && add-apt-repository universe \
    && apt-get update --yes \
    && pip install --upgrade youtube-dl \
    && apt-get install -y dotnet-sdk-5.0 dotnet-runtime-5.0  \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && apt-get autoremove -y

# volumes
VOLUME ["/opt/gosbot"]

# start command
CMD ["/root/start.sh"]
