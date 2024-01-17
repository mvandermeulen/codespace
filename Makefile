environment = atidyshirt/jordanp-env

all-build = build-environment
all-push = push-environment
all-clean = clean-environment

login:
	docker login

build-environment:
	echo "--- Building $(environment) image ---"
	docker build -t $(environment) .

push-environment: login
	echo "--- Pushing $(environment) image ---"
	docker push $(environment)

clean-environment:
	echo "--- Removing $(environment) image ---"
	docker image rm -f $(environment)