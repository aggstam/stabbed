# stabbed ![Screenshot](stabbed-icon.png)
stabbed is a very simple script invoking [suckless](https://suckless.org/) [tabbed](https://tools.suckless.org/tabbed/) with [st](https://st.suckless.org/),
resulting in a terminal with tabs support built-in.
<br>
Patches and custom configuration are provided to achieve the desired behavior.

## Requirements
In order to build both tabbed and st, you need the Xlib header files.
<br>
Alpha patch(opacity) requires an X composite manager (e.g. xcompmgr, picom).

## Patches
### tabbed
A custom patch has been created, to work with latest master, combining the following patches:
1. [alpha](https://tools.suckless.org/tabbed/patches/alpha/)
2. [drag](https://tools.suckless.org/tabbed/patches/drag/)

### st
A custom patch has been created, to work with latest master, combining the following patches:
1. [alpha](https://st.suckless.org/patches/alpha/)
2. [blinking cursor](https://st.suckless.org/patches/blinking_cursor/)
3. [bold is not bright](https://st.suckless.org/patches/bold-is-not-bright/)
4. [scrollback](https://st.suckless.org/patches/scrollback/)
5. [scrollback-ringbuffer](https://st.suckless.org/patches/scrollback/st-scrollback-ringbuffer-0.8.5.diff)
6. [scrollback-mouse](https://st.suckless.org/patches/scrollback/st-scrollback-mouse-20220127-2c5edf2.diff)
7. [scrollback-mouse-altscreen](https://st.suckless.org/patches/scrollback/st-scrollback-mouse-altscreen-20220127-2c5edf2.diff)
8. [simple-plumb](https://st.suckless.org/patches/right_click_to_plumb/simple_plumb-0.8.5.diff)
9. [universcroll](https://st.suckless.org/patches/universcroll/)

## Build
On first pull, we have to also pull suckless repos, so execute:
```shell
$ git submodule update --init
```
Then, you can build everything using the provided makefile:
```shell
$ make
```
This will first apply all patches and then build tabbed, st and stabbed inside project folder.

## Execution
To run stabbed, you have to first give the corresponding permissions to the script, and then execute it:
```shell
$ chmod a+x stabbed
$ ./stabbed
```

## Installation
To install the script into your system, simply execute:
```shell
$ make install
```
If you also want to generate and install a .desktop file for the script, execute:
```shell
$ make desktop
```
Or in a single command:
```shell
$ make install desktop
```
These commands will *NOT* install tabbed or st in your system, as the script uses the patched ones from the project folder.

## Usage
Stabbed is configured to use `zsh` as default shell.
<br>
You can use a different shell using `SHELL={shell}` make flag.
<br>
To configure opacity, use `OPACITY={value}` make flag.
<br>
This is our custom key bindings configuration for stabbed:
| Key                 | Action                        |
|---------------------|-------------------------------|
| Ctrl+Shift+t        | Spawn new tab                 |
| Ctrl+PageUp         | Go to previous tab            |
| Ctrl+PageDown       | Go to next tab                |
| Ctrl+Shift+PageUp   | Move tab to previous position |
| Ctrl+Shift+PageDown | Move tab to next position     |
| Shift+PageUp        | Scroll up                     |
| Shift+PageDown      | Scroll down                   |
| Ctrl+Minus          | Zoom out                      |
| Ctrl+Shift+Plus     | Zoom in                       |

### Plumber
A custom plumber script is provided, which is invoked using mouse Button3(right click) for highlighted selection.
<br>
Sofrware used by the plumber:
1. [feh](https://feh.finalrewind.org/)
2. [mpv](https://mpv.io/)
3. [hurl](https://codemadness.org/git/hurl/) (requires lbtls-devel)
4. [imagemagick](https://imagemagick.org/)
5. [sacc](https://codemadness.org/git/sacc/) (requires lbtls-devel)
6. [firefox](https://www.mozilla.org/en-US/firefox/new/) or any of its forks

You can configure the script to use different software and/or expand its capabilities.

## Credits
Massive thanks to the suckless team for making software that sucks less.
<br>
Original plumber script was kindly provided by [parazyd](https://github.com/parazyd).
<br>
Stabbed custom icon uses a vector kindly provided from List Heist.
