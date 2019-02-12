#!/bin/bash

################################################################################
#
# NOTE! This script suppresses the output generated by the 'diff' command. If
# you want to view the 'diff' results, you'll have to run that command directly.
#
#
# To run all test cases, copy this script to Eustis, place it in a directory
# with your TopolALLgical.java file and all the test case files (source files, input
# files, and output files), and do the following:
#
# 1. Make this script executable by running the following command (you only
#    need to do this once, and then the file will remain executable):
#
#       chmod +x test-all.sh
#
# 2. Run this script like so:
#
#       ./test-all.sh
#
################################################################################


# This script runs test cases 1 through NUM_TEST_CASES. Change this number if
# you are only testing a smaller subset of test cases.
NUM_TEST_CASES=2

for i in `seq -f "%02g" 1 $NUM_TEST_CASES`;
do
	echo -n "Checking TestCase$i... "

	# Attempt to compile.
	javac TopolALLgical.java TestCase$i.java 2> /dev/null
	compile_val=$?
	if [[ $compile_val != 0 ]]; then
		echo "fail (failed to compile)"
		continue
	fi

	# Run program. Capture return value to check whether it crashes.
	java TestCase$i > myoutput$i.txt 2> /dev/null
	execution_val=$?
	if [[ $execution_val != 0 ]]; then
		echo "fail (program crashed)"
		continue
	fi

	# Run diff and capture its return value.
	diff myoutput$i.txt sample_output/TestCase$i-output.txt > /dev/null
	diff_val=$?

	# Clean up the output file generated by this test case.
	rm myoutput$i.txt

	# Output results based on diff's return value.
	if  [[ $diff_val != 0 ]]; then
		echo "fail (output does not match)"
	else
		echo "PASS!"
	fi
done

# Clean up any lingering .class files.
rm *.class
