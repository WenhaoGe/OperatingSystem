#!/bin/sh
<< --HEADER--
CS 4352 - Operating Systems
Project 1
Simon Woldemichael
Part 2 - Process scheduling
Requirement: 
	1. Print out the order of jobs that minimize the waiting time
	2. Print out the waiting time
--HEADER--

function input_is_empty () {
	# Helper function to check that the input is not empty
	# $1 = Most recently read input

	if [[ -z $1 ]]; then
		status=1 # Input variable is empty
	else
		status=0 # Input variable is not empty
	fi
}


function main () {
	# Create an array to store the jobs
	JOBS_ARRAY=()

	# Loop until NUMBER_OF_JOBS is a valid int between 0 and 10
	PROMPT="[INPUT] Please enter the number of jobs (between 0 and 10): "
	while [ 1 ]; do
		# Display prompt and read input
		echo -n $PROMPT
		read NUMBER_OF_JOBS
		
		# Call the input_is_empty function to check that NUMBER_OF_JOBS is not empty
		input_is_empty $NUMBER_OF_JOBS
		
		# If the input was not empty...
		if [[ $status == 0 ]]; then
			# ...check that the NUMBER_OF_JOBS is a valid integer
			if [ $NUMBER_OF_JOBS -eq $NUMBER_OF_JOBS 2>/dev/null ]; then
				# Check that the integer is in the range of (0, 10]
				if [[ ( "$NUMBER_OF_JOBS" -gt 0 && "$NUMBER_OF_JOBS" -le 10 ) ]]; then
					# Input is valid, exit the while loop
					break
				else
					# Input is is not > 0 and <= 10
					PROMPT="[ERROR] Invalid input '$NUMBER_OF_JOBS'. Your input must be in the range from (0, 10]. Please input again: "
				fi
			else
				# Notify user that the input was not a number
				# Accounts for possible floating point numbers
				PROMPT="[ERROR] '$NUMBER_OF_JOBS' is not an integer or not within (0, 10]. Please input again: "
			fi
		else
			# Notify the user that the input was empty
			PROMPT="[ERROR] Your input may not be empty. Please input again: "
		fi
	done

	# Display valid input for NUMBER_OF_JOBS
	echo "[INPUT ACCEPTED] Number of jobs: $NUMBER_OF_JOBS"

	# Read the run time for each job
	# On each iteration, loop until the input is a valid time value
	for (( x=0; x<$NUMBER_OF_JOBS; x++ ))
	do	
		# Loop until a valid run time value is given for each job
		while [ 1 ]; do
			# For every job, read in the run time
			echo -n "[INPUT] Please input the run time of job number $(awk -v var=$x 'BEGIN { print var + 1 }'): "
			read RUN_TIME

			# Check that the input wasn't empty
			input_is_empty RUN_TIME

			# If the input was not empty...
			if [[ $status == 0 ]]; then
				# ...check that the RUN_TIME is a valid integer
				if [ $RUN_TIME -eq $RUN_TIME 2>/dev/null ]; then
					# Check that the integer is in the range of (0, 10]
					if [[ ( "$RUN_TIME" -gt 0 && "$RUN_TIME" -le 10 ) ]]; then
						# Input is valid, add it to the array of run times and exit the loop
						JOBS_ARRAY+=($RUN_TIME)
						break
					else
						# Input is is not > 0 and <= 10
						echo "[ERROR] Invalid input '$RUN_TIME'. Your runtime input must be a valid time value: "
					fi
				else
					# Notify user that the input was not a number
					# Accounts for possible floating point numbers
					echo "[ERROR] '$RUN_TIME' is not a valid runtime value:  "
				fi
			else
				# Notify the user that the RUN_TIME was empty
				echo "[ERROR] Your runtime input may not be empty. Please input again: "
			fi
		done
	done

	echo ==================================================
	x=1
	for i in "${JOBS_ARRAY[@]}"
	do
		echo "[INFO] The run time for job $x is $i"
		let "x+=1"
	done
	
	echo ==================================================
	
	echo "Order of jobs that minimizes waiting time:"
	IFS=$'\n' SORTED_TIMES=($(sort <<< "${JOBS_ARRAY[*]}"))
	echo ${SORTED_TIMES[*]} # TODO: Pair index to job time, display index not job time
	echo  ==================================================

	MIN_WAIT_TIME=0
	for (( i=0; i<$NUMBER_OF_JOBS; i++ ))
	do
		for (( j=0; j<=i-1; j++ ))
		do
			let "MIN_WAIT_TIME+=${SORTED_TIMES[$j]}"
		done
	done
	let "AVG_MIN_WAIT_TIME=MIN_WAIT_TIME/NUMBER_OF_JOBS"
	echo "[RESULT] The minimum wait time is: $MIN_WAIT_TIME"
	echo "[RESULT] The AVERAGE minimum wait time is: $AVG_MIN_WAIT_TIME"
}


echo Beginning Project 2 - Part 2 by Simon Woldemichael
main
echo Completed Project 2 - Part 2 by Simon Woldemichael