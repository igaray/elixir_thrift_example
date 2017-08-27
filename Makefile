.PHONY: all clean gen_thrift deps client server

all: gen_thrift deps client server

clean:
	@echo "Cleaning..."
	@rm -rf _build

gen_thrift: gen_thrift_erlang
	@echo "Generated thrift bindings"

gen_thrift_erlang:
	@rm -rf apps/common/src/gen
	@mkdir apps/common/src/gen
	@thrift -r -v -out apps/common/src/gen --gen erl apps/common/src/thrift/base.thrift
	@rm -rf apps/common/include/gen/*
	@cp apps/common/src/gen/*.hrl apps/common/include/gen

deps:
	@mix deps.get
	@mix deps.compile

client:
	@echo "Building client"

server:
	@echo "Building server"