PROJECT_NAME=osspharm
IMAGE_NAME=osspharm
DEV_IMAGE_NAME=${IMAGE_NAME}-dev
IMAGE_TAG?=latest
ARTIFACTS_DIR=./artifacts

CWD=$(shell pwd)


${ARTIFACTS_DIR}:
	mkdir -p ${ARTIFACTS_DIR}

# Builds the dev docker image
.PHONY: dev-image
dev-image:
	docker build -f Dockerfile.dev -t ${DEV_IMAGE_NAME}:${IMAGE_TAG} . 

# Starts a shell within the dev docker image
.PHONY: shell
shell:
	docker run --rm -it -v ${CWD}:/app ${DEV_IMAGE_NAME}:${IMAGE_TAG} sh

# Executes a command in the dev docker image
# (not normally used directly, but invoked from other make targets)
.PHONY: dev-exec
dev-exec:
	docker run --rm -v ${CWD}:/app ${DEV_IMAGE_NAME}:${IMAGE_TAG} ${COMMAND}

# Initializes a go project. Executed only when starting this project from scratch. Can be removed.
.PHONY: dev-init
dev-init:
	${MAKE} dev-exec ${IMAGE_NAME} COMMAND="go mod init ${PROJECT_NAME}"

# Pulls go module packages and updates go.sum file
.PHONY: dev-tidy
dev-tidy:
	${MAKE} dev-exec ${IMAGE_NAME} COMMAND="go mod tidy"

.PHONY: dev-build
dev-build: ${ARTIFACTS_DIR}
	${MAKE} dev-exec ${IMAGE_NAME} COMMAND="go build -o ${ARTIFACTS_DIR}/"

