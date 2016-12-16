#!/bin/bash

/etc/init.d/ssh start
/usr/bin/codebox run -u $CODEBOX_USERNAME:$CODEBOX_PASSWORD
