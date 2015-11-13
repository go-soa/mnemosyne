PROTOC=/usr/local/bin/protoc
SERVICE=mnemosyne
PACKAGE=github.com/piotrkowalczuk/mnemosyne
PACKAGE_DAEMON=$(PACKAGE)/$(SERVICE)d
BINARY=${SERVICE}d/${SERVICE}d

FLAGS=-h=$(MNEMOSYNE_HOST) \
          	    -p=$(MNEMOSYNE_PORT) \
          	    -s=$(MNEMOSYNE_SUBSYSTEM) \
          	    -n=$(MNEMOSYNE_NAMESPACE) \
          	    -lf=$(MNEMOSYNE_LOGGER_FORMAT) \
          	    -la=$(MNEMOSYNE_LOGGER_ADAPTER) \
          	    -ll=$(MNEMOSYNE_LOGGER_LEVEL) \
          	    -me=$(MNEMOSYNE_MONITORING_ENGINE) \
          	    -se=$(MNEMOSYNE_STORAGE_ENGINE) \
          	    -spcs=$(MNEMOSYNE_STORAGE_POSTGRES_CONNECTION_STRING) \
          	    -sptn=$(MNEMOSYNE_STORAGE_POSTGRES_TABLE_NAME) \
          	    -spr=$(MNEMOSYNE_STORAGE_POSTGRES_RETRY)

.PHONY:	all proto build build-daemon run test test-unit test-postgres

all: proto build test run

proto:
	@${PROTOC} --proto_path=${GOPATH}/src --proto_path=. --go_out=plugins=grpc:. timestamp.proto ${SERVICE}.proto
	@ls -al | grep "pb.go"

build: build-daemon

build-daemon:
	@go build -o ${BINARY} ${PACKAGE_DAEMON}

run:
	@${BINARY} ${FLAGS}

test: test-unit test-postgres

test-unit:
	@go test -v ${PACKAGE_DAEMON} ${FLAGS}

test-postgres:
	@go test -tags postgres -v ${PACKAGE_DAEMON} ${FLAGS}

get:
	@go get ${PACKAGE_DAEMON}