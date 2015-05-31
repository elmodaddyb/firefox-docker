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
    libglib2.0-dev \
    libdbus-1-dev \
    libdbus-glib-1-dev \
    libasound2-dev \
    libcurl4-openssl-dev \
    libiw-dev \
    libxt-dev \
    mesa-common-dev \
    libgstreamer0.10-dev \
    libgstreamer-plugins-base0.10-dev \
    libpulse-dev \
    m4 \
    flex \
    ccache \
    gconf-2.0 \
    libgconf2-dev

##--------------------------------------
## Create the firefox dev user
##--------------------------------------

RUN groupadd ffdev -g 1001\
  && useradd -g ffdev -s /bin/bash ffdev

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
USER ffdev

ENTRYPOINT ["java", "-jar", "/usr/share/jenkins/jenkins.war"]
EXPOSE 8080
CMD [""]
