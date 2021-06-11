
all: populate docker analyze

populate:
	@echo "Running scripts..."
	cd scripts && time ./populate.py

analyze:
	cd analysis && R -e 'rmarkdown::render("analysis.Rmd")'

docker:
	@echo "Starting container..."
	docker-compose up --build -V -d
	@echo "Waiting for container to actually start-up..."
	@sleep 30
