PROTOC=protoc
PROTO_IN=protos
PROTO_OUT=lib

install: build-protos

build-protos:
	${PROTOC} --dart_out=${PROTO_OUT} ${PROTO_IN}/*.proto