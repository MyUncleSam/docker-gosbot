FROM ubuntu:focal

# some environment variables
ENV TZ="Europe/Berlin"
ENV TERM="xterm-256color"
ENV GOSBOT_KEY=""
ENV GOSBOT_PORT="513"
ENV GOSBOT_UPDATE="true"

# add files
ADD ./start.sh /root/start.sh

# install some dependencies and configure time
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y software-properties-common wget tzdata cron sudo apt-transport-https php php-json zip unzip libopus-dev ffmpeg python3-pip youtube-dl tmux locales \
    && ln -snf /usr/bin/pip3 /usr/bin/pip \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata \
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

# download gosbot installer (and remove not needed sleeps to speedup build process)
RUN wget --content-disposition https://gosbot.de/install -O /root/gosbot_installer.sh \
    && chmod 777 /root/gosbot_installer.sh \
    && sed -i "s/sleep/#sleep/g" /root/gosbot_installer.sh

# volumes
VOLUME ["/opt/gosbot"]

# start command
CMD ["/root/start.sh"]
