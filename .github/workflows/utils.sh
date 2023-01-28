#!/bin/bash

function normalise(){
    echo $1 | tr '[:lower:]' '[:upper:]' | sed 's/\//_/g' | tr -d '"'
}