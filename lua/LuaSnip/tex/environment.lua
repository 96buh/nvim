local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local conditions = require("LuaSnip.tex.utils.conditions")
local helpers = require("LuaSnip.tex.utils.functions")
local tab = helpers.generate_table

M = {
	s(
		{ trig = "beg", dsrc = "create environment", snippetType = "autosnippet" },
		fmta(
			[[
                \begin{<>}
                    <>
                \end{<>}
            ]],
			{ i(1), i(0), rep(1) }
		)
	),
	-- tikz
	s(
		{ trig = "tikz", dsrc = "tikzpicture" },
		fmta(
			[[
                \begin{tikzpicture}
                    <>
                \end{tikzpicture}
            ]],
			{ i(1) }
		),
		{ condition = conditions.in_text }
	),
	-- equation 有編號
	s(
		{ trig = "equation", dsrc = "equation" },
		fmta(
			[[
                \begin{equation}
                    <>
                \end{equation}
            ]],
			{ i(1) }
		)
	),
	-- code(minted)
	s(
		{ trig = "minted", dsrc = "code block" },
		fmta(
			[[
                \begin{minted}{<>}
                <>
                \end{minted}
            ]],
			{ i(1), i(0) }
		)
	),
	-- table
	s(
		{
			trig = "table(%d+) (%d+)(%s)",
			dsrc = "table",
			snippetType = "autosnippet",
			regTrig = true,
			wordTrig = false,
		},
		fmta(
			[[
                \begin{table}
                \centering
                <>
                \end{table}
            ]],
			{
				d(1, tab),
			}
		)
	),
	-- figure
	s(
		{
			trig = "figure",
			dsrc = "figure",
		},
		fmta(
			[[
                \begin{figure}
                    \centering
                    \includegraphics[width=<>\linewidth]{<>}
                    \caption{<>}
                    \label{fig:<>}
                \end{figure}
            ]],
			{
				i(1, "0.8"),
				i(2),
				i(3),
				i(4),
			}
		)
	),
}

return M
