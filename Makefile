.PHONY: help install dev up down logs lint format test clean

help:
	@echo "MatiOS Development Commands"
	@echo ""
	@echo "install      - Install dependencies"
	@echo "dev          - Start development environment"
	@echo "up           - Start Docker services"
	@echo "down         - Stop Docker services"
	@echo "logs         - View Docker logs"
	@echo "lint         - Run linting checks"
	@echo "format       - Format code"
	@echo "test         - Run tests"
	@echo "clean        - Clean up generated files"

install:
	pip install -r requirements-dev.txt

dev:
	docker-compose up -d
	@echo "MatiOS is running at http://localhost:8000"
	@echo "Database is at localhost:5432"

up:
	docker-compose up -d

down:
	docker-compose down

logs:
	docker-compose logs -f

lint:
	flake8 src tests
	mypy src

format:
	black src tests
	isort src tests

test:
	pytest

clean:
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	rm -rf .pytest_cache
	rm -rf htmlcov
	rm -rf dist build *.egg-info
