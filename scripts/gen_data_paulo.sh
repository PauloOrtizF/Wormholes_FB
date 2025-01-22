#!/bin/bash

for j in $(seq 0 100)
do
    echo "Running iteration: $j"
    python -m scripts.gen_data --num $j --batch_size 100 --gen_version $1
done