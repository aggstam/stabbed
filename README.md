# stabbed
stabbed is a very simple script invoking [suckless](https://suckless.org/) [tabbed](https://tools.suckless.org/tabbed/) with [st](https://st.suckless.org/),
resulting in a terminal with tabs support built-in.
<br>
Patches and custom configuration are provided to achieve the desired behavior.

## Requirements
In order to build both tabbed and st, you need the Xlib header files.

## Build
You can build everything using the provided Makefile:
```
% make
```
This will build tabbed, st and stabbed inside project folder.

## Usage
To run stabbed, you have to first give the corresponding permissions to the script, and then execute it:
```
% chmod a+x stabbed
% stabbed
```

## Installation
To install the script to your system, simply execute:
```
% make install
```
If you also want to generate a desktop file for the installed script, execute:
```
% make install-desktop
```
This command will *NOT* install tabbed or st in your system, as the script uses the custom ones from the project folder.
