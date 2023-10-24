.POSIX:

STABED_PATH = $(shell pwd)
TABBED_PATH = tabbed
ST_PATH = st
SHELL = zsh

define STABBED =
#!/bin/sh
# --------------------------------------------------------------------------
#
# Very simple script invoking suckless tabbed with st, resulting in a terminal
# with tabs support built-in.
# Usage: ./stabbed
#
# Author: Aggelos Stamatiou, September 2023
#
# See LICENSE file for copyright and license details.
# --------------------------------------------------------------------------

$(STABED_PATH)/$(TABBED_PATH)/tabbed -cr 2 $(STABED_PATH)/$(ST_PATH)/st -w '' -e '$(SHELL)'
endef

all: stabbed

patch-tabbed:
	@echo "Applying pach to tabbed..."
	cd $(TABBED_PATH); git apply $(STABED_PATH)/tabbed-drag-20230128-41e2b8f.diff
	@echo "Generating config file..."
	$(MAKE) config.h -C $(TABBED_PATH)
	@echo "Applying custom config..."
	sed -i $(TABBED_PATH)/config.h \
	-e "s|size=9|size=12|g" \
	-e "s|newposition   = 0|newposition   = 1|g" \
	-e "s|npisrelative  = False|npisrelative  = True|g" \
	-e "s|XK_Return, focusonce|XK_t,      focusonce|g" \
	-e "s|XK_Return, spawn|XK_t,      spawn|g" \
	-e "s|MODKEY\|ShiftMask,     XK_l,      rotate|MODKEY,               XK_Next,   rotate|g" \
	-e "s|MODKEY\|ShiftMask,     XK_h,      rotate|MODKEY,               XK_Prior,  rotate|g" \
	-e "s|XK_j,      movetab|XK_Prior,  movetab|g" \
	-e "s|XK_k,      movetab|XK_Next,   movetab|g"

patch-st:
	@echo "Applying pach to st..."
	cd $(ST_PATH); git apply $(STABED_PATH)/st.diff
	@echo "Generating config file..."
	$(MAKE) config.h -C $(ST_PATH)
	@echo "Applying custom config..."
	sed -i $(ST_PATH)/config.h \
	-e "s|pixelsize=12|pixelsize=20|g" \
	-e "s|/bin/sh|/bin/$(SHELL)|g" \
	-e "s|tabspaces = 8|tabspaces = 4|g" \
	-e "s|kscrollup,      {.i = 1}|kscrollup,      {.i = 10}|g" \
	-e "s|kscrolldown,    {.i = 1}|kscrolldown,    {.i = 10}|g" \
	-e "s|TERMMOD,              XK_Prior,       zoom|TERMMOD,              XK_plus,        zoom|g" \
	-e "s|TERMMOD,              XK_Next,        zoom|ControlMask,          XK_minus,       zoom|g"

stabbed: clean patch-tabbed patch-st
	$(MAKE) -C $(TABBED_PATH)
	$(MAKE) -C $(ST_PATH)
	$(file > stabbed,$(STABBED))

clean:
	@echo "Cleaning tabbed..."
	$(MAKE) clean -C $(TABBED_PATH)
	cd $(TABBED_PATH); git reset --hard; rm -f config.h
	@echo "Cleaning st..."
	$(MAKE) clean -C $(ST_PATH)
	cd $(ST_PATH); git reset --hard; rm -f config.h
	@echo "Removing stabbed..."
	rm -f stabbed
	@echo "Reset .desktop file..."
	sed -i -e "s|Icon=.*|Icon=stabbed-icon.png|g" tabbed.desktop

install: stabbed
	@echo "Changing to superuser to install the script into the system..."
	su -c "mkdir -p $(DESTDIR)$(PREFIX)/bin; cp -f stabbed $(DESTDIR)$(PREFIX)/bin; chmod 755 $(DESTDIR)$(PREFIX)/bin/stabbed"

install-desktop: install
	@echo "Changing to superuser to install the script into the system..."
	@echo "Updating and installing .desktop file..."
	sed -i -e "s|Icon=.*|Icon=$(STABED_PATH)/stabbed-icon.png|g" tabbed.desktop
	mkdir -p $(HOME)/.local/share/applications
	cp tabbed.desktop $(HOME)/.local/share/applications

uninstall:
	@echo "Changing to superuser to remove the script from the system..."
	su -c "rm -f $(DESTDIR)$(PREFIX)/bin/stabbed"
	@echo "Removing .desktop file, if present..."
	rm -f $(HOME)/.local/share/applications/tabbed.desktop	

.PHONY: all patch-tabbed patch-st clean install install-desktop uninstall
