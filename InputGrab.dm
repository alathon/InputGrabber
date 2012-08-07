InputGrab
	Blocking
		New(client/C, source, procName) {
			..(C, source, procName);
			src.waitForAnswer();
		}

		proc
			waitForAnswer() {
				while(!__answer) {
					sleep(1);
				}
			}

	New(client/C, source, procName) {
		var/InputGrabber/grabber = C.getGrabber();
		grabber.__addGrab(src);
		if(source && procName && hascall(source,procName)) {
			src.__returnProc = procName;
			src.__returnObj = source;
		}
	}

	var
		__answer;
		__returnProc;
		__returnObj;

	proc
		getValue() {
			return __answer;
		}

		__receive(T) {
			if(__returnProc) {
				call(__returnObj, __returnProc)(T);
			}
			__answer = T;
			return T;
		}