return {
	settings = {
		["harper-ls"] = {
			userDictFile = vim.fn.stdpath("data") .. "/harper-dict.txt",
			linters = {
				spell_check = true,
				an_a = true,
				sentence_capitalization = true,
				unclosed_quotes = true,
				correct_number_suffix = true,
				number_suffix_capitalization = true,
				multiple_sequential_pronouns = true,
				terminating_conjunctions = true,
				avoid_curses = true,
				linking_verbs = false,
				spelled_numbers = false,
			},
		},
	},
}
