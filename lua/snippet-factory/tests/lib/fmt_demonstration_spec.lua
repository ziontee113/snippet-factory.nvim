local fmt = require("snippet-factory.lib.fmt")

describe("fmt demonstration", function()
	it("works with 1 slot", function()
		local placeholder = "Hello {}"
		local slots = { "Venus" }

		local want = "Hello Venus"
		local got = fmt(placeholder, slots)

		assert(want == got)
	end)

	it("works with 2 slots", function()
		local placeholder = "Hello {}, {}"
		local slots = { "Venus", "how are you?" }

		local want = "Hello Venus, how are you?"
		local got = fmt(placeholder, slots)

		assert(want == got)
	end)
end)
