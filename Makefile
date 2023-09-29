build:
	cd docker; docker buildx bake

publish: build
	cd docker; docker buildx bake --push
