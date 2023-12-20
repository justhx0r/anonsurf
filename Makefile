os_name = "$(shell cat /etc/os-release | grep "^ID=" | cut -d = -f 2)"
NIMFLAGS :=-t:on --panics:off -f:on --embedsrc:off --nimMainPrefix:"AnonSurf" -a:on --docCmd:"pass" --tlsEmulation:off  --warnings:off --genScript:off --benchmarkVM:off --profileVM:off --mm:arc   --implicitStatic:on --hints:off --stackTrace:off --lineTrace:off 

all: clean build install

clean:
	rm -rf bin

debuild:
	debuild


uninstall:
	# Remove config files
	rm -rf /etc/anonsurf/
	# Remove daemon scripts and some other binaries
	rm -rf /usr/lib/anonsurf/
	# Remove binaries
	rm /usr/bin/anonsurf
	rm /usr/bin/anonsurf-gtk
	# Remove systemd unit
	rm /lib/systemd/system/anonsurfd.service
# Remove launchers
	rm /usr/share/applications/anonsurf*.desktop

build-parrot:
	# Compile binary on parrot's platform. libnim-gintro-dev is required.
	# Gintro 0.9.8 is required
	mkdir -p bin/
	nim c $(NIMFLAGS) --opt:speed --out:bin/dnstool nimsrc/dnstool/dnstool.nim
	nim c $(NIMFLAGS) --opt:speed --out:bin/make-torrc -d:release nimsrc/anonsurf/make_torrc.nim
	nim c $(NIMFLAGS) --opt:speed --out:bin/anonsurf-gtk -p:/usr/include/nim/ -d:release nimsrc/anonsurf/AnonSurfGTK.nim
	nim c $(NIMFLAGS) --opt:speed --out:bin/anonsurf -p:/usr/include/nim/ -d:release nimsrc/anonsurf/AnonSurfCli.nim


install:
	# Create all folders
	sudo mkdir -p $(DESTDIR)/etc/anonsurf/
	sudo mkdir -p $(DESTDIR)/usr/lib/anonsurf/
	sudo mkdir -p $(DESTDIR)/usr/bin/
	sudo mkdir -p $(DESTDIR)/usr/share/applications/
	sudo mkdir -p $(DESTDIR)/lib/systemd/system/

	# Copy binaries to system
	sudo cp bin/anonsurf $(DESTDIR)/usr/bin/anonsurf
	sudo cp bin/anonsurf-gtk $(DESTDIR)/usr/bin/anonsurf-gtk
	sudo cp bin/dnstool $(DESTDIR)/usr/bin/dnstool
	sudo cp bin/make-torrc $(DESTDIR)/usr/lib/anonsurf/make-torrc
	sudo cp scripts/* $(DESTDIR)/usr/lib/anonsurf/

	# Copy launchers
	if [ os_name = "parrot" ]; then \
		sudo cp launchers/anon-change-identity.desktop $(DESTDIR)/usr/share/applications/; \
		sudo cp launchers/anon-surf-start.desktop $(DESTDIR)/usr/share/applications/; \
		sudo cp launchers/anon-surf-stop.desktop $(DESTDIR)/usr/share/applications/; \
		sudo cp launchers/anon-check-ip.desktop $(DESTDIR)/usr/share/applications/; \
		sudo cp launchers/anon-gui.desktop $(DESTDIR)/usr/share/applications/; \
	else \
		sudo cp launchers/non-native/*.desktop $(DESTDIR)/usr/share/applications/; \
	fi

	# Copy configs
	sudo cp configs/bridges.txt $(DESTDIR)/etc/anonsurf/.
	sudo cp configs/onion.pac $(DESTDIR)/etc/anonsurf/.

	# Copy daemon service
	sudo cp sys-units/anonsurfd.service $(DESTDIR)/lib/systemd/system/anonsurfd.service
