CallRequest
	New(source, procName) {
		src.source = source;
		src.procName = procName;
	}

	var
		source;
		procName;

	proc
		Run() {
			if(hascall(source,procName)) call(source,procName)(arglist(args));
		}