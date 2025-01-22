FROM node:9.11.2-slim AS builder

WORKDIR /opt/app
RUN apt update && apt install git python build-essential -y
RUN git clone https://github.com/Ramzus/pegascape.git .
RUN npm install

COPY pegascape.sh /opt/app

FROM node:9.11.2-slim

RUN groupadd -r pegascape && useradd --no-log-init -r -g pegascape pegascape

WORKDIR /opt/app
COPY --from=builder /opt/app ./

RUN chown -R pegascape:pegascape /opt/app

EXPOSE 80
EXPOSE 53/UDP
EXPOSE 8100

USER pegascape

ENTRYPOINT ["node", "start.js", "$CMD_ARGUMENT"]