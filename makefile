PROTOC=protoc
PROTO_IN=protos
PROTO_OUT=out

install: build-protos

build-protos:
	mkdir -p "${PROTO_IN}/${PROTO_OUT}"
	(cd ${PROTO_IN} && ${PROTOC} --dart_out=${PROTO_OUT} *.proto)
