# pathfinder-checker
Linux shell script and test files created to test pathfinder program


# Requirements:
- valgrind
- bash

# How to use:
Make sure there is pathfinder binary in current directory and then run:

`bash test.sh`

or

`./test.sh`

# Output

If no errors were found you will see short messages like "Error output matches.", "Output matches.", "No leaks".

### In case of errors with error output you will see:
1. Your program output
2. Input filename
3. Expected output

### In case of errors with output you will see:
1. Input filename
2. Result of comand `diff your_answer.txt right_answer.txt`

### In case of memory errors or leaks you will see:
1. Input filename

# Test cases
Test cases from lms assesment: easy, medium, hard, hardest

Test cases for load resistance check: medium_load_level, big, weird, weird1

All files in this repository are free to copy and reuse
