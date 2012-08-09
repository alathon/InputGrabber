Question
	Repeating
		New(client/source, question, retryQuestion, repeatQuestion, noMatchQuestion,
		tries, showTries, CallRequest/callRequest) {
			src.repeatQuestion = repeatQuestion;
			..(source,question,retryQuestion,tries,showTries,callRequest);
		}

		var
			__first = null;
			repeatQuestion = "Please repeat...";
			noMatchQuestion = "Those answers don't match!";

		__act() {
			if(src.__first == null) {
				sendToClient(source, question);
			} else {
				sendToClient(source, repeatQuestion);
			}

			if(callRequest == null) {
				src.__inputLoop();
			} else {
				src.grab = new /InputGrab/(source, new /CallRequest(src, "  tryValue"));
			}
		}

		__tryValue(client/C, v) {
			if(src.__needRetry(v)) { // Improper input
				src.sendToClient(C, src.getRetryQuestion());
				src.__act();
			} else {
				if(!__first) { // First time
					src.__first = v;
					src.__act();
				} else {
					if(src.__first != v) { // First time doesn't match second time.
						if(--src.tries == 0) { // Out of tries. Exit
							if(callRequest != null) {
								callRequest.Run(C, null);
							}
							return;
						}
						src.sendToClient(C, src.noMatchQuestion);
						src.__first = null;
						src.__act();
					} else { // Match and win!
						src.__value = v;
						if(callRequest != null) {
							callRequest.Run(C, v);
						}
					}
				}
			}
		}

	Password
		parent_type = /Question/Repeating
		retryQuestion = "Your password must be 8 characters or more.";
		noMatchQuestion = "The passwords don't match.";
		tries = 2;
		showTries = FALSE;

		__needRetry(v) {
			return (length(v) < 8);
		}

	Number
		getValue() {
			return text2num(__value);
		}

		__needRetry(v) {
			return ("[text2num(v)]" != "[v]");
		}

	YesNo
		getValue() {
			if(__value == "y" || __value == "yes") return TRUE;
			return FALSE;
		}

		__needRetry(v) {
			v = lowertext(v);
			if(v == "y" || v == "yes" || v == "n" || v == "no") return FALSE;
			return TRUE;
		}