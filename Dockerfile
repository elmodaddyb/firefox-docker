# Dockerfile for Ubuntu Firefox Development
# Created by: Eamonn Buss
# Created on: 05/25/2015
# Purpose: A docker file to create a docker container for Firefox Development

##--------------------------------------
## Start with UBUNTU image as the base
##--------------------------------------
FROM ubuntu:latest

##--------------------------------------
## Maintainer - Eamonn Buss
##--------------------------------------
MAINTAINER Eamonn Buss <eamonn@srcdevbin.com>

##--------------------------------------
## Install Firefox Ubuntu Linux Prerequisites
##--------------------------------------

RUN apt-get update && apt-get install -y \
    zip \
    unzip \
    mercurial \
    g++ \
    make \
    autoconf2.13 \
    yasm \
    libgtk2.0-dev \
    libgtk-3-dev \
    libglib2.0-dev \
    libdbus-1-dev \
    libdbus-glib-1-dev \
    libasound2-dev \
    libcurl4-openssl-dev \
    libiw-dev \
    libxt-dev \
    libx11-dev \
    xorg-dev \
    libx11-xcb-dev \
    mesa-common-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libpulse-dev \
    m4 \
    flex \
    ccache \
    gconf-2.0 \
    libgconf2-dev \
    rustc

##--------------------------------------
## Create the firefox dev user
##--------------------------------------

RUN groupadd ffdev -g 1001\
  && useradd -g ffdev -s /bin/bash ffdev

RUN echo "ffdev:changeit" | chpasswd

##--------------------------------------
## Install Jenkins
##--------------------------------------

RUN apt-get update && apt-get install wget
RUN wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
RUN sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
RUN apt-get update && apt-get install -y jenkins


##--------------------------------------
## Set up the environment
##--------------------------------------
ENV SHELL /bin/bash
ENV JENKINS_HOME /usr/share/jenkins
WORKDIR /usr/share/jenkins
RUN ["chown", "ffdev:ffdev", "-R", "/usr/share/jenkins"]
USER ffdev

##--------------------------------------
## Set local time to EST
##--------------------------------------
RUN ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime

ENTRYPOINT ["java", "-jar", "/usr/share/jenkins/jenkins.war"]
EXPOSE 8080
CMD [""]
