#!/bin/bash
while [ : ]
do
    pm2 restart proxy
    #random 30-60
    sleep $(( $RANDOM % 180 + 180 ));
done
