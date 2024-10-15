#!/bin/bash

cmp_error_output()
{
    filename=$1
    output=$(./pathfinder $filename 2>&1 | cat -e)
    error_string=$2

    if [ "$output" == "$error_string" ]; then
        echo "Error output matches."
    else
        echo "****************************"
        echo "Error output does not match."
        echo "Output: ${output}"
        echo "Input file: ${filename}"
        echo "Expected: ${error_string}"
        echo "****************************"
    fi
}

cmp_output()
{
    filename=$1
    output=$(./pathfinder $filename)
    output_string=$2

    if [ "$output" == "$output_string" ]; then
        echo "Output matches."
    else
        echo "$output_string" > answer_buffer.txt
        echo "$output" > buffer.txt
        difference=$(diff buffer.txt answer_buffer.txt)
        echo "****************************"
        echo "Output does not match."
        echo "Input file: ${filename}"
        echo "Difference: ${difference}"
        echo "****************************"
        rm -f answer_buffer.txt
        rm -f buffer.txt
    fi
}

cmp_output_to_file()
{
    filename=$1
    answer_filename=$2
    output=$(./pathfinder $filename | cat -e)
    output_string=$(cat -e $answer_filename)

    if [ "$output" == "$output_string" ]; then
        echo "Output matches."
    else
        ./pathfinder $filename > buffer.txt
        difference=$(diff buffer.txt $answer_filename)
        echo "****************************"
        echo "Output does not match."
        echo "Input file: ${filename}"
        echo "Difference: ${difference}"
        echo "****************************"
        rm -f buffer.txt
    fi
}

cmp_valgrind_output()
{
    filename=$1
    #valgrind --leak-check=full          --show-leak-kinds=all          --track-origins=yes          --verbose 
    output=$(valgrind --leak-check=full --show-leak-kinds=all --verbose ./pathfinder $filename 2>&1)
    expected_substring1="in use at exit: 0 bytes in 0 blocks"
    expected_substring2="ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)"

    if [[ "$output" =~ "$expected_substring1" && "$output" =~ "$expected_substring2" ]]; then
        echo "No leaks"
    else
        echo "****************************"
        echo "Some leaks detected"
        echo "Input file: ${filename}"
        echo "****************************"
    fi
}


{
    output=$(./pathfinder empty empty 2>&1 | cat -e)
    static_string="usage: ./pathfinder [filename]$"

    if [ "$output" == "$static_string" ]; then
        echo "Error output matches."
    else
        echo "****************************"
        echo "Error output does not match."
        echo "Output: ${output}"
        echo "Input file: empty"
        echo "Expected: ${static_string}"
        echo "****************************"
    fi
}

cmp_error_output islands "error: file islands does not exist$"
cmp_error_output empty "error: file empty is empty$"
cmp_error_output invalid1 "error: line 1 is not valid$"
cmp_error_output invalid1-1 "error: line 1 is not valid$"
cmp_error_output invalid1-2 "error: line 1 is not valid$"
cmp_error_output invalid1-3 "error: line 1 is not valid$"
cmp_error_output invalid1-4 "error: line 1 is not valid$"
cmp_error_output invalid2-1 "error: line 2 is not valid$"
cmp_error_output invalid2-2 "error: line 3 is not valid$"
cmp_error_output invalid2-3 "error: line 4 is not valid$"
cmp_error_output invalid2-4 "error: line 5 is not valid$"
cmp_error_output invalid2-5 "error: line 4 is not valid$"
cmp_error_output invalid3 "error: invalid number of islands$"
cmp_error_output invalid5 "error: duplicate bridges$"
cmp_error_output invalid6 "error: sum of bridges lengths is too big$"
cmp_error_output invalid_long_num "error: line 3 is not valid$"
cmp_error_output invalid_long_num1 "error: line 1 is not valid$"
cmp_error_output invalid-small "error: invalid number of islands$"
cmp_error_output invalid7 "error: line 3 is not valid$"
cmp_error_output invalid7-1 "error: line 3 is not valid$"
cmp_error_output invalid8 "error: line 5 is not valid$"
cmp_error_output invalid8-1 "error: line 4 is not valid$"
cmp_error_output invalid8-2 "error: line 4 is not valid$"
cmp_output_to_file path path_answer.txt
cmp_output_to_file path1 path1_answer.txt
cmp_output_to_file small1 small1_answer.txt
cmp_output_to_file small2 small2_answer.txt
cmp_output_to_file valid_long_paths valid_long_paths_answer.txt
cmp_output_to_file valid_long_paths1 valid_long_paths1_answer.txt
cmp_output_to_file hardest hardest_answer.txt
cmp_output_to_file hard hard_answer.txt
cmp_output_to_file medium medium_answer.txt
cmp_output_to_file easy easy_answer.txt
cmp_output_to_file path2 path2_answer.txt

echo "Leaks and Memory Errors Check:"

cmp_valgrind_output islands
cmp_valgrind_output empty
cmp_valgrind_output invalid1
cmp_valgrind_output invalid1-1
cmp_valgrind_output invalid1-2
cmp_valgrind_output invalid1-3
cmp_valgrind_output invalid1-4
cmp_valgrind_output invalid2-1
cmp_valgrind_output invalid2-2
cmp_valgrind_output invalid2-3
cmp_valgrind_output invalid2-4
cmp_valgrind_output invalid3
cmp_valgrind_output invalid5
cmp_valgrind_output invalid6
cmp_valgrind_output invalid_long_num
cmp_valgrind_output invalid_long_num1
cmp_valgrind_output invalid-small
cmp_valgrind_output path 
cmp_valgrind_output weird
# uncomment to check for load resistance
#cmp_valgrind_output weird1
cmp_valgrind_output small1
cmp_valgrind_output small2
# uncomment to check for medium load resistance
#cmp_valgrind_output medium_load_level
cmp_valgrind_output invalid7
cmp_valgrind_output invalid7-1
cmp_valgrind_output invalid2-5
cmp_valgrind_output invalid8
cmp_valgrind_output invalid8-1
cmp_valgrind_output invalid8-2
cmp_valgrind_output path2

