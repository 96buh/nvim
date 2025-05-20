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
	s( -- chains(畫流程圖或連續節點)
		{
			trig = "chain",
			dscr = "simple chain of nodes",
			show_condition = function()
				return conditions.no_math_no_tikz()
			end,
		},
		fmta(
			[[
                \begin{tikzpicture}[
                        node distance=5mm, % 節點距離 
                        every node/.style={draw}, % 畫邊框, rounded corners增加圓角邊框
                        every join/.style={}  % myarrow2為箭頭，設定節點自動連線樣式(要加入join)
                    ]
                    {   [start chain=1]
                        \node [on chain] {A};
                        \node [on chain] {B};
                        \node [on chain] {C};
                    }
                    <>
                    {   [start chain=2 going below]
                        \node [on chain] at (0.5,-.5) {0};
                        \node [on chain] {1};
                        \node [on chain] {2};
                    }
                    % 可以在已經完成的chain重新接續下去
                    { [continue chain=1]
                    \node [on chain] {D};
                    }
                \end{tikzpicture}
            ]],
			{ i(1) }
		)
	),
	s(
		{
			trig = "pgf2d",
			dscr = "2d graph template",
			show_condition = function()
				return conditions.in_tikz()
			end,
		},
		fmta(
			[[
                \begin{axis}[
                    axis lines=middle, % left
                    xlabel={$x$}, ylabel={$f(x)$}, % 標示 x 軸和 y 軸
                    xmin=-pi, xmax=pi, ymin=-1.5, ymax=1.5, 
                    xtick={-pi, -pi/2, 0, pi/2, pi},
                    xticklabels={$-\pi$, $-\frac{\pi}{2}$, $0$, $\frac{\pi}{2}$, $\pi$},
                    % xticklabel style={anchor=south west},
                    domain=-pi:pi, % x 軸範圍
                    % title={},
                    samples=100, 
                    % legend pos=north east, % 圖例位置
                    % grid=major, % 加入格線
                ]
                    \addplot[red, thick] {sin(deg(x))};
                    <>   
                \end{axis}
            ]],
			{ i(1) }
		)
	),
}

return M
