
all:
	cd scripts && ./populate.py
	# cd scripts && ./run.sh
	@echo "Starting container..."
	@sleep 2
	docker-compose up --build -V

docker:
	docker-compose up --build -V
