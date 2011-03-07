#!/bin/bash

# Process all jpeg files found in the given path with the given script/command

#unrotate-fred-20090509.sh -f 10 $f $f
#redist-fred-20090716.sh -g -m HSL 60,60,60 $f $f
#autowhite-fred-20090603.sh -m 1 -p 1 $f $f
#retinex-fred-20080530.sh -m RGB -f 80 -s 70  $f $f
#identify -set copyright "Jukka Paasonen" -set author "Jukka Paasonen" $f

for f in $(find $1 -iname "*.jpg")
do
 if [ -a $f ]; then
  sips -i $f
 fi
done