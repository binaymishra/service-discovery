#!/bin/sh

# pick up the local user's email address from git config unless manually
# set in the USER_EMAIL variable

if [ -z "${USER_EMAIL}" ] ; then
    USER_EMAIL=`git config --get user.email`

    if [ -z "${USER_EMAIL}" ] ; then
 echo "Unable to detect your email address using git config"
 echo "Please set USER_EMAIL and re-run this script"
 exit 1
    fi
fi

# grab the artifact and version from gradle.env and settings.gradle

artifact=`grep "rootProject.name" settings.gradle  | cut -f2 -d= | tr -d " '"`
version=`grep "^version=" gradle.properties | cut -d= -f2`

if [ -z "${artifact}" ] || [ -z "${version}" ]; then
    echo "Unable to determine artifact and version from gradle.env and settings.gradle"
    exit 2
fi

cd build/libs

java -server -Xmx300M -XX:+UseG1GC \
     -Denv=local \
     -Dserver.port=8761 \
     -jar "${artifact}-${version}.jar" \
