Question
	proc
		sendToClient(client/C, txt) {
			C << txt;
		}

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

		__inputLoop() {
			var/value;
			do {
				src.grab = new /InputGrab/Blocking(source);
				value = src.__tryValue(source, grab.getValue());
			} while(value == null && src.__canRetry());
			src.__value = value;
			return src.__value;
		}

		__act() {
			sendToClient(source, question);
			if(callRequest == null) {
				src.__inputLoop();
			} else {
				src.grab = new /InputGrab/(source, new /CallRequest(src, "  tryValue"));
			}
		}

		__initializedProperly() {
			if(!src.source || !istype(src.source, /client)) return FALSE;
			if(callRequest && !istype(callRequest, /CallRequest)) return FALSE;
			return TRUE;
		}

	var
		CallRequest/callRequest;
		InputGrab/grab;
		client/source;
		question = "";
		retryQuestion = "";
		showTries = FALSE;
		tries = 1;
		__value;

	New(client/source, question, retryQuestion, tries, showTries, CallRequest/callRequest) {
		src.source 			= source;
		src.question		= question;
		src.retryQuestion 	= retryQuestion;
		src.tries			= tries;
		src.callRequest		= callRequest;

		if(__initializedProperly()) {
			__act();
		} else {
			CRASH("Question not initialized properly.");
		}
	}