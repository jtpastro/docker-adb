FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

ENV SDK_VERSION         34.0.0
ENV ANDROID_SDK_VERSION 11076708
ENV OPENJDK_VERSION     17
ENV ANDROID_HOME        /opt/android-sdk-linux
ENV ANDROID_SDK_HOME    ${ANDROID_HOME}
ENV ANDROID_SDK_ROOT    ${ANDROID_HOME}
ENV ANDROID_SDK         ${ANDROID_HOME}

ENV PATH "${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin"
ENV PATH "${PATH}:${ANDROID_HOME}/cmdline-tools/tools/bin"
ENV PATH "${PATH}:${ANDROID_HOME}/tools/bin"
ENV PATH "${PATH}:${ANDROID_HOME}/build-tools/${SDK_VERSION}"
ENV PATH "${PATH}:${ANDROID_HOME}/platform-tools"
ENV PATH "${PATH}:${ANDROID_HOME}/emulator"
ENV PATH "${PATH}:${ANDROID_HOME}/bin"

RUN dpkg --add-architecture i386 && \
    apt-get update -yqq && \
    apt-get install -y libc6:i386 libstdc++6:i386 zlib1g:i386 openjdk-${OPENJDK_VERSION}-jdk wget unzip && \
    apt-get clean

RUN groupadd android && useradd -d /opt/android-sdk-linux -g android android

WORKDIR /opt/android-sdk-linux

RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip && \
	unzip *tools*linux*.zip -d ${ANDROID_HOME}/cmdline-tools && \
	mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/tools && \
	rm *tools*linux*.zip

RUN mkdir /root/.android/ && \
    touch /root/.android/repositories.cfg && \
    yes Y | sdkmanager --licenses && \ 
    yes Y | sdkmanager --no_https "platform-tools" "build-tools;${SDK_VERSION}"
