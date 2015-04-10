#
# Copyright 2015, Clinton Freeman
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
FROM ubuntu:14.04

MAINTAINER Clinton Freeman

# Install prerequisites.
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN apt-get -y install lib32z1 lib32ncurses5 lib32bz2-1.0 lib32stdc++6
RUN echo "y" | apt-get -y install oracle-java7-installer
RUN apt-get -y install ant
RUN apt-get -y install curl

# Install Android development environment.
RUN curl -L -O http://dl.google.com/android/android-sdk_r24.1.2-linux.tgz && tar xf android-sdk_r24.1.2-linux.tgz

# Set environment variables.
ENV ANDROID_HOME /android-sdk-linux
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools

# Update the SDK with some tooling.
RUN echo "y" | android update sdk -u -a --filter platform-tools,android-19,build-tools-19.1.0,sysimg-19

WORKDIR /android

# Copy my Android application over into the docker container for compilation.
COPY assets/ /android/assets/
COPY bin/ /android/bin/
COPY gen/ /android/gen/
COPY libs/ /android/libs/
COPY res/ /android/res/
COPY src/ /android/src/

COPY AndroidManifest.xml /android/
COPY ant.properties /android/
COPY build.xml /android/
COPY local.properties /android/
COPY project.properties /android/

# Build the Android application within the docker container.
RUN ant debug

