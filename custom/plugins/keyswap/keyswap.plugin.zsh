# Function to swap keys to my liking
function keyswap () {
	# No flag, assume swapping esc and caps
	if ! (($+1))
	then
		xmodmap -e 'remove Lock = Caps_Lock' \
		-e 'keycode 66 = Escape' \
		-e 'keycode 9 = Caps_Lock' \
		-e 'keycode 49 = grave asciitilde grave asciitilde'

	# Swapping for the kbt pure
	elif [[ $1 == "-p" ]]
	then
		xmodmap -e 'remove Lock = Caps_Lock' \
		-e 'keycode 9 = grave asciitilde grave asciitilde' \
		-e 'keycode 49 = Caps_Lock' \
		-e 'keycode 66 = Escape'

	# Reset everything
	elif [[ $1 == "-r" ]]
	then
		xmodmap -e 'keycode 66 = Caps_Lock' \
		-e 'keycode 9 = Escape' \
		-e 'keycode 49 = grave asciitilde grave asciitilde'

	# Weird flag, print help
	else
		print "Usage: keyswap [-p|-r]"
		print "-p:\tSwap for KBT Pure."
		print "-r:\tReset key layout."
	fi
}
