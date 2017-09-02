.PHONY: all clean gen_thrift deps example run

all: clean gen_thrift deps example

clean:
	@echo "Cleaning..."
	@rm -rf _build

gen_thrift: gen_thrift_erlang
	@echo "Generated thrift bindings"

gen_thrift_erlang:
	@rm -rf apps/example/src/gen
	@mkdir apps/example/src/gen
	@thrift -r -v -out apps/example/src/gen --gen erl apps/example/src/thrift/example.thrift
	@rm -rf apps/example/include/gen/*
	@cp apps/example/src/gen/*.hrl apps/example/include/gen

deps:
	@mix deps.get
	@mix deps.compile

compile:
	@mix compile

example: compile
	@mix release --name=example --env=dev --no-tar

run:
	_build/dev/rel/example/bin/example console