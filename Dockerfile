FROM		python:3.8-alpine3.19

RUN		apk add pv fuse wget ruby pv curl bash rpm gcc linux-headers musl-dev && \
		python -m pip install --upgrade pip==24.2 --root-user-action ignore && \
		pip install python-swiftclient python-keystoneclient --root-user-action ignore && \
		curl -sLO https://github.com/ovh/svfs/releases/download/v0.9.1/svfs-0.9.1-1.x86_64.rpm && \
		adduser -D xlucas && \
		rpm -ivh --nodeps svfs-0.9.1-1.x86_64.rpm && \
		rm svfs-0.9.1-1.x86_64.rpm && \
		apk del gcc linux-headers musl-dev rpm curl && \
		echo '#!/bin/sh' >> /usr/local/bin/entrypoint.sh && \
		echo 'if [ -z $CONTAINER ]; then' >> /usr/local/bin/entrypoint.sh && \
		echo '  mount -t svfs -o segment_size=256 /dev/svfs /mnt' >> /usr/local/bin/entrypoint.sh && \
		echo 'else' >> /usr/local/bin/entrypoint.sh && \
		echo '  if [ -z $SEGMENT_SIZE ]; then' >> /usr/local/bin/entrypoint.sh && \
		echo '    mount -t svfs -o segment_size=256,container=$CONTAINER /dev/svfs /mnt' >> /usr/local/bin/entrypoint.sh && \
		echo '  else' >> /usr/local/bin/entrypoint.sh && \
		echo '    mount -t svfs -o segment_size=$SEGMENT_SIZE,container=$CONTAINER /dev/svfs /mnt' >> /usr/local/bin/entrypoint.sh && \
		echo '  fi' >> /usr/local/bin/entrypoint.sh && \
		echo 'fi' >> /usr/local/bin/entrypoint.sh && \
		echo 'exec "$@"' >> /usr/local/bin/entrypoint.sh && \
		chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT	["entrypoint.sh"]
CMD		["tail", "-f", "/dev/null"]
