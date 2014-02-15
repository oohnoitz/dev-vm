#!/bin/bash

if [ ! -f ~/.deploy/init-node-000 ]
then
  npm install -g grunt-cli david bower less
fi