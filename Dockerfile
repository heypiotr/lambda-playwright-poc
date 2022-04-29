FROM mcr.microsoft.com/playwright:v1.21.1-focal
# aws-lambda-ric deps
RUN apt-get update && apt-get install -y cmake autoconf libtool g++
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm i

FROM mcr.microsoft.com/playwright:v1.21.1-focal
RUN curl -fsSLo /usr/local/bin/aws-lambda-rie \
    https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/download/v1.5/aws-lambda-rie-x86_64 && \
    chmod +x /usr/local/bin/aws-lambda-rie
WORKDIR /app
COPY --from=0 /app/node_modules ./node_modules
COPY entrypoint.sh index.js package.json package-lock.json ./
ENTRYPOINT ["./entrypoint.sh"]
CMD ["index.handler"]
