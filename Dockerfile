# jenkins-mono, openjdk 8, with debian buster
# Fork from https://raw.githubusercontent.com/74th//master/Dockerfile
#            https://github.com/74th/jenkins-dotnet
# docker pull akrisiun/buster-wine:latest
# docker build -t akrisiun/jenkins-mono .

# docker run -d --name jenk8080 -p 8080:8080 akrisiun/jenkins-mono
# TEST:
# docker run -it -d --name jenk8080 -p 8080:8080 akrisiun/jenkins-mono /bin/bash
# IP=192.168.1.9 docker run -d -e DISPLAY=$IP:0 --name jenk8090 -p 8090:8080 akrisiun/jenkins-mono

FROM akrisiun/buster-wine
LABEL maintainer="AndriusK<akrisiun@gmail.com>"

# lib-mono 4.6.2
RUN apt-get update && \
    apt-get install -y wget git mono-complete nuget \
                       apt-transport-https curl wget bzip2 unzip xz-utils gnupg2 nano \
    --no-install-recommends

# gnupd2 ??
# install jenkins

# LTS
# wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -

# ENV JAVA_VERSION 10.0.2
# ENV JAVA_DEBIAN_VERSION 10.0.2+13-2
# RUN apt-get install -y openjdk-10-jre-headless nginx
RUN ln -svT /docker-java-home/bin/java /usr/local/bin/java; \
    mkdir /usr/share/man/man1
RUN apt-get install -y openjdk-8-jre-headless nginx

# do some fancy footwork to create a JAVA_HOME that's cross-architecture-safe
# RUN ln -svT "/usr/lib/jvm/java-10-openjdk-$(dpkg --print-architecture)" /docker-java-home
# ENV JAVA_HOME /docker-java-home

ADD https://jenkins-ci.org/debian/jenkins-ci.org.key /root/jenkins-ci.org.key
RUN apt-key add - < /root/jenkins-ci.org.key
RUN sh -c 'echo deb http://pkg.jenkins.io/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
#   sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' && \

RUN apt-get update && \
    apt-get install -y jenkins

# msbuild.exe
RUN ln -s /usr/bin/xbuild /usr/bin/msbuild.exe && \
    mono -V && \
    java -version

#Requests from outside
# iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080
#Requests from localhost
# iptables -t nat -I OUTPUT -p tcp -d 127.0.0.1 --dport 80 -j REDIRECT --to-ports 8080    

# install plugins 
ADD nginx/jenkins /root/
ADD ./InstallPlugins.sh /root/

# RUN sh /root/InstallPlugins.sh
RUN service jenkins start

# RUN /etc/init.d/jenkins status
# RUN /etc/init.d/jenkins start

# jenkins port
EXPOSE 8080

# jenkins home
# VOLUME /var/lib/jenkins
# VOLUME /var/log/jenkins

# RUN echo "hoge" > /var/log/jenkins/jenkins.log
# RUN chown jenkins:jenkins /var/log/jenkins/jenkins.log

ENTRYPOINT touch /var/log/jenkins/jenkins.log | chown jenkins:jenkins /var/log/jenkins/jenkins.log | service jenkins start | tail -f /var/log/jenkins/jenkins.log

