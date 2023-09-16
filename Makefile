.POSIX:

STABED_PATH = $(shell pwd)
PATCHES_PATH = $(STABED_PATH)/patches
TABBED_PATH = tabbed
ST_PATH = st
ST_WORKING_BRANCH = 0.8.5

all: stabbed

patch: clean
	cd $(ST_PATH); git checkout $(ST_WORKING_BRANCH); cd ..;
	for file in $(PATCHES_PATH)/*; do \
	    if [[ $${file} == "$(PATCHES_PATH)/tabbed"* ]]; then \
			echo "Applying tabbed patch: " $${file}; \
			cd $(TABBED_PATH); pwd; cd ..; \
		else \
			echo "Applying st patch: " $${file}; \
			cd $(ST_PATH); git apply $${file}; cd ..; \
		fi \
	done

stabbed: patch
	$(MAKE) -C $(TABBED_PATH)
	$(MAKE) -C $(ST_PATH)
	echo -e "#!/bin/sh\n$(STABED_PATH)/$(TABBED_PATH)/tabbed -cr 2 $(STABED_PATH)/$(ST_PATH)/st -w ''" > stabbed

clean:
	$(MAKE) clean -C $(TABBED_PATH)
	cd $(TABBED_PATH); git reset --hard; git checkout master; cd ..;
	$(MAKE) clean -C $(ST_PATH)
	cd $(ST_PATH); git reset --hard; git checkout master; cd ..;
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

.PHONY: all patch clean install install-desktop uninstall
