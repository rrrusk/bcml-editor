CodeMirror.defineSimpleMode("bcml", {
	start: [
		{regex: /@\([^\s]+/, token: "keyword", next: "multiLiner"},
		{regex: /@---/, token: "comment", next: "comment"},
		{regex: /^([ \t]*)(@[^\s]+)(.*)/, token: [null,"keyword","variable-2"]}
	],
	multiLiner: [
		{regex: /(.*?)(\)@)/, token: ["variable-2","keyword"], next: "start"},
		{regex: /.*/, token: "variable-2"}
	],
	comment: [
		{regex: /.*?---@/, token: "comment", next: "start"},
		{regex: /.*/, token: "comment"}
	],
	meta: {
		dontIndentStates: ["comment"]
	}
});
