BINARY := spacectl
PKG := github.com/spacelift-io/spacectl
BUILD_FLAGS := -a -tags netgo -ldflags '-w -extldflags "-static"'

# Transforms from the architecture-specific binary name to a simple binary name inside the archive
TAR_TRANSFORM := --transform='flags=r;s|$(BINARY).*|spacectl|'
WIN_TAR_TRANSFORM := --transform='flags=r;s|$(BINARY).*|spacectl.exe|'

darwin:
	env GOOS=darwin GOARCH=amd64 CGO_ENABLED=0 go build $(BUILD_FLAGS) -o build/$(BINARY)-darwin-amd64 $(PKG)
	env GOOS=darwin GOARCH=arm64 CGO_ENABLED=0 go build $(BUILD_FLAGS) -o build/$(BINARY)-darwin-arm64 $(PKG)

linux:
	env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build $(BUILD_FLAGS) -o build/$(BINARY)-linux-amd64 $(PKG)
	env GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build $(BUILD_FLAGS) -o build/$(BINARY)-linux-arm64 $(PKG)

windows:
	env GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build $(BUILD_FLAGS) -o build/$(BINARY)-windows-amd64 $(PKG)

build: darwin linux windows

release: build
	cd build; tar -czf $(BINARY)-darwin-amd64.tar.gz $(TAR_TRANSFORM) $(BINARY)-darwin-amd64
	cd build; tar -czf $(BINARY)-darwin-arm64.tar.gz $(TAR_TRANSFORM) $(BINARY)-darwin-arm64
	cd build; tar -czf $(BINARY)-linux-amd64.tar.gz $(TAR_TRANSFORM) $(BINARY)-linux-amd64
	cd build; tar -czf $(BINARY)-linux-arm64.tar.gz $(TAR_TRANSFORM) $(BINARY)-linux-arm64
	cd build; tar -czf $(BINARY)-windows-amd64.tar.gz $(WIN_TAR_TRANSFORM) $(BINARY)-windows-amd64

clean:
	go clean
	rm -rf build/$(BINARY)*
