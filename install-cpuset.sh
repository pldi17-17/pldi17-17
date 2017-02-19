#!/bin/bash
if [ "$#" -ne 1 ] ; then
  echo "install-cpuset.sh <clonedir>"
  exit 1
fi
git clone https://github.com/lpechacek/cpuset $1/cpuset
cd $1/cpuset
sudo python setup.py install
