#!/bin/sh
hname="`hostname`"
if [ x$hname = xe495 ]; then
    ./testspeed-ryzen3.sh $@
    exit
fi
if [ x$hname = xairc ]; then
    ./testspeed-air.sh $@
    exit
fi

make -C build
which performance && performance
if [ -z "$@" ]; then
    test -f log.speed && mv log.speed log.speed.bak
    (for g in `build/SMHasher --listnames`; do \
         build/SMHasher --test=Speed,Hashmap $g 2>&1; done) | tee log.speed
    ./speed.pl && \
        ./fixupdocspeeds.pl
else
     (for g in `build/SMHasher --listnames | egrep "$@"`; do \
         build/SMHasher --test=Speed,Hashmap $g 2>&1; done) | tee "log.speed-$1"
    ./speed.pl "log.speed-$1" && \
        ./fixupdocspeeds.pl "log.speed-$1"
fi
