#!/bin/bash

# Построчная обработка вывода команды enable
while IFS= read -r line; do
	command=$(echo $line | awk '{printf $2}') # Очищаем строку
	# Фильтруем команды, которые нужно оставить доступными
	if [ "$command" = "enable" ] \
	|| [ "$command" = "logout" ] \
	|| [ "$command" = "exit" ] \
	|| [ "$command" = "echo" ]; then continue; fi
	# Записываем строку с запретом в указанную в первом аргументе директорию
	echo "enable -n $command" >> $1
done <<< $(enable)

# Запрещаем саму enable, чтобы нельзя было откатить запреты
echo "enable -n enable" >> $1
