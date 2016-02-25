#!/bin/bash

# used to convert ionicons to SVG

for src in *.png; do
	name=`basename $src .png`
	pnm="$name.pnm"
	svg="$name.svg"
	pngtopnm -mix $src > $pnm && potrace $pnm -s -o $svg && rm $pnm
	# set colour
	sed -i "s/#000000/#016b8f/g" *.svg
	# same for PNG
	# mogrify -fill '#016b8f' -opaque black *.png
done

