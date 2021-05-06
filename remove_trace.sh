#!/bin/bash

cd src

for i in `ls *.c`;
do
	echo $i
	cat $i | grep -v NNN | grep -v HHH | grep -v XXX > $i.tmp
	mv $i.tmp $i
done

cd ..



