#!/bin/bash

# Построчная обработка вывода команды enable
while read -r enable command ; do
    # Фильтруем команды, которые нужно оставить доступными
    case "$command" in
    enable | logout | exit | echo ) ;;
    # Записываем строку с запретом в указанную в первом аргументе директорию
    * ) echo "enable -n $command" >> $1 ;;
    esac
done <<< $(enable)

# Запрещаем саму enable, чтобы нельзя было откатить запреты
echo "enable -n enable" >> $1
