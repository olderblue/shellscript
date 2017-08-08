#!/bin/sh
checkUrl()
{
    CODE=$(curl --head -s $1 | awk 'NR==1{print $2}')
    if [ -z $CODE ];then
        sendErrorMessages $1;
        changeStatus $1 1
    else
        if [ $CODE -ne 200 ];then
            if [ $CODE -eq 301 -o $CODE -eq 302 ];then
                changeStatus $1 0
            else
                changeStatus $1 1
                sendErrorMessages $1
            fi
        else
            changeStatus $1 0
        fi
    fi
}

changeStatus()
{
    LINENUM=$(grep -n "$1|" /home/monitor/url.list | awk -F':' '{print $1}')
    if [ $2 -eq 1 ];then
        sed -i "${LINENUM}s/0/1/" /home/monitor/url.list
    else
        checkStauts $1
        if [ $? -eq 1 ];then
            sed -i "${LINENUM}s/1/0/" /home/monitor/url.list
            sendRecoverMessages $1
        fi
    fi
}

sendErrorMessages()
{
    python /home/monitor/weixin.py "$1 is down!"
}

sendRecoverMessages()
{
    python /home/monitor/weixin.py "$1 is recover!"
}

checkStauts()
{
    STATUSCODE=$(awk -F'|' -v url=$1 '$1==url{print $2}' /home/monitor/url.list)
    return $STATUSCODE
}

for i in $(awk -F'|' '{print $1}' /home/monitor/url.list);do
	checkUrl $i
done

#checkUrl $1

