.POSIX:

STABED_PATH = $(shell pwd)
TABBED_PATH = tabbed
ST_PATH = st

all: stabbed

stabbed: clean
	$(MAKE) -C $(TABBED_PATH)
	$(MAKE) -C $(ST_PATH)
	echo "$(STABED_PATH)/$(TABBED_PATH)/tabbed -cr 2 $(STABED_PATH)/$(ST_PATH)/st -w ''" > stabbed

clean:
	$(MAKE) clean -C $(TABBED_PATH)
	$(MAKE) clean -C $(ST_PATH)
	rm -f stabbed
	sed -i -e "s|Icon=.*|Icon=stabbed-icon.svg|g" stabbed.desktop

install: stabbed
	su -c "mkdir -p $(DESTDIR)$(PREFIX)/bin; cp -f stabbed $(DESTDIR)$(PREFIX)/bin; chmod 755 $(DESTDIR)$(PREFIX)/bin/stabbed"

install-desktop: install
	sed -i -e "s|Icon=.*|Icon=$(STABED_PATH)/stabbed-icon.svg|g" stabbed.desktop
	mkdir -p $(HOME)/.local/share/applications
	cp stabbed.desktop $(HOME)/.local/share/applications

uninstall:
	su -c "rm -f $(DESTDIR)$(PREFIX)/bin/stabbed"
	rm -f $(HOME)/.local/share/applications/stabbed.desktop	

.PHONY: all clean install install-desktop uninstall
