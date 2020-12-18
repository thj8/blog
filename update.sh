#!/bin/bash
git pull
rm -rf site
pip3 install -r ./requirements.txt
mkdocs build
