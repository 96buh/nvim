-- Abbreviations used in this article and the LuaSnip docs
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local conditions = require("LuaSnip.tex.utils.conditions")
local helpers = require("LuaSnip.tex.utils.functions")
local get_visual = helpers.get_visual

-- Common
local common = {
	"part",
	"chapter",
	"section",
	"subsection",
	"subsubsection",

	"autoref",
	"ref",
	"cref",
	"eqref",
	"label",
}

local common_snippets = {}
for _, name in ipairs(common) do
	table.insert(
		common_snippets,
		s({
			trig = name,
			show_condition = function()
				return conditions.no_math_no_tikz()
			end,
		}, fmta("\\" .. name .. "{<>}", { i(1) }))
	)
end

M = {
	s(
		{ trig = "tilt", dscr = "Expands 'tilt' into LaTeX's textit{} command." },
		fmta("\\textit{<>}", {
			d(1, get_visual),
		})
	),
	s(
		{ trig = "bold", dscr = "bold font." },
		fmta("\\textbf{<>}", {
			d(1, get_visual),
		})
	),
	-- 將選取的字變為上標或是下標
	s(
		{ trig = "sup", dscr = "textsuperscript, 上標" },
		fmta("\\textsuperscript{<>}", {
			d(1, get_visual),
		})
	),
	s(
		{ trig = "sub", dscr = "textsubscript, 下標" },
		fmta("\\textsubscript{<>}", {
			d(1, get_visual),
		})
	),
}

vim.list_extend(M, common_snippets)
return M
