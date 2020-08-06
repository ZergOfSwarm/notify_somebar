#!/bin/bash
IP_LEIKKIKUJA='10.19.0.18'
port=9753 # Указываем порт. Такой же порт должен быть и в скрипте Run_somebar.sh!

green() { #https://stackoverflow.com/questions/12137431/test-if-a-command-outputs-an-empty-string
if [ -z "$(ss -tulpn | grep ':$port' 2> /dev/null)" ]; then 
    #echo "Порт свободен!"
    #somebar -p $port 2> /dev/null  #Где "2> /dev/null" - игнорим предупреждения! (Так не работает! Нужно запускать отдельным скриптом!)
    /home/denis/.scripts/run_somebar.sh &> /dev/null # Запуск скрипта который включает somebar на порту $port
    sleep 1 
    echo -n "green" | nc -u  localhost $port  &
else
    #echo "Порт задействован!"
    echo -n "green" | nc -u  localhost $port  &
fi
}

white() {
if [ -z "$(ss -tulpn | grep ':$port' 2> /dev/null)" ]; then
    #echo "Порт свободен!"
    #somebar -p $port 2> /dev/null  #Где "2> /dev/null" - игнорим предупреждения! (Так не работает! Нужно запускать отдельным скриптом!)
    /home/denis/.scripts/run_somebar.sh &> /dev/null # Запуск скрипта который включает somebar на порту $port
    sleep 1
    echo -n "white" | nc -u  localhost $port  &
else
    #echo "Порт задействован!"
    echo -n "white" | nc -u  localhost $port  &
fi
}

question() {
if [ -z "$(ss -tulpn | grep ':$port' 2> /dev/null)" ]; then #Где "2> /dev/null" - игнорим предупреждения!
    #echo "Порт свободен!"
    #somebar -p $port 2> /dev/null (Так не работает! Нужно запускать отдельным скриптом!)
    /home/denis/.scripts/run_somebar.sh &> /dev/null # Запуск скрипта который включает somebar на порту $port
    sleep 1
    echo -n "question" | nc -u  localhost $port  &
else
    #echo "Порт задействован!"
    echo -n "question" | nc -u  localhost $port  &
fi
}

function ping_ip {
    #echo "Пингую 'IP' - ${IP_LEIKKIKUJA}" 
    ping -q -c2 ${IP_LEIKKIKUJA} &> /dev/null # Скрываем вывод команды "ping" при помощи (&> /dev/null) 
    if [ $? -eq 0 ]
    then
        #echo ${IP_LEIKKIKUJA} " - пингуется, cool!"
        green
    else
        #echo ${IP_LEIKKIKUJA} " - НЕ пингуется!"
        white
    fi
}

TIMESTAMP=`date +%s`
while [ 1 ]
  do
    nc -z -w 5 8.8.8.8 53  >/dev/null 2>&1
online=$?
    TIME=`date +%s`
    if [ $online -eq 0 ]; then
      #echo "`date +%Y-%m-%d_%H:%M:%S_%Z` 1 $(($TIME-$TIMESTAMP))" | tee -a log.csv
      #echo "`date +%Y-%m-%d_%H:%M:%S_%Z`"
      #echo "Инет есть!"
      ping_ip
    else
      #echo "`date +%Y-%m-%d_%H:%M:%S_%Z` 0 $(($TIME-$TIMESTAMP))" | tee -a log.csv
      #echo "`date +%Y-%m-%d_%H:%M:%S_%Z`"
      #echo "Нет интернет соединения!"
      question
    fi
    TIMESTAMP=$TIME
    sleep 5
  done;

