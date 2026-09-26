#!/bin/bash

# Clean up previous tempdir and running containers
rm -rf tempdir
docker rm -f samplerunning 2>/dev/null || true

# Recreate directories
mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static

# Copy project files
cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

# Use Buster-based image to prevent clone3/threading failure
echo "FROM python:3.8-slim-buster" >> tempdir/Dockerfile
echo "RUN pip install --no-cache-dir flask" >> tempdir/Dockerfile
echo "COPY ./static /home/myapp/static/" >> tempdir/Dockerfile
echo "COPY ./templates /home/myapp/templates/" >> tempdir/Dockerfile
echo "COPY sample_app.py /home/myapp/" >> tempdir/Dockerfile
echo "EXPOSE 5050" >> tempdir/Dockerfile
echo "CMD python /home/myapp/sample_app.py" >> tempdir/Dockerfile

# Build and run
cd tempdir
docker build -t sampleapp .
docker run -t -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a