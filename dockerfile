FROM debian:bookworm-slim 
ARG USER_PASSWORD 
ARG USER_NAME="regex" 

RUN apt update -y && apt upgrade -y && apt install -y ssh 
RUN useradd -m -s /usr/bin/rbash ${USER_NAME}
RUN echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd 

WORKDIR /home
COPY ./make_chroot.sh .
RUN apt install -y ripgrep nano
RUN ./make_chroot.sh ${USER_NAME} ls rbash cat grep awk rg tr wc sed clear head tail nano rm

RUN mkdir -p /run/sshd
RUN chown -R root:root ${USER_NAME}
RUN echo "PermitRootLogin no" >> /etc/ssh/sshd_config
RUN echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config
RUN echo "ChrootDirectory /home/${USER_NAME}" >> /etc/ssh/sshd_config
RUN echo "ForceCommand rbash --login" >> /etc/ssh/sshd_config
RUN rm /etc/ssh/*key*
COPY ./fingerprint-ssh/* /etc/ssh

COPY ./buildin.sh .
COPY ./restricted.sh .
RUN mv ${USER_NAME}/usr/bin/nano ${USER_NAME}/usr/bin/nano.old
RUN mv ${USER_NAME}/usr/bin/rm ${USER_NAME}/usr/bin/rm.old
RUN mv ${USER_NAME}/usr/bin/ls ${USER_NAME}/usr/bin/ls.old

WORKDIR /home/${USER_NAME}
RUN ls -a | grep -E "^\.[^.\s]+" | xargs rm
RUN mkdir etc
COPY hello.txt etc/hello.txt
COPY ./data/* .
COPY ./commands/* usr/bin/
RUN echo "PS1='\033[1;32m${USER_NAME}@\h\033[0m:\033[1;34m\w\033[0m\$ '" >> etc/profile
RUN echo "cat /etc/hello.txt" >> etc/profile
RUN echo "helpme .old rm .txt rbash" >> etc/profile
RUN echo "alias helpme='helpme .old rm .txt rbash'" >> etc/profile
RUN echo "readonly PATH=/usr/bin" >> etc/profile
RUN echo "readonly TMOUT=180" >> etc/profile

RUN mkdir usr/data
RUN chmod 777 usr/data
RUN echo "readonly TERM=xterm-16color" >> etc/profile
RUN mkdir -p usr/share/terminfo
RUN cp -R --preserve=mode /usr/share/terminfo/* usr/share/terminfo

RUN echo "readonly USER_ID=\$$" >> etc/profile
RUN echo "export USER_ID" >> etc/profile
RUN echo "trap 'rm \"/usr/data/data_\${$}.txt\"' EXIT" >> etc/profile

RUN /home/restricted.sh etc/profile nano.old rbash rm.old ls.old
RUN /home/buildin.sh etc/profile

CMD ["/usr/sbin/sshd", "-D"]
EXPOSE 22/tcp
