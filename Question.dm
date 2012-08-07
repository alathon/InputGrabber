Question
	proc
		sendToClient(client/C, txt) {
			C << txt;
		}

Question
	Number
		__needRetry(v) {
			return ("[text2num(v)]" != "[v]");
		}

	proc
		getValue() {
			return src.__value;
		}

		getRetryQuestion() {
			if(showTries) return "[retryQuestion] ([tries] attempt[tries > 1 ? "s":""] left)";
			else return retryQuestion;
		}

		__canRetry() {
			return src.tries > 0;
		}

		__needRetry(v) {
			return FALSE;
		}

		__tryValue(client/C, v) {
			src.tries--;
			if(src.__needRetry(v)) {
				if(src.__canRetry()) {
					src.sendToClient(source, src.getRetryQuestion());
				} else {
					if(callRequest != null) {
						callRequest.Run(C, null);
					}
				}
			} else {
				src.__value = v;
				if(callRequest != null) {
					callRequest.Run(C, v);
				}
				return v;
			}
		}

		__setupCallback(CallRequest/callReq) {
			src.grab = new /InputGrab/(source, new /CallRequest(src, "  tryValue"));
			src.callRequest = callReq;

		}

		__inputLoop() {
			var/value;
			do {
				src.grab = new /InputGrab/Blocking(source);
				value = src.__tryValue(source, grab.getValue());
			} while(value == null && src.__canRetry());
			src.__value = value;
			return src.__value;
		}

	var
		CallRequest/callRequest = null;
		InputGrab/grab;
		client/source;
		question = "";
		retryQuestion = "";
		showTries = FALSE;
		tries = 1;
		__value;

	New(client/C, qText, CallRequest/callReq) {
		source = C;
		question = qText;
		sendToClient(C, question);
		if(callReq == null) {
			src.__inputLoop();
		} else {
			src.__setupCallback(callReq);
		}
	}