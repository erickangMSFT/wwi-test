#!/bin/bash

# Usage: ./run.sh -f {document, json, html} default = document view.

format='document' #default format
while [[ $# -gt 1 ]]
do
key="$1"
case $key in
    -f|--format)
    format="$2"
    shift 
    ;;
    *)
    ;;
esac
shift 
done

printf "\n" && printf '\e[1;34m%-6s\e[m' "* starting tests for:" && printf "\n"
starttime=$(date +"%Y-%m-%d %H:%M:%S %3N")

curl -s http://localhost:8000/api/getspecs | jq -r '.[] | .specFile'

start=$SECONDS

for spec in $(curl -s http://localhost:8000/api/getspecs | jq -r '.[] | .specFile'); do
    url='http://localhost:8000/api/runspec/'${format}'/'$spec
    curl -s $url & 
done

printf "\n" && printf '\e[1;34m%-6s\e[m' "* waiting for the results..." && printf "\n" 

wait
printf "\n" 
duration=$(( SECONDS - start )) && endtime=$(gdate +"%Y-%m-%d %H:%M:%S %3N")
printf '\e[1;36m%-6s\e[m' "--- summary ---" && printf "\n" 
printf '\e[1;36m%-6s\e[m' "start time:  " && printf "%s %s %s\n" $starttime
printf '\e[1;36m%-6s\e[m' "end time:    " && printf "%s %s %s\n" $endtime
printf '\e[1;36m%-6s\e[m' "elapse time: "  && printf "%s seconds\n\n" $duration

