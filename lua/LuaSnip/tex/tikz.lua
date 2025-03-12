-- Abbreviations used in this article and the LuaSnip docs
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta

local conditions = require("LuaSnip.tex.utils.conditions")

M = {
	s({
		trig = "dd",
		dscr = "tikz draw",
		snippetType = "autosnippet",
		-- regTrig = true,
		-- wordTrig = false,
	}, fmta("\\draw[<>] (<>) ", { i(1), i(2) }), { condition = conditions.in_tikz }),
	s({
		trig = "++",
		dscr = "",
		snippetType = "autosnippet",
	}, fmta("++(<>, <>) ", { i(1), i(2) }), { condition = conditions.in_tikz }),
	-- circuitikz
	s(
		{
			trig = "([np])mos",
			dscr = "mos node",
			snippetType = "autosnippet",
			regTrig = true,
			wordTrig = false,
		},
		fmta("node[<>, <>](<>){<>} ", {
			f(function(_, snip)
				return snip.captures[1] .. "mos"
			end),
			i(1),
			i(2),
			i(3),
		}),
		{ condition = conditions.in_tikz }
	),
	s(
		{
			trig = "op",
			dscr = "OP amplifiger node",
			show_condition = function()
				return conditions.in_tikz()
			end,
		},
		fmta("node[op amp, <>](<>){<>} ", {
			i(1),
			i(2),
			i(3),
		})
	),
	s({
		trig = "ground",
		dscr = "ground node",
		show_condition = function()
			return conditions.in_tikz()
		end,
	}, t("node[ground]{} ")),
	s(
		{
			trig = "resistor",
			dscr = "resostor",
			show_condition = function()
				return conditions.in_tikz()
			end,
		},
		fmta("to[R, l_=$<>$]", {
			i(1),
		})
	),
	s(
		{
			trig = "capacitor",
			dscr = "capacitor",
			show_condition = function()
				return conditions.in_tikz()
			end,
		},
		fmta("to[C, l_=$<>$]", {
			i(1),
		})
	),
	s(
		{
			trig = "diode",
			dscr = "diode",
			show_condition = function()
				return conditions.in_tikz()
			end,
		},
		fmta("to[D, l_=$<>$] ", {
			i(1),
		})
	),
	s(
		{
			trig = "inductor",
			dscr = "inductor",
			show_condition = function()
				return conditions.in_tikz()
			end,
		},
		fmta("to[L, l_=$<>$] ", {
			i(1),
		})
	),
	-- Sources
	s(
		{
			trig = "I",
			dscr = "current source",
			show_condition = function()
				return conditions.in_tikz()
			end,
		},
		fmta("to[I, l_=$<>$] ", {
			i(1),
		})
	),
	s(
		{
			trig = "V",
			dscr = "voltage source",
			show_condition = function()
				return conditions.in_tikz()
			end,
		},
		fmta("to[V, l_=$<>$] ", {
			i(1),
		})
	),
	s(
		{
			trig = "sqV",
			dscr = "square voltage source",
			show_condition = function()
				return conditions.in_tikz()
			end,
		},
		fmta("to[sqV, l_=$<>$] ", {
			i(1),
		})
	),
}

return M
