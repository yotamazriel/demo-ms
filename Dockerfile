## Container base
FROM node:latest

## Container setup
RUN npm install -g docsify-cli@latest
RUN mkdir -p /usr/local/docsify

## Container dnvironment variables
ENV DEBUG 0
ENV PORT 3000
ENV DOCSIFY_VERSION latest
ENV NODE_VERSION latest

## Container runtime configuration
EXPOSE 3000
WORKDIR /usr/local/docsify

## Container entry point
ENTRYPOINT [ "docsify", "serve", "--port", "3000" ]

# https://nickjanetakis.com/blog/docker-tip-2-the-difference-between-copy-and-add-in-a-dockerile
COPY ./docs .

## Container entry point default arguments
CMD [ "." ]
