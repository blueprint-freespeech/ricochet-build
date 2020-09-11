rbm=./rbm/rbm

all: release

release: submodule-update
	$(rbm) build release --target release --target tego-all

release-linux-x86_64: submodule-update
	$(rbm) build release --target release --target tego-linux-x86_64

release-linux-i686: submodule-update
	$(rbm) build release --target release --target tego-linux-i686

release-windows-i686: submodule-update
	$(rbm) build release --target release --target tego-windows-i686

release-windows-x86_64: submodule-update
	$(rbm) build release --target release --target tego-windows-x86_64

release-osx-x86_64: submodule-update
	$(rbm) build release --target release --target tego-osx-x86_64

nightly: submodule-update
	$(rbm) build release --target nightly --target tego-all

nightly-linux-x86_64: submodule-update
	$(rbm) build release --target nightly --target tego-linux-x86_64

nightly-linux-i686: submodule-update
	$(rbm) build release --target nightly --target tego-linux-i686

nightly-windows-i686: submodule-update
	$(rbm) build release --target nightly --target tego-windows-i686

nightly-windows-x86_64: submodule-update
	$(rbm) build release --target nightly --target tego-windows-x86_64

nightly-osx-x86_64: submodule-update
	$(rbm) build release --target nightly --target tego-osx-x86_64

submodule-update:
	git submodule update --init

fetch: submodule-update
	$(rbm) fetch

clean: submodule-update
	./tools/clean-old

clean-dry-run: submodule-update
	./tools/clean-old --dry-run

