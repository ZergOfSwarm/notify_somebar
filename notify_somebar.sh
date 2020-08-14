#!/bin/bash
IP_LEIKKIKUJA='10.19.0.22'
port=9753 # Указываем порт. Такой же порт должен быть и в скрипте Run_somebar.sh!
flag='false' # Флаг опущен.
LOCATION="/home/denis/Desktop/" # Указываем путь для удаления лог файла.
REQUIRED_FILES="test.log" # Указываем как называется файл который нужно удалить.
minuts=300 # Указываем количество минут по истеченни котрых удаляем лог файл. (1440 - сутки)
LOGFILE="/home/denis/Desktop/test.log"
#time_now=$(date +"%H:%M:%S %d-%m-%Y")

green() { #https://stackoverflow.com/questions/12137431/test-if-a-command-outputs-an-empty-string
    time_now=$(date +"%H:%M:%S %d-%m-%Y")
    #echo "Флаг сейчас - "  $flag # Для отладки
    if [ -z "$(ss -tulpn | grep $port)" ] && [ flag != 'green' ]; then # объяснение, что такое "-z" https://linux.die.net/man/1/test 
        #echo "Порт свободен!"
        #somebar -p $port 2> /dev/null  #Где "2> /dev/null" - игнорим предупреждения! (Так не работает! Нужно запускать отдельным скриптом!)
        /home/denis/.scripts/run_somebar.sh &> /dev/null # Запуск скрипта который включает somebar на порту $port
        sleep 3
        echo -n "green" | nc -u  localhost $port  &
        flag=green # Поднимаем зеленый флаг "светофор"!
        echo "$time_now Время-1 включения!" >> $LOGFILE # Пишем в лог файл.
    else
       if [[ $flag != 'green' ]]; then
        #echo "Порт задействован!"
        echo -n "green" | nc -u  localhost $port  &
        flag=green # Поднимаем зеленый флаг "светофор"!
        echo "$time_now Время-2 включения!" >> $LOGFILE # Пишем в лог файл.
       fi
    fi
}

white() { #https://stackoverflow.com/questions/12137431/test-if-a-command-outputs-an-empty-string
    time_now=$(date +"%H:%M:%S %d-%m-%Y")
    #echo "Флаг сейчас - "  $flag # Для отладки
    if [ -z "$(ss -tulpn | grep $port)" ] && [ flag != 'white' ]; then # объяснение, что такое "-z" https://linux.die.net/man/1/test 
        #echo "Порт свободен!"
        #somebar -p $port 2> /dev/null  #Где "2> /dev/null" - игнорим предупреждения! (Так не работает! Нужно запускать отдельным скриптом!)
        /home/denis/.scripts/run_somebar.sh &> /dev/null # Запуск скрипта который включает somebar на порту $port
        sleep 3
        echo -n "white" | nc -u  localhost $port  &
        flag=white # Поднимаем белый флаг "светофор"!
        echo "$time_now Время-3 ОТКлючения!" >> $LOGFILE # Пишем в лог файл.
    else
       if [[ $flag != 'white' ]] && [[ flag != new_flag ]]; then
        #echo "Порт задействован!"
        echo -n "white" | nc -u  localhost $port  &
        #flag=$new_flag
        flag=white # Поднимаем белый флаг "светофор"!
        echo "$time_now Время-4 ОТКлючения!" >> $LOGFILE # Пишем в лог файл.
       fi
    fi
}

question() { #https://stackoverflow.com/questions/12137431/test-if-a-command-outputs-an-empty-string
    time_now=$(date +"%H:%M:%S %d-%m-%Y")
    #echo "Флаг сейчас - "  $flag # Для отладки
    if [ -z "$(ss -tulpn | grep $port)" ] && [ flag != 'question' ]; then # объяснение, что такое "-z" https://linux.die.net/man/1/test 
        #echo "Порт свободен!"
        #somebar -p $port 2> /dev/null  #Где "2> /dev/null" - игнорим предупреждения! (Так не работает! Нужно запускать отдельным скриптом!)
        /home/denis/.scripts/run_somebar.sh &> /dev/null # Запуск скрипта который включает somebar на порту $port
        sleep 3
        echo -n "question" | nc -u  localhost $port  &
        flag=question # Поднимаем флаг '?' "светофор"!
        echo "$time_now Время-5 когда отвалился инет!" >> $LOGFILE # Пишем в лог файл.
    else
       if [[ $flag != 'question' ]] && [[ flag != new_flag ]]; then
        #echo "Порт задействован!"
        echo -n "question" | nc -u  localhost $port  &
        #flag=$new_flag
        flag=question # Поднимаем флаг '?' "светофор"!
        echo "$time_now Время-6 когда отвалился инет!" >> $LOGFILE # Пишем в лог файл.
       fi
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

while [ 1 ]
  do
    find $LOCATION -name $REQUIRED_FILES -type f -mmin +$minuts -delete # Удаляем лог файл по истечении времени!
    nc -z -w 5 8.8.8.8 53
    online=$?
    if [ $online -eq 0 ]; then
      #echo "Инет есть!"
      ping_ip
    else
      #echo "Нет интернет соединения!"
      question
    fi
    sleep 1
  done;
