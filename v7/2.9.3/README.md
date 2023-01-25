# How to build this using docker buildx

If you've built one of these before using docker buildx then all you'll need to do is run

   docker buildx build --platform linux/amd64,linux/arm64 --push -t flipstone/stack:v7-2.9.3 .

in this directory to build and push this image for both amd64 (normal machines) and arm64 (M1, M2 Macs).

If it's your first time then you'll need to install [docker buildx] (https://docs.docker.com/engine/reference/commandline/buildx/)

and then create an appropriate builder

   docker buildx create --platform linux/amd64,linux/arm64 --name flipstone-stack

and then tell docker buildx to use it

   docker buildx use flipstone-stack

then finally run

   docker buildx build --platform linux/amd64,linux/arm64 --push -t flipstone/stack:v7-2.9.3 .
