#!/bin/bash
> script_result.txt #clear contents
java -jar ../Fall18Mars.jar --noGui -n 100000 -e 1 --main $1 --argv $2 >> script_result.txt
