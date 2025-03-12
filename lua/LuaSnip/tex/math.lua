local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta

local conditions = require("LuaSnip.tex.utils.conditions")
local helpers = require("LuaSnip.tex.utils.functions")
local mat = helpers.generate_matrix

local auto_backslash = {
	"arcsin",
	"sin",
	"arccos",
	"cos",
	"arctan",
	"tan",
	"cot",
	"csc",
	"sec",
	"log",
	"ln",
	"exp",
	"ast",
	"star",
	"perp",
	"sup",
	"inf",
	"det",
	"max",
	"min",
	"argmax",
	"argmin",
	"deg",
	"angle",
}

local auto_backslash_snippets = {}
for _, name in ipairs(auto_backslash) do
	table.insert(
		auto_backslash_snippets,
		s({ trig = name, snippetType = "autosnippet" }, { t("\\" .. name) }, { condition = conditions.in_mathzone })
	)
end

-- 符號
local symbols = {
	["ooo"] = { command = "\\infty", symbol = "∞" },
	["!="] = { command = "\\neq", symbol = "" },
	[">="] = { command = "\\geq", symbol = "" },
	["<="] = { command = "\\leq", symbol = "" },
	[">>"] = { command = "\\gg", symbol = ">>" },
	["<<"] = { command = "\\ll", symbol = "<<" },
	["~~"] = { command = "\\sim", symbol = "~" },
	["~="] = { command = "\\approx", symbol = "󰾞" },
	["~-"] = { command = "\\simeq", symbol = "≃" },
	["..."] = { command = "\\dots", symbol = "..." },
}

local symbol_snippets = {}
for trig, data in pairs(symbols) do
	table.insert(
		symbol_snippets,
		s(
			{ trig = trig, snippetType = "autosnippet", dscr = data.symbol },
			{ t(data.command .. " ") },
			{ condition = conditions.in_mathzone }
		)
	)
end

M = {
	-- Math Modes
	s(
		{ trig = "dm", dscr = "display math", snippetType = "autosnippet" },
		fmta(
			[[
                \[
                    <>
                \]
            ]],
			{ i(0) }
		)
	),
	s(
		{ trig = "mk", dscr = "inline math", snippetType = "autosnippet" },
		fmta(
			[[
                \(<>\)<>
            ]],
			{ i(1), i(0) }
		)
	),
	-- \text{}
	s(
		{ trig = "tx", dscr = "text", snippetType = "autosnippet" },
		fmta(
			[[
                \text{<>}
            ]],
			{ i(1) }
		),
		{ condition = conditions.in_mathzone }
	),

	-- 平方, 立方, 補數, ^{}
	s(
		{ trig = "(%w)sr", dscr = "^2", snippetType = "autosnippet", regTrig = true, wordTrig = false },
		fmta("<>^{2}", {
			f(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = conditions.in_mathzone }
	),
	s(
		{ trig = "(%w)cb", dscr = "^3", snippetType = "autosnippet", regTrig = true, wordTrig = false },
		fmta("<>^3", {
			f(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = conditions.in_mathzone }
	),
	s(
		{ trig = "(%a+)coml", dscr = "complement", snippetType = "autosnippet", regTrig = true, wordTrig = false },
		fmta("<>^{c}", {
			f(function(_, snip)
				return snip.captures[1]
			end),
		})
	),
	s(
		{ trig = "td", dscr = "^{}", snippetType = "autosnippet", regTrig = true, wordTrig = false },
		fmta("^{<>} <>", { i(1), i(0) }),
		{ condition = conditions.in_mathzone }
	),
	-- 分數, 根號
	s(
		{ trig = "//", dscr = "fraction", snippetType = "autosnippet", regTrig = true, wordTrig = false },
		fmta("\\frac{<>}{<>}<>", { i(1), i(2), i(0) }),
		{ condition = conditions.in_mathzone }
	),
	s(
		{ trig = "(%w)/", dscr = "fraction", snippetType = "autosnippet", regTrig = true, wordTrig = false },
		fmta("\\frac{<>}{<>}<>", {
			f(function(_, snip)
				return snip.captures[1]
			end),
			i(1),
			i(0),
		}),
		{ condition = conditions.in_mathzone }
	),
	s(
		{
			trig = "(%b())/",
			dscr = "fraction",
			snippetType = "autosnippet",
			regTrig = true,
			wordTrig = false,
		},
		fmta("\\frac{<>}{<>}<>", {
			f(function(_, snip)
				local content = snip.captures[1]
				return content:sub(2, #content - 1)
			end),
			i(1),
			i(0),
		}),
		{ condition = conditions.in_mathzone }
	),
	s(
		{ trig = "sqrt", dscr = "square root", snippetType = "autosnippet", regTrig = true, wordTrig = false },
		fmta("\\sqrt{<>} ", { i(1) }),
		{ condition = conditions.in_mathzone }
	),
	s({
		trig = "sqrt",
		dscr = "square root",
		show_condition = function()
			return conditions.in_mathzone()
		end,
	}, fmta("\\sqrt{<>} ", { i(1) }), { condition = conditions.in_mathzone }),
	-- 微分, 積分, limit, sum
	s(
		{ trig = "df", dscr = "diff", snippetType = "autosnippet", regTrig = true, wordTrig = false },
		fmta(
			[[
                \frac{\mathrm{d}<>}{\mathrm{d}<>} <>
            ]],
			{ i(1), i(2, "x"), i(0) }
		),
		{ condition = conditions.in_mathzone }
	),
	s(
		{ trig = "pd", dscr = "partial", snippetType = "autosnippet", regTrig = true, wordTrig = false },
		fmta(
			[[
                \frac{\partial <>}{\partial <>} <>
            ]],
			{ i(1), i(2), i(0) }
		),
		{ condition = conditions.in_mathzone }
	),
	s(
		{ trig = "dint", dscr = "integral", snippetType = "autosnippet", regTrig = true, wordTrig = false },
		fmta(
			[[
                \int_{<>}^{<>} <> \mathrm{d}x
            ]],
			{ i(1), i(2), i(0) }
		),
		{ condition = conditions.in_mathzone }
	),
	s(
		{ trig = "oint", dscr = "curve integral", snippetType = "autosnippet", regTrig = true, wordTrig = false },
		fmta(
			[[
                \oint <> \mathrm{d}s 
            ]],
			{ i(1) }
		),
		{ condition = conditions.in_mathzone }
	),
	s(
		{ trig = "lim", dscr = "limit", snippetType = "autosnippet" },
		fmta(
			[[
                \lim_{n \to \infty} <>
            ]],
			{ i(1) }
		),
		{ condition = conditions.in_mathzone }
	),
	s(
		{ trig = "sum", dscr = "sum", snippetType = "autosnippet" },
		fmta(
			[[
                \sum_{<>}^{<>} <>
            ]],
			{ i(1, "n=1"), i(2, "\\infty"), i(0) }
		),
		{ condition = conditions.in_mathzone }
	),
	-- matrix
	s(
		{
			trig = "([bpvBV])mat(%d+) (%d+)(%s)",
			dscr = "matrix",
			snippetType = "autosnippet",
			regTrig = true,
			wordTrig = false,
		},
		fmta(
			[[
                \begin{<>}
                <>
                \end{<>}
            ]],
			{
				f(function(_, snip)
					return snip.captures[1] .. "matrix"
				end),
				d(1, mat),
				f(function(_, snip)
					return snip.captures[1] .. "matrix"
				end),
			}
		),
		{ condition = conditions.in_mathzone }
	),
	-- 數學模式或是tikz環境下字母後面輸入重複數字會變成下標 e.g. a11 -> a_{1}
	s(
		{ trig = "([%a%)%]%}])(%w)%2(%w*)", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta("<>_{<><>} ", {
			f(function(_, snip)
				return snip.captures[1]
			end),
			f(function(_, snip)
				return snip.captures[2] .. snip.captures[3]
			end),
			i(1),
		}),
		{
			condition = function()
				return conditions.in_mathzone() or conditions.in_tikz()
			end,
		}
	),
}

vim.list_extend(M, auto_backslash_snippets)
vim.list_extend(M, symbol_snippets)
return M
