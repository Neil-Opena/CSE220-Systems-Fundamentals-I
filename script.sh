#!/bin/bash
# put the inputs in this array
declare -a input=(
  'C 8154 8 7'
  'C 000 5 10'
  'C 23568 9 10'
  'C 0101 3 8'
  'C 4123 5 5'
  'C 111102365 7 2'
)

# put the expected output in this array
declare -a output=(
  'INVALID ARGS'
  '0'
  '15776'
  '12'
  '4123'
  '11001101001100001100000'
)

for ((i=0;i<${#input[@]};++i)); do
    result=$(echo "$(java -jar ../Fall18Mars.jar --noGui -n 10000 -e 1 --main $1 --argv ${input[i]})" | tail -n1)
    echo $result
    echo ${output[i]}
    echo "---------------------------------------------"
done
