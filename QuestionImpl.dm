Question
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