InputGrabber
	var
		client/__source;
		list/__inputGrabs = list();

	proc
		isActive() {
			return length(src.__inputGrabs);
		}

		__nextGrab() {
			src.__inputGrabs.Cut(1,2);
		}

		__addGrab(InputGrab/grab) {
			src.__inputGrabs.Add(grab);
		}

		__getCurrentGrab() {
			return __inputGrabs[1];
		}

		receive(T) {
			var/InputGrab/grab = src.__getCurrentGrab();
			. = grab.__receive(T);
			src.__nextGrab();

		}