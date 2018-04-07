#!/bin/bash

set -e
set -x

cd debootstrap
./debootstrap --second-stage
