#!/bin/bash

cmp_error_output()
{
    filename=$1
    output=$(./pathfinder $filename 2>&1 | cat -e)
    error_string=$2

    if [ "$output" == "$error_string" ]; then
        echo "Error output matches."
    else
        echo "============================"
        echo "Error output does not match."
        echo "Output: ${output}"
        echo "Input file: ${filename}"
        echo "Expected: ${error_string}"
        echo "============================"
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
        echo "============================"
        echo "Output does not match."
        echo "Output: ${output}"
        echo "Input file: ${filename}"
        echo "Expected: ${output_string}"
        echo "============================"
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
        echo "============================"
        echo "Some leaks detected"
        echo "Input file: ${filename}"
        echo "============================"
    fi
}

path_output="========================================
Path: Greenland -> Bananal
Route: Greenland -> Bananal
Distance: 8
========================================
========================================
Path: Greenland -> Fraser
Route: Greenland -> Fraser
Distance: 10
========================================
========================================
Path: Greenland -> Java
Route: Greenland -> Fraser -> Java
Distance: 10 + 5 = 15
========================================
========================================
Path: Bananal -> Fraser
Route: Bananal -> Fraser
Distance: 3
========================================
========================================
Path: Bananal -> Java
Route: Bananal -> Fraser -> Java
Distance: 3 + 5 = 8
========================================
========================================
Path: Fraser -> Java
Route: Fraser -> Java
Distance: 5
========================================"

path1_output="========================================
Path: A -> B
Route: A -> B
Distance: 11
========================================
========================================
Path: A -> C
Route: A -> C
Distance: 10
========================================
========================================
Path: A -> D
Route: A -> B -> D
Distance: 11 + 5 = 16
========================================
========================================
Path: A -> D
Route: A -> C -> D
Distance: 10 + 6 = 16
========================================
========================================
Path: A -> E
Route: A -> B -> D -> E
Distance: 11 + 5 + 4 = 20
========================================
========================================
Path: A -> E
Route: A -> C -> D -> E
Distance: 10 + 6 + 4 = 20
========================================
========================================
Path: B -> C
Route: B -> D -> C
Distance: 5 + 6 = 11
========================================
========================================
Path: B -> D
Route: B -> D
Distance: 5
========================================
========================================
Path: B -> E
Route: B -> D -> E
Distance: 5 + 4 = 9
========================================
========================================
Path: C -> D
Route: C -> D
Distance: 6
========================================
========================================
Path: C -> E
Route: C -> D -> E
Distance: 6 + 4 = 10
========================================
========================================
Path: D -> E
Route: D -> E
Distance: 4
========================================"

small1_output="========================================
Path: Greenland -> Bananal
Route: Greenland -> Bananal
Distance: 8
========================================
========================================
Path: Greenland -> Fraser
Route: Greenland -> Fraser
Distance: 10
========================================
========================================
Path: Bananal -> Fraser
Route: Bananal -> Fraser
Distance: 3
========================================"

small2_output="========================================
Path: Greenland -> Bananal
Route: Greenland -> Bananal
Distance: 8
========================================"

valid_long_paths_output="========================================
Path: Greenland -> Bananal
Route: Greenland -> Fraser -> Bananal
Distance: 10 + 3 = 13
========================================
========================================
Path: Greenland -> Fraser
Route: Greenland -> Fraser
Distance: 10
========================================
========================================
Path: Greenland -> Java
Route: Greenland -> Fraser -> Java
Distance: 10 + 5 = 15
========================================
========================================
Path: Bananal -> Fraser
Route: Bananal -> Fraser
Distance: 3
========================================
========================================
Path: Bananal -> Java
Route: Bananal -> Fraser -> Java
Distance: 3 + 5 = 8
========================================
========================================
Path: Fraser -> Java
Route: Fraser -> Java
Distance: 5
========================================"

valid_long_paths1_output="========================================
Path: Greenland -> Bananal
Route: Greenland -> Fraser -> Bananal
Distance: 1000000000 + 3 = 1000000003
========================================
========================================
Path: Greenland -> Fraser
Route: Greenland -> Fraser
Distance: 1000000000
========================================
========================================
Path: Greenland -> Java
Route: Greenland -> Fraser -> Java
Distance: 1000000000 + 5 = 1000000005
========================================
========================================
Path: Bananal -> Fraser
Route: Bananal -> Fraser
Distance: 3
========================================
========================================
Path: Bananal -> Java
Route: Bananal -> Fraser -> Java
Distance: 3 + 5 = 8
========================================
========================================
Path: Fraser -> Java
Route: Fraser -> Java
Distance: 5
========================================"

{
    output=$(./pathfinder empty empty 2>&1 | cat -e)
    static_string="usage: ./pathfinder [filename]$"

    if [ "$output" == "$static_string" ]; then
        echo "Error output matches."
    else
        echo "============================"
        echo "Error output does not match."
        echo "Output: ${output}"
        echo "Input file: empty"
        echo "Expected: ${static_string}"
        echo "============================"
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
cmp_output path "$path_output"
cmp_output path1 "$path1_output"
cmp_output small1 "$small1_output"
cmp_output small2 "$small2_output"
cmp_output valid_long_paths "$valid_long_paths_output"
cmp_output valid_long_paths1 "$valid_long_paths1_output"

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
cmp_valgrind_output weird1
cmp_valgrind_output small1
cmp_valgrind_output small2
cmp_valgrind_output medium
cmp_valgrind_output invalid7
cmp_valgrind_output invalid7-1
cmp_valgrind_output invalid2-5

