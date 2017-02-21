#!/bin/bash
if [ "$#" -ne 1 ] ; then
echo "init-lnt.sh <sandbox dir>"
exit 1
fi

dir=`pwd`
virtualenv $1
$1/bin/pip install --upgrade pip
$1/bin/pip install six==1.9.0
$1/bin/python ${dir}/lnt/setup.py develop
