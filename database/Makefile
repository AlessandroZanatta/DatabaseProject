
all:
	@echo "Running scripts..."
	cd scripts && time ./populate.py
	@echo "Starting container..."
	docker-compose up --build -V -d

analyze:
	@echo "Running analysis..."
	docker-compose up --build -V -d
	@echo "Waiting for container to actually start-up..."
	@sleep 30
	cd analysis && R -e 'rmarkdown::render("analysis.Rmd")'

docker:
	docker-compose up --build -V
