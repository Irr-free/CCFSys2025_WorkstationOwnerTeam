#!/bin/bash

for file in `ls -a test_*_Test`
do
    if [[ $file == "test_main_sim_Test" || $file == "test_omega_Test" || $file == "test_output_sim_Test" ]];
    then
        echo "skip excution ${file}"
    elif [[ file == "test_main_Test" ]];
    then
        ./${file} --gtest_filter=main_Test.test_Push_SmallGraph:main_Test.test_Pull_SmallGraph
    else
        ./${file}
    fi
done