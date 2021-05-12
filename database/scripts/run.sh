#!/bin/bash

for f in ./*.py; do
	echo -n "Executing '$f'..."
	python3 "$f"
	echo " Done"
done


