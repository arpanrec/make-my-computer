#!/bin/bash
set -e

if command -v javac &> /dev/null ; then
	javacexecpath=$(readlink -f $(which javac))
	export JAVA_HOME=${javacexecpath::-9}
elif command -v java &> /dev/null ; then
	echo "Java compiler not installed which is not recommended, Using java instead"
	javaexecpath=$(readlink -f $(which java))
	export JAVA_HOME=${javaexecpath::-9}
else
	echo "Java not installed, please install java"
fi

if command -v mvn &> /dev/null ; then
	mvnexecpath=$(readlink -f $(which mvn))
	export M2_HOME=${mvnexecpath::-8}
	export MAVEN_HOME=${M2_HOME}
else
	echo "maven not installed, please install maven"
fi
