FROM openmandriva/cooker

RUN urpmi --auto --auto-update --no-verify-rpm \
 && urpmi --no-suggests --no-verify-rpm --auto mock-urpm git curl sudo ruby ruby-devel \
 && rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime \
 && adduser omv \
 && usermod -a -G mock-urpm omv \
 && chown -R omv:mock-urpm /etc/mock-urpm \
 && sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers \
 && echo "%mock-urpm ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && usermod -a -G wheel omv \
 && curl -L get.rvm.io | bash -s stable \
 && source /home/omv/.rvm/scripts/rvm \
 && rvm install ruby-2.2.3 \
 && rvm gemset create abf-worker \
 && rvm use ruby-2.2.3@abf-worker --default \
 && rm -rf /var/cache/urpmi/rpms/*

## put me in RUN if you have more than 16gb of RAM
# && echo "tmpfs /var/lib/mock-urpm/ tmpfs defaults,size=4096m,uid=$(id -u omv),gid=$(id -g omv),mode=0700 0 0" >> /etc/fstab \
#

WORKDIR ["/home/omv"]

ADD ./build-rpm.sh /build-rpm.sh
ADD ./config-generator.sh /config-generator.sh
ADD ./download_sources.sh /download_sources.sh

USER omv
ENV HOME /home/omv
