#!/bin/bash

mkdir -p "$1"    # Создаём директорию для chroot, если её нет
CURRENT_DIR="$1" # Сохраняем имя основной chroot директории в переменную
shift            # Убираем первый аргумент из переданных,
                 # теперь в аргументах останутся только нужные команды

# Перебор указанных в аргументах команд
for arg in "$@"; do
	util=$(which $arg) # Получаем абсолютный путь до команды
	if [ "$util" ]; then # Если команда существует, то ...
		libs=$(ldd $util) # Сохраняем вывод команды ldd
                # Копируем все библиотеки из вывода ldd с сохранением
                # оригинального пути, кроме первой
		echo "$libs" | grep "lib" | awk '{print $(NF-1)}' \
		| while read -r lib; do
			if [ -f "$lib" ]; then
				mkdir -p "$(dirname "$CURRENT_DIR$lib")"
				cp "$lib" "$CURRENT_DIR$lib"
			fi
		done
                # Копируем исполняемый файл команды в поддиректорию /usr/bin
		mkdir -p "$(dirname "$CURRENT_DIR/usr/bin/$arg")"
		cp "$util" "$(dirname "$CURRENT_DIR/usr/bin/$arg")"
	else # Если команды не существует, то ...
		echo "no such command: $arg"
	fi
done
