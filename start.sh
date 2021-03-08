#!/usr/bin/env bash

# initialize trap to forceful stop the bot
trap terminator SIGHUP SIGINT SIGQUIT SIGTERM
function terminator() { 
  echo 
  echo "Shutting down gosbot $child..."
  kill -TERM "$child" 2>/dev/null
  stop
  echo "Exiting."
}

function stop() {
    cd /opt/gosbot/instance/bot
    php /opt/gosbot/instance/instance_stop.php
}

function start() {
    cd /opt/gosbot/instance/bot
    #/opt/gosbot/dotnet/./dotnet /opt/gosbot/instance/bot/TS3AudioBot.dll
    #/usr/bin/dotnet /opt/gosbot/instance/bot/TS3AudioBot.dll
    php /opt/gosbot/instance/instance_start.php
}

function update() {
    cd /opt/gosbot/instance/bot
    php /opt/gosbot/instance/instance_update_pr.php
}

if [[ ! -d /opt/gosbot/instance/bot ]]; then
    echo "This is the first start of this container - starting installation procedure for key: ${GOSBOT_KEY}"

    echo "Downloading installer script"
    wget --content-disposition https://gosbot.de/install -O /root/gosbot_installer.sh
    chmod u+x /root/gosbot_installer.sh
    sed -i "s/sleep/#sleep/g" /root/gosbot_installer.sh

    # start installation using Ubuntu 18.04 (2) and the given port
    echo "Starting installation procedure"
    echo -e "2\n${GOSBOT_PORT}\n" | /root/gosbot_installer.sh $GOSBOT_KEY

    # stopping the bot as we start it in below
    stop
fi

echo "OS Date: $(date)"

# update
if [ "$GOSBOT_UPDATE" = "1" ] || [ $GOSBOT_UPDATE = "true" ]; then
    echo "Updating gosbot"
    update
    echo ""
fi

echo "Starting gosbot server"
cd /opt/gosbot/instance/bot
start
tail -f /opt/gosbot/instance/bot/ts3audiobot.log &

child=$!
wait "$child"