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

-- greek alphabet
local greek_alphabet = {
	-- lowercase
	["alpha"] = { command = "\\alpha", symbol = "α" },
	["beta"] = { command = "\\beta", symbol = "β" },
	["gamma"] = { command = "\\gamma", symbol = "γ" },
	["delta"] = { command = "\\delta", symbol = "δ" },
	["epsilon"] = { command = "\\epsilon", symbol = "ε" },
	["zeta"] = { command = "\\zeta", symbol = "ζ" },
	["eta"] = { command = "\\eta", symbol = "η" },
	["theta"] = { command = "\\theta", symbol = "θ" },
	["iota"] = { command = "\\iota", symbol = "ι" },
	["kappa"] = { command = "\\kappa", symbol = "κ" },
	["lambda"] = { command = "\\lambda", symbol = "λ" },
	["mu"] = { command = "\\mu", symbol = "μ" },
	["nu"] = { command = "\\mu", symbol = "ν" },
	-- ["xi"] = { command = "\\xi", symbol = "ξ" },
	["omicron"] = { command = "\\omicron", symbol = "ο" },
	["pi"] = { command = "\\pi", symbol = "π" },
	["rho"] = { command = "\\rho", symbol = "ρ" },
	["sigma"] = { command = "\\sigma", symbol = "σ" },
	["tau"] = { command = "\\tau", symbol = "τ" },
	["upsilon"] = { command = "\\upsilon", symbol = "υ" },
	["phi"] = { command = "\\phi", symbol = "φ" },
	["chi"] = { command = "\\chi", symbol = "χ" },
	["psi"] = { command = "\\psi", symbol = "ψ" },
	["omega"] = { command = "\\omega", symbol = "ω" },
	-- uppercase
	["Alpha"] = { command = "\\Alpha", symbol = "Α" },
	["Beta"] = { command = "\\Beta", symbol = "Β" },
	["Gamma"] = { command = "\\Gamma", symbol = "Γ" },
	["Delta"] = { command = "\\Delta", symbol = "Δ" },
	["Epsilon"] = { command = "\\Epsilon", symbol = "Ε" },
	["Zeta"] = { command = "\\Zeta", symbol = "Ζ" },
	["Eta"] = { command = "\\Eta", symbol = "Η" },
	["Theta"] = { command = "\\Theta", symbol = "Θ" },
	["Iota"] = { command = "\\Iota", symbol = "Ι" },
	["Kappa"] = { command = "\\Kappa", symbol = "Κ" },
	["Lambda"] = { command = "\\Lambda", symbol = "Λ" },
	["Mu"] = { command = "\\Mu", symbol = "Μ" },
	["Nu"] = { command = "\\Mu", symbol = "N" },
	-- ["Xi"] = { command = "\\Xi", symbol = "Ξ" },
	["Omicron"] = { command = "\\Omicron", symbol = "Ο" },
	["Pi"] = { command = "\\Pi", symbol = "Π" },
	["Rho"] = { command = "\\Rho", symbol = "P" },
	["Sigma"] = { command = "\\Sigma", symbol = "Σ" },
	["Tau"] = { command = "\\Tau", symbol = "Τ" },
	["Upsilon"] = { command = "\\Upsilon", symbol = "Υ" },
	["Phi"] = { command = "\\Phi", symbol = "Φ" },
	["Chi"] = { command = "\\Chi", symbol = "X" },
	["Psi"] = { command = "\\Psi", symbol = "Ψ" },
	["Omega"] = { command = "\\Omega", symbol = "Ω" },
}

local greek_snippets = {}
for trig, data in pairs(greek_alphabet) do
	table.insert(
		greek_snippets,
		s(
			{ trig = trig, snippetType = "autosnippet", dscr = data.symbol },
			{ t(data.command .. " ") },
			{ condition = conditions.in_mathzone }
		)
	)
end

local other_symbols = {
	["gets"] = { command = "\\gets", symbol = "" },
	["to"] = { command = "\\to", symbol = "" },
}

local other_symbols_snippets = {}
for trig, data in pairs(other_symbols) do
	table.insert(
		other_symbols_snippets,
		s(
			{ trig = trig, snippetType = "autosnippet", dscr = data.symbol },
			{ t(data.command .. " ") },
			{ condition = conditions.in_mathzone }
		)
	)
end

M = {
	s(
		{ trig = "(%d+)degree", snippetType = "autosnippet", dscr = "degree", regTrig = true, wordTrig = false },
		fmta("<>\\textdegree <> ", {
			f(function(_, snip)
				return snip.captures[1]
			end),
			i(1, "C"),
		})
	),
}

vim.list_extend(M, greek_snippets)
vim.list_extend(M, other_symbols_snippets)
return M
