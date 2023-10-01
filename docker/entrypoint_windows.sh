#!/bin/bash

wine C:\\Python\\python.exe -m pip install .
wine C:\\Python\\Scripts\\pyinstaller.exe $@
