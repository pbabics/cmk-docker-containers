#!/bin/bash
echo "<<<docker_containers>>>"

docker stats --no-stream `docker ps -a -q` | tr -s ' ' | sed 's# \([KMGTE]\?i\?\)B#\1B#g;s# / #/#g' > /tmp/docker_stats
while read line;
do
	CONTAINER_NAME=`echo "$line" | cut -d$'\t' -f1`
	CONTAINER_ID=`echo "$line" | cut -d$'\t' -f2`
	CONTAINER_STATUS=`echo "$line" | cut -d$'\t' -f3 | cut -d' ' -f1 | tr '[:lower:]' '[:upper:]'`

	CONTAINER_CPU_STAT=`fgrep "${CONTAINER_ID}" /tmp/docker_stats | cut -d' ' -f2`
	CONTAINER_MEM_STAT=`fgrep "${CONTAINER_ID}" /tmp/docker_stats | cut -d' ' -f4`
	CONTAINER_MEM_USAGE=`fgrep "${CONTAINER_ID}" /tmp/docker_stats | cut -d' ' -f3 | cut -d'/' -f1`
	echo -e "${CONTAINER_NAME}\t${CONTAINER_STATUS}\t${CONTAINER_ID}\t${CONTAINER_CPU_STAT}\t${CONTAINER_MEM_STAT}\t${CONTAINER_MEM_USAGE}"

done < <(docker ps  -a --format '{{.Names}}\t{{.ID}}\t{{.Status}}')
