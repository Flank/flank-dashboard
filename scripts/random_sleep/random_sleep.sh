#!/usr/bin/env bash

TIMEOUT=$(( $RANDOM % 30 ))
BASE_TIME=$(( ($RANDOM % 59) + 1 ))
MULTIPLIER=$(( ($RANDOM % 9) + 1 ))
TIMEOUT_TIME=7200
EXIT_CODE=$(( $RANDOM % 4 ))

if [ "$TIMEOUT" -eq "0" ]
then
RESULT=$(($BASE_TIME * $MULTIPLIER + $TIMEOUT_TIME))
echo "* THIS BUILD WILL TIME OUT"
else
RESULT=$(($BASE_TIME * $MULTIPLIER))
fi

echo "* BASETIME:$BASE_TIME MULTIPLIER:$MULTIPLIER"
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
