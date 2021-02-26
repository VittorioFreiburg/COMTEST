#!/bin/bash
rm -R build
rm -R heading.egg-info
rm -R heading/headm.c
python setup.py install
