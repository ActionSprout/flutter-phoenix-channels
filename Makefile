.DEFAULT_GOAL := all
.PHONY: all

SRC_PROTO_FILES=$(shell find proto -type f -name '*.proto')
PROTO_FILES=$(patsubst proto/%.proto,lib/proto/%.pb.dart,$(SRC_PROTO_FILES))
REQUIRED_WKT_PROTO_FILES=$(wildcard proto/google/protobuf/*.proto)
REQUIRED_WKT_DART_FILES=$(patsubst proto/google/protobuf/%.proto, lib/proto/google/protobuf/%.pb.dart,$(REQUIRED_WKT_PROTO_FILES))

all: \
	$(PROTO_FILES) \
	$(REQUIRED_WKT_DART_FILES) \

lint:
	dartanalyzer --options analysis_options.yaml lib

lib/proto/%.pb.dart: proto/%.proto
	mkdir -p lib/proto
	protoc --dart_out=lib/proto --proto_path=proto $<
