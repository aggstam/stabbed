.POSIX:

STABED_PATH = $(shell pwd)
TABBED_PATH = tabbed
ST_PATH = st

define STABBED =
#!/bin/sh
# --------------------------------------------------------------------------
#
# Very simple script to invoking suckless tabbed with st, resulting in a terminal
# with tabs support built-in.
# Usage: ./stabbed
#
# Author: Aggelos Stamatiou, September 2023
#
# See LICENSE file for copyright and license details.
# --------------------------------------------------------------------------

$(STABED_PATH)/$(TABBED_PATH)/tabbed -cr 2 $(STABED_PATH)/$(ST_PATH)/st -w ''
endef

all: stabbed

patch-tabbed:
	# First we apply our patch
	cd $(TABBED_PATH); git apply $(STABED_PATH)/tabbed-drag-20230128-41e2b8f.diff
	$(MAKE) config.h -C $(TABBED_PATH)
	# and then our custom configuration
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
	# First we apply our patch
	cd $(ST_PATH); git apply $(STABED_PATH)/st.diff
	$(MAKE) config.h -C $(ST_PATH)
	# and then our custom configuration
	sed -i $(ST_PATH)/config.h \
	-e "s|pixelsize=12|pixelsize=20|g" \
	-e "s|/bin/sh|/bin/zsh|g" \
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
	$(MAKE) clean -C $(TABBED_PATH)
	cd $(TABBED_PATH); git reset --hard; rm -f config.h
	$(MAKE) clean -C $(ST_PATH)
	cd $(ST_PATH); git reset --hard; rm -f config.h
	rm -f stabbed
	sed -i -e "s|Icon=.*|Icon=stabbed-icon.png|g" tabbed.desktop

install: stabbed
	su -c "mkdir -p $(DESTDIR)$(PREFIX)/bin; cp -f stabbed $(DESTDIR)$(PREFIX)/bin; chmod 755 $(DESTDIR)$(PREFIX)/bin/stabbed"

install-desktop: install
	sed -i -e "s|Icon=.*|Icon=$(STABED_PATH)/stabbed-icon.png|g" tabbed.desktop
	mkdir -p $(HOME)/.local/share/applications
	cp tabbed.desktop $(HOME)/.local/share/applications

uninstall:
	su -c "rm -f $(DESTDIR)$(PREFIX)/bin/stabbed"
	rm -f $(HOME)/.local/share/applications/tabbed.desktop	

.PHONY: all patch-tabbed patch-st clean install install-desktop uninstall
