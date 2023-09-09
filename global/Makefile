build:
	docker build -t wordpress-debian-bullseye .

run:
	docker run -d -p 80:80 --name wordpress-container wordpress-debian-bullseye

stop:
	docker stop wordpress-container
	docker rm wordpress-container
