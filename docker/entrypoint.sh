#!/bin/bash

/opt/python/bin/python3 -m pip install .

user="$1"
shift

useradd $user
su - $user

/home/mussel/.local/bin/pyinstaller $@
