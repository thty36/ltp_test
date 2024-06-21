#! /bin/sh
# Copyright (c) Linux Test Project, 2010-2022
# Copyright (c) 2002, Intel Corporation. All rights reserved.
# Created by:  julie.n.fleischer REMOVE-THIS AT intel DOT com
# This file is licensed under the GPL license.  For the full content
# of this license, see the COPYING file at the top level of this
# source tree.
#
# Use to build and run tests for a specific area

TESTPATH=""

BASEDIR="$(dirname "$0")/../${TESTPATH}/conformance/interfaces"

usage()
{
    cat <<EOF
usage: $(basename "$0") [AIO|MEM|MSG|SEM|SIG|THR|TMR|TPS] [M]

Build and run the tests for POSIX area specified by the 3 letter tag
in the POSIX spec
The M argument runs all run.sh scripts instead of directly running files ending in *.run-test

EOF
}

run_option_group_tests()
{
	local list_of_tests

	list_of_tests=`find $1 -name '*.run-test' | sort`

	if [ -z "$list_of_tests" ]; then
		echo ".run-test files not found under $1, have been the tests compiled?"
		exit 1
	fi

	for test_script in $list_of_tests; do
		(cd "$(dirname "$test_script")" && ./$(basename "$test_script"))
	done
}
#按顺序执行对应目录下以.run-test结尾的可执行文件

run_option_group_tests_()
{
	local list_of_tests

	list_of_tests=`find $1 -name 'run.sh' | sort`

	if [ -z "$list_of_tests" ]; then
		echo ".run-test files not found under $1, have been the tests compiled?"
		exit 1
	fi

	for test_script in $list_of_tests; do
		(cd "$(dirname "$test_script")" &&  ./$(basename "$test_script")) 
	done
} 
#按顺序执行对应目录下的run.sh

if [ "$2" = "M" ] ;then
	run_tests_mode=run_option_group_tests_
else
	run_tests_mode=run_option_group_tests
fi

case $1 in
	AIO)
		echo "Executing asynchronous I/O tests"
		$run_tests_mode "$BASEDIR/aio_*"
		$run_tests_mode "$BASEDIR/lio_listio"
		;;
	SIG)
		echo "Executing signals tests"
		$run_tests_mode "$BASEDIR/sig*"
		$run_tests_mode $BASEDIR/raise
		$run_tests_mode $BASEDIR/kill
		$run_tests_mode $BASEDIR/killpg
		$run_tests_mode $BASEDIR/pthread_kill
		$run_tests_mode $BASEDIR/pthread_sigmask
		;;
	SEM)
		echo "Executing semaphores tests"
		$run_tests_mode "$BASEDIR/sem*"
		;;
	THR)
		echo "Executing threads tests"
		$run_tests_mode "$BASEDIR/pthread_*"
		;;
	TMR)
		echo "Executing timers and clocks tests"
		$run_tests_mode "$BASEDIR/time*"
		$run_tests_mode "$BASEDIR/*time"
		$run_tests_mode "$BASEDIR/clock*"
		$run_tests_mode $BASEDIR/nanosleep
		;;
	MSG)
		echo "Executing message queues tests"
		$run_tests_mode "$BASEDIR/mq_*"
		;;
	TPS)
		echo "Executing process and thread scheduling tests"
		$run_tests_mode "$BASEDIR/*sched*"
		;;
	MEM)
		echo "Executing mapped, process and shared memory tests"
		$run_tests_mode "$BASEDIR/m*lock*"
		$run_tests_mode "$BASEDIR/m*map"
		$run_tests_mode "$BASEDIR/shm_*"
		;;
	*)
		usage
		exit 1
		;;
	esac

echo "****Tests Complete****"
