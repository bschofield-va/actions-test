FROM busybox:stable AS base
ENV PLAYERONE_ID=999
RUN <<EOF
  addgroup -g $PLAYERONE_ID playerone
  adduser -S -u $PLAYERONE_ID -G playerone playerone
EOF
USER playerone
ENTRYPOINT [ "sh" ]

FROM base AS builder
ADD --chown=${PLAYERONE_ID}:${PLAYERONE_ID} . /home/playerone/project/
WORKDIR /home/playerone/project
ARG DELAY=0
RUN <<EOF
 date > build.txt
 echo $RANDOM >> build.txt
 for i in $(seq 1 ${DELAY:0}); do echo "wait for it"; sleep 1; done
EOF

FROM base AS app
COPY --from=builder /home/playerone/project/build.txt /