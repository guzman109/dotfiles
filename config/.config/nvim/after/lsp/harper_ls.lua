return {
	filetypes = { "markdown", "text", "gitcommit" },
	settings = {
		["harper-ls"] = {
			diagnosticSeverity = "hint",
			dialect = "American",
			maxFileLength = 120000,
			markdown = {
				IgnoreLinkTitle = true,
			},
			linters = {
				SpellCheck = true,
				SentenceCapitalization = false,
				LongSentences = false,
				RepeatedWords = true,
				Spaces = true,
				Matcher = true,
				AnA = true,
				UnclosedQuotes = true,
				WrongQuotes = false,
			},
			codeActions = {
				ForceStable = true,
			},
		},
	},
}
