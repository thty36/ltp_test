#!/bin/bash

#该脚本非LTP原生，用于对open_posix_testsuite测试套件的logfile进行整理到result/目录下
DEFAULT_FILE_NAME_GENERATION_TIME=`date +"%Y_%m_%d-%Hh_%Mm_%Ss"`
script_dir=$(cd $(dirname "$0") && pwd)
result_dir="$script_dir/../result"
result_log="$result_dir/posix_$DEFAULT_FILE_NAME_GENERATION_TIME.log"

cat_logfile(){
 
  if [ ! -d "$result_dir" ]; then
      mkdir "$result_dir"
      echo "Folder $result_dir created successfully."
  fi

local logfilelist

	logfilelist=`find $script_dir/../ -name "logfile" | sort`

	if [ -z "$logfilelist" ]; then
		echo "logfile files not found under $script_dir/../, have run the script with M argument?"
		exit 1
	fi

	if [ -e "$result_log" ]; then
		echo "$result_log file has created!"
		exit 1
	fi

	for logfile_path in $logfilelist; do
#		echo "$logfile_path"
    cat $logfile_path >> $result_log
	done


}
cat_logfile