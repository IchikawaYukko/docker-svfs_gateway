FROM		python:alpine

RUN		apk add fuse wget ruby pv curl bash rpm gcc linux-headers musl-dev && \
		pip install python-swiftclient python-keystoneclient && \
		curl -sLO https://github.com/ovh/svfs/releases/download/v0.9.1/svfs-0.9.1-1.x86_64.rpm && \
		adduser -D xlucas && \
		rpm -ivh --nodeps svfs-0.9.1-1.x86_64.rpm && \
		rm svfs-0.9.1-1.x86_64.rpm && \
		apk del gcc linux-headers musl-dev rpm curl && \
		echo '#!/bin/sh' >> /usr/local/bin/entrypoint.sh && \
		echo 'mount -t svfs /dev/svfs /mnt' >> /usr/local/bin/entrypoint.sh && \
		echo 'exec "$@"' >> /usr/local/bin/entrypoint.sh && \
		chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT	["entrypoint.sh"]
CMD		["tail", "-f", "/dev/null"]
