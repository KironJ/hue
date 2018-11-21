FROM centos:centos7

# MAINTAINER Kirin "https://github.com/bekylin/hue"

# *************  安装Java, Maven 以及其他必要组件 *************
ENV JAVA_VERSON 1.8.0
ENV MAVEN_VERSION 3.3.9

RUN yum update -y && \
  yum install -y curl && \
  yum install -y java-$JAVA_VERSON-openjdk java-$JAVA_VERSON-openjdk-devel.x86_64 && \
  yum install -y httpd && \
  yum clean all

RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV JAVA_HOME /etc/alternatives/jre
ENV MAVEN_HOME /usr/share/maven

# *************  安装Hue编译依赖的包 *************
RUN yum clean all && yum update -y && yum -y install gcc-c++ asciidoc cyrus-sasl-devel cyrus-sasl-gssapi krb5-devel libxml2-devel \
    libxslt-devel mysql-devel openldap-devel python-devel sqlite-devel openssl-devel gmp-devel \
    ant cyrus-sasl-plain gcc libffi-devel make mysql git

RUN git clone https://github.com/cloudera/hue.git
WORKDIR hue
RUN git checkout release-4.3.0 
RUN make install 
RUN /hue/build/env/bin/pip install logilab-astng
RUN make apps
EXPOSE 8888
