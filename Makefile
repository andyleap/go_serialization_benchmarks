all: FlatBufferA.go msgp_gen.go structdef-gogo.pb.go structdef.pb.go vitess_test.go structdef.capnp.go structdef.capnp2.go gencode.schema.gen.go

FlatBufferA.go: flatbuffers-structdef.fbs
	flatc -g flatbuffers-structdef.fbs
	mv flatbuffersmodels/FlatBufferA.go FlatBufferA.go
	rmdir flatbuffersmodels
	sed -i '' 's/flatbuffersmodels/goserbench/' FlatBufferA.go

msgp_gen.go: structdef.go
	go generate

structdef-gogo.pb.go: structdef-gogo.proto
	protoc --gogofaster_out=. -I. -I${GOPATH}/src  -I${GOPATH}/src/github.com/gogo/protobuf/protobuf structdef-gogo.proto

structdef.pb.go: structdef.proto
	protoc --go_out=. structdef.proto

vitess_test.go: structdef.go
	bsongen -file=structdef.go -o=vitess_test.go -type=A

structdef.capnp2.go: structdef.capnp2
	go get -u zombiezen.com/go/capnproto2/... # conflicts with go-capnproto
	capnp compile -I${GOPATH}/src -ogo structdef.capnp2

structdef.capnp.go: structdef.capnp
	go get -u github.com/glycerine/go-capnproto/capnpc-go # conflicts with capnproto2
	capnp compile -I${GOPATH}/src -ogo structdef.capnp
	
gencode.schema.gen.go: gencode.schema
	gencode go -schema=gencode.schema -package=goserbench
	
gencode-unsafe.schema.gen.go: gencode-unsafe.schema
	gencode go -schema=gencode-unsafe.schema -package=goserbench -unsafe

.PHONY: clean
clean:
	rm -f FlatBufferA.go msgp_gen.go structdef-gogo.pb.go structdef.pb.go vitess_test.go structdef.capnp.go structdef.capnp2.go gencode.schema.gen.go gencode-unsafe.schema.gen.go

.PHONY: install
install:
	go get -u github.com/gogo/protobuf/protoc-gen-gogofaster
	go get -u github.com/gogo/protobuf/gogoproto
	go get -u github.com/golang/protobuf/protoc-gen-go
	go get -u github.com/tinylib/msgp
	go get -u github.com/youtube/vitess/go/cmd/bsongen
	go get -u github.com/andyleap/gencode

	go get -u github.com/DeDiS/protobuf
	go get -u github.com/Sereal/Sereal/Go/sereal
	go get -u github.com/alecthomas/binary
	go get -u github.com/davecgh/go-xdr/xdr
	go get -u github.com/gogo/protobuf/proto
	go get -u github.com/google/flatbuffers/go
	go get -u github.com/tinylib/msgp/msgp
	go get -u github.com/ugorji/go/codec
	go get -u github.com/youtube/vitess/go/bson
	go get -u gopkg.in/mgo.v2/bson
	go get -u gopkg.in/vmihailenco/msgpack.v2
	go get -u github.com/golang/protobuf/proto
	go get -u github.com/hprose/hprose-go/io
