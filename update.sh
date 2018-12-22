#!/bin/bash
git pull
rm -rf site
pip install -r ./requirements.txt
mkdocs build
