#!/usr/bin/env bash

TIMEOUT=$(( $RANDOM % 30 ))
EXEC_TIME=$(( ($RANDOM % 600) ))
TIMEOUT_TIME=7200
EXIT_CODE=$(( $RANDOM % 4 ))

if [ "$TIMEOUT" -eq "0" ]
then
RESULT=$(($EXEC_TIME + $TIMEOUT_TIME))
echo "* THIS BUILD WILL TIME OUT"
else
RESULT=$EXEC_TIME
fi

echo "* THIS BUILD WILL TAKE $RESULT SECONDS"

if [ "$EXIT_CODE" -eq "0" ]
then
  echo "* BUILD WILL FAIL"
  EXIT_CODE=1
else
  echo "* BUILD WILL PASS"
  EXIT_CODE=0
fi


X=1

while [ "$X" -lt $RESULT ]
    do
        if [ $(($X % 60)) -eq 0 ]
        then
        echo "* STILL RUNNING"
        fi
    sleep 1
    X=$(( $X + 1 ))
done

exit $EXIT_CODE
