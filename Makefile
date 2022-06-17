setup:
	cp -n .env.example .env || true
	bin/setup

start:
	bin/rails s -p 3000 -b "0.0.0.0"

console:
	bin/rails console

guard:
	bundle exec guard -c

lint:
	bundle exec rubocop

deploy:
	git push heroku main

.PHONY: test