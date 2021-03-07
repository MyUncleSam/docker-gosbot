#!/bin/bash
if [ ! -f /opt/gosbot/instance/bot/TS3AudioBot.dll ]; then
    echo "This is the first start of this container - starting installation procedure for key: ${GOSBOT_KEY}"

    # start installation using Ubuntu 18.04 (2) and the given port
    echo -e "2\n${GOSBOT_PORT}\n" | /root/gosbot_installer.sh "a17ff793419d55df5195e5fc6a7d40b1c250f81e933302355e36016e1b05c005"
fi

echo "OS Date: $(date)"

# update
if [ "$GOSBOT_UPDATE" = "1" ] || [ $GOSBOT_UPDATE = "true" ]; then
    echo "Updating gosbot"
    /usr/sbin/gosbot update

    echo "Waiting 5 seconds to process update ..."
    sleep 5
fi

echo "Starting gosbot server"
cd /opt/gosbot/instance/bot
#/opt/gosbot/dotnet/./dotnet /opt/gosbot/instance/bot/TS3AudioBot.dll
/usr/bin/dotnet /opt/gosbot/instance/bot/TS3AudioBot.dll
