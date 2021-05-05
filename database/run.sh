#!/bin/bash

for f in scripts/*.py; do
	echo -n "Executing '$f'..."
	python3 "$f"
	echo " Done"
done


echo "Starting container..."
sleep 2
docker-compose up --build -V
