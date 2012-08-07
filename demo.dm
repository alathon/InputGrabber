/* Step 1: Override client.getGrabber() with a valid InputGrabber instance */
client
	var
		InputGrabber/grabber = new();

	getGrabber() { return grabber; }


/* Step 2: Override client.Command() to send input to the grabber if its active. */
client/Command(T) {
	if(src.grabber.isActive()) {
		var/ok = src.grabber.receive(T);
		src << "Returned from grabber: [ok]";
	} else if(T == "blocking") {
		spawn() src.TestBlocking();
	} else if(T == "nonblocking") {
		spawn() src.TestNonblocking();
	} else {
		src << "No grabbers active atm.";
		src << "Type 'blocking' to test blocking input, and 'nonblocking' to test non-blocking input."
	}
}

/* Step 3: Set up test verbs */
client/proc/win(T) {
	src << "You typed in [T], we're now in /client/proc/win()!";
}

client/proc/TestBlocking() {
	src << "Entering client.TestBlocking()... Type something";
	var/InputGrab/grab = new /InputGrab/Blocking(src);
	src << "You typed in [grab.getValue()], we're still in client.TestBlocking()!.";
	src << "Type something else!";

	grab = new /InputGrab/Blocking(src);
	src << "Now you typed in [grab.getValue()]; lets exit TestBlocking() now!";
}

client/proc/TestNonblocking() {
	src << "Entering client.TestNonblocking()...";
	new /InputGrab(src, src, "win");
	src << "Life goes on!";
}