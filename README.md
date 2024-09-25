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

If no errors were found you will see short messages like "Error output matches.", "Output matches.", "No leaks".

### In case of errors with output you will see:
1. Your program output
2. Input filename
3. Expected output

### In case of memory errors or leaks you will see:
1. Input filename

All files in this repository are free to copy and reuse
