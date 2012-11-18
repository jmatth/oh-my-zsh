# Get bus information using the rubus site
function bus () {
	typeset stop="$1$2$3"

	if [ -z "$stop" ]; then
		stop="hill"
	fi

	curl "http://vverma.net/nextbus/nextbus.php?android=1&s=$stop"
}
