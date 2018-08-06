FROM centos:centos7

# MAINTAINER Kirin "https://github.com/bekylin/hue"

RUN echo 'nameserver 114.114.114.114' > /etc/resolv.conf && echo 'nameserver 8.8.8.8' >> /etc/resolv.conf && yum install -y wget
    # \  
    # && mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup \
    # && wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

# *************  安装Java, Maven 以及其他必要组件 *************

### http://www-us.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.zip
WORKDIR /tmp

RUN yum update -y && yum install -y unzip java-1.8.0-openjdk-devel.x86_64 

RUN wget -O /tmp/apache-maven-3.5.4-bin.zip  http://7xslql.com1.z0.glb.clouddn.com/apache-maven-3.5.4-bin.zip \
    && unzip -q /tmp/apache-maven-3.5.4-bin.zip && mkdir -p /usr/local/maven/apache-maven-3.5.4 && mv apache-maven-3.5.4 /usr/local/maven/ \
    && ln -s /usr/local/maven/apache-maven-3.5.4 /usr/local/maven/mvnhome && echo 'export MAVEN_HOME=/usr/local/maven/mvnhome' >> /etc/profile \
    && echo 'export PATH=$MAVEN_HOME/bin:$PATH' >> /etc/profile && source /etc/profile && rm /tmp/apache-maven-3.5.4-bin.zip

RUN echo 'export MAVEN_HOME=/usr/local/maven/mvnhome' >> ~/.bashrc \
    && echo 'export PATH=$MAVEN_HOME/bin:$PATH' >> ~/.bashrc \
    && echo 'export JAVA_HOME=/etc/alternatives/jre' >> ~/.bashrc


# *************  安装Hue编译依赖的包 *************
RUN yum clean all && yum update -y && yum -y install gcc-c++ asciidoc cyrus-sasl-devel cyrus-sasl-gssapi krb5-devel libxml2-devel \
    libxslt-devel mysql-devel openldap-devel python-devel sqlite-devel openssl-devel gmp-devel \
    ant cyrus-sasl-plain gcc libffi-devel make mysql

RUN yum install -y git

WORKDIR /
RUN git clone https://github.com/cloudera/hue.git
WORKDIR hue
RUN make apps
EXPOSE 8888
# VOLUME /hue/desktop/