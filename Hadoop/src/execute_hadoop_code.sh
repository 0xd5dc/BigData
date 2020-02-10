#!/usr/bin/env bash

# ##################################################
# My Generic BASH script template
#
#version="1.0.0" # Sets version variable
#
# ##################################################
export HADOOP_CLASSPATH="${JAVA_HOME}/lib/tools.jar"
# Provide a variable with the location of this script.
#scriptPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set Flags
# -----------------------------------
# Flags which can be overridden by user input.
# Default values are below
# -----------------------------------
#quiet=0
#printLog=0
#verbose=0
#force=0
strict=0
debug=0
args=()

function mainScript() {
  ############## Begin Script Here ###################
  ####################################################

  echo -n
  #  clean output directory on HFDS
  hadoop fs -rm -r output
  #  compile Hadoop java code
  hadoop com.sun.tools.javac.Main WordCount.java
  jar cf wc.jar WordCount*.class
  #  run hadoop jobs
  hadoop jar wc.jar WordCount input output
  #  sort word count by frequency desc
  hadoop fs -cat output/part-r-00000 | sort -k 2nr >output.txt

  ####################################################
  ############### End Script Here ####################
}

############## Begin Options and Usage ###################

## Print usage
#usage() {
#  echo -n "${scriptName} [OPTION]... [FILE]...
#
#This is my script template.
#
# Options:
#  -d, --debug       Runs script in BASH debug mode (set -x)
#  -h, --help        Display this help and exit
#      --version     Output version information and exit
#"
#}

# Store the remaining part as arguments.
args+=("$@")

############## End Options and Usage ###################

# ############# ############# #############
# ##       TIME TO RUN THE SCRIPT        ##
# ##                                     ##
# ## You shouldn't need to edit anything ##
# ## beneath this line                   ##
# ##                                     ##
# ############# ############# #############

# Exit on error. Append '||true' when you run the script if you expect an error.
set -o errexit

# Run in debug mode, if set
if [ "${debug}" == "1" ]; then
  set -x
fi

# Exit on empty variable
if [ "${strict}" == "1" ]; then
  set -o nounset
fi

# Bash will remember & return the highest exitcode in a chain of pipes.
# This way you can catch the error in case mysqldump fails in `mysqldump |gzip`, for example.
set -o pipefail

# Run your script
mainScript

safeExit # Exit cleanly
