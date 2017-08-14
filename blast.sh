#!/bin/bash

docker ps -a | grep $1 | {
	read id image rest
	docker stop $id
	docker rm $id
	docker rmi $image
}

