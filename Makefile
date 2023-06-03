rbm=./rbm/rbm

##################
# Common Targets #
##################

submodule-update:
	git submodule update --init

clean:
	./rbm/container run -- rm -Rf ./tmp/rbm-*
	rm -rf ./logs
	rm -rf /var/tmp/${USER}

#################
# Build Targets #
#################

# Stable Releases

ricochet-linux-stable: ricochet-linux-i686-stable ricochet-linux-x86_64-stable

ricochet-linux-i686-stable: submodule-update
	$(rbm) build package --target linux --target linux-i686 --target stable

ricochet-linux-x86_64-stable: submodule-update
	$(rbm) build package --target linux --target linux-x86_64 --target stable

ricochet-macos-stable: ricochet-macos-x86_64-stable ricochet-macos-aarch64-stable

ricochet-macos-x86_64-stable: submodule-update
	$(rbm) build package --target macos --target macos-x86_64 --target stable

ricochet-macos-aarch64-stable: submodule-update
	$(rbm) build package --target macos --target macos-aarch64 --target stable

ricochet-windows-stable: ricochet-windows-i686-stable ricochet-windows-x86_64-stable

ricochet-windows-i686-stable: submodule-update
	$(rbm) build package --target windows --target windows-i686 --target stable

ricochet-windows-x86_64-stable: submodule-update
	$(rbm) build package --target windows --target windows-x86_64 --target stable

ricochet-release-stable: submodule-update
	$(rbm) build release --target stable

ricochet-release-stable-sign: submodule-update
	$(rbm) build release --target stable --target sign

# Alpha Releases

ricochet-linux-alpha: ricochet-linux-i686-alpha ricochet-linux-x86_64-alpha

ricochet-linux-i686-alpha: submodule-update
	$(rbm) build package --target linux --target linux-i686 --target alpha

ricochet-linux-x86_64-alpha: submodule-update
	$(rbm) build package --target linux --target linux-x86_64 --target alpha

ricochet-macos-alpha: ricochet-macos-x86_64-alpha ricochet-macos-aarch64-alpha

ricochet-macos-x86_64-alpha: submodule-update
	$(rbm) build package --target macos --target macos-x86_64 --target alpha

ricochet-macos-aarch64-alpha: submodule-update
	$(rbm) build package --target macos --target macos-aarch64 --target alpha

ricochet-windows-alpha: ricochet-windows-i686-alpha ricochet-windows-x86_64-alpha

ricochet-windows-i686-alpha: submodule-update
	$(rbm) build package --target windows --target windows-i686 --target alpha

ricochet-windows-x86_64-alpha: submodule-update
	$(rbm) build package --target windows --target windows-x86_64 --target alpha

ricochet-release-alpha: submodule-update
	$(rbm) build release --target alpha

ricochet-release-alpha-sign: submodule-update
	$(rbm) build release --target alpha --target sign

# Dev Builds

ricochet-linux-testbuild: ricochet-linux-i686-testbuild ricochet-linux-x86_64-testbuild

ricochet-linux-i686-testbuild: submodule-update
	$(rbm) build package --target linux --target linux-i686 --target testbuild

ricochet-linux-x86_64-testbuild: submodule-update
	$(rbm) build package --target linux --target linux-x86_64 --target testbuild

ricochet-macos-testbuild: ricochet-macos-x86_64-testbuild ricochet-macos-aarch64-testbuild

ricochet-macos-x86_64-testbuild: submodule-update
	$(rbm) build package --target macos --target macos-x86_64 --target testbuild

ricochet-macos-aarch64-testbuild: submodule-update
	$(rbm) build package --target macos --target macos-aarch64 --target testbuild

ricochet-windows-testbuild: ricochet-windows-i686-testbuild ricochet-windows-x86_64-testbuild

ricochet-windows-i686-testbuild: submodule-update
	$(rbm) build package --target windows --target windows-i686 --target testbuild

ricochet-windows-x86_64-testbuild: submodule-update
	$(rbm) build package --target windows --target windows-x86_64 --target testbuild

ricochet-release-testbuild: submodule-update
	$(rbm) build release --target testbuild
