build:
	docker build -t lambda-playwright:latest .

run:
	docker run --rm -p 9000:8080 lambda-playwright:latest

upload:
	docker tag lambda-playwright:latest $$AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/lambda-playwright:latest
	docker push $$AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/lambda-playwright:latest
