

FROM base/archlinux
MAINTAINER Bram Neijt <bneijt@gmail.com>
RUN pacman --noprogressbar --noconfirm -Sy ansible python2-pip; \
    ln -s /usr/bin/python2 /usr/bin/python
ADD assets /tmp/assets
ADD init.sh /

RUN ansible-playbook -i "localhost," -c local /tmp/assets/playbook.yml

CMD ["/bin/bash", "/init.sh"]
