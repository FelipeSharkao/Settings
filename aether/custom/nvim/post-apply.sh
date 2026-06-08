#!/bin/bash

for server in $(nvr --serverlist); do
    nvr --nostart --servername "$server" '+colorscheme aether'
done
