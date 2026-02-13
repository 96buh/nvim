local M = {}

local ls = require("luasnip")
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node

-- 在VISUAL MODE按下<tab>輸入可以觸發其他的snippet
M.get_visual = function(_, parent)
	local selection = parent.snippet.env.LS_SELECT_RAW or ""

	if #selection > 0 then
		return sn(nil, i(1, selection))
	else
		return sn(nil, i(1, ""))
	end
end

-- 生成矩陣或是表格中間的分隔部分
local function generate_matrix_content(rows, cols, index)
	local nodes = {}
	index = index or 1

	for j = 1, rows do
		for k = 1, cols do
			if k > 1 then
				table.insert(nodes, t(" & "))
			end
			table.insert(nodes, i(index))
			index = index + 1
		end
		if j < rows then
			table.insert(nodes, t({ " \\\\", "" }))
		else
			table.insert(nodes, t(" \\\\"))
		end
	end

	return nodes
end

M.generate_matrix = function(_, snip)
	local rows = tonumber(snip.captures[2]) or 2
	local cols = tonumber(snip.captures[3]) or 2

	return sn(nil, generate_matrix_content(rows, cols))
end

M.generate_table = function(_, snip)
	local rows = tonumber(snip.captures[1]) or 2
	local cols = tonumber(snip.captures[2]) or 2
	local nodes = {}

	-- 表格開頭, 對其中間
	local col_align = string.rep("c", cols)
	table.insert(nodes, t("\\caption{"))
	table.insert(nodes, i(1))
	table.insert(nodes, t({ "}", "" }))
	table.insert(nodes, t("\\label{tab:"))
	table.insert(nodes, i(2))
	table.insert(nodes, t({ "}", "" }))
	table.insert(nodes, t({ "\\begin{tabular}{" .. col_align .. "}", "\\toprule", "" }))

	-- 內部(插入由3開始是因為1, 2是caption和label)
	for _, node in ipairs(generate_matrix_content(rows, cols, 3)) do
		table.insert(nodes, node)
	end

	-- 表格結尾
	table.insert(nodes, t({ "", "\\bottomrule", "\\end{tabular}" }))

	return sn(nil, nodes)
end

return M
