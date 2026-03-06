# Regex Sandbox

Данный репозиторий содержит файлы для развёртывания docker контейнера с ограниченным окружением, подключение к которому осуществляется по SSH. Окружение содержит текстовые образцы и утилиты для работы с регулярными выражениями, так же есть возможность использовать пользовательский ввод (текст размером до 5 Кб).

## Использование

```bash
git clone https://github.com/HappyTrashBin/Regex-Sandbox
mkdir fingerprint-ssh
sudo ssh-keygen -t rsa (ключи сохранить в файл ./fingerprint-ssh/ssh_host_rsa_key)
docker build --build-arg USER_PASSWORD=[PASSWORD] -t regex .
docker run --restart=unless-stopped --cpus="1" --memory="512m" -d --hostname regex --name regex-debian-p 2222:22 regex
```

## Структура проекта

```bash
├── buildin.sh
├── commands
│   ├── helpme
│   ├── info.txt
│   ├── ls
│   ├── nano
│   ├── regex_info
│   └── rm
├── data
│   ├── animals.txt
│   ├── emails.txt
│   ├── html.txt
│   ├── json.txt
│   ├── letters.txt
│   ├── numbers.txt
│   ├── phone-numbers.txt
│   ├── ssh-logs.txt
│   └── versions.txt
├── dockerfile
├── fingerprint-ssh
│   ├── ssh_host_rsa_key
│   └── ssh_host_rsa_key.pub
├── hello.txt
├── make_chroot.sh
└── restricted.sh
```

