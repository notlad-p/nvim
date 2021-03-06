local M = {}

local function diagnostics_indicator(num, _, diagnostics, _)
	local result = {}
	local symbols = { error = "", warning = "", info = "" }
	for name, count in pairs(diagnostics) do
		if symbols[name] and count > 0 then
			table.insert(result, symbols[name] .. " " .. count)
		end
	end
	result = table.concat(result, " ")
	return #result > 0 and result or ""
end

M.config = function()
	vim.opt.termguicolors = true
	require("bufferline").setup({
		options = {
			mode = "buffers", -- can also be set to "tabs" to see tabpages
			themable = false, -- whether or not the highlights for this plugin can be overriden.
			numbers = "none", -- "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
			--- @deprecated, please specify numbers as a function to customize the styling
			-- number_style = "superscript" | "" | { "none", "subscript" }, -- buffer_id at index 1, ordinal at index 2
			-- mappings = true | false,
			close_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
			right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
			left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
			middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
			buffer_close_icon = "",
			modified_icon = "●",
			close_icon = "",
			left_trunc_marker = "",
			right_trunc_marker = "",
			--- name_formatter can be used to change the buffer's label in the bufferline.
			--- Please note some names can/will break the
			--- bufferline so use this at your discretion knowing that it has
			--- some limitations that will NOT be fixed.
			name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
				-- remove extension from markdown files for example
				if buf.name:match("%.md") then
					return vim.fn.fnamemodify(buf.name, ":t:r")
				end
			end,
			max_name_length = 18,
			max_prefix_length = 15, -- prefix used when a buffer is deduplicated
			tab_size = 18,
			diagnostics = "nvim_lsp", -- false | "nvim_lsp" | "coc"
			diagnostics_indicator = diagnostics_indicator,
			-- groups = {} -- see :h bufferline-groups for details
			show_buffer_icons = true,
			show_buffer_close_icons = true,
			show_buffer_default_icon = false, -- whether or not an unrecognised filetype should show a default icon
			show_close_icon = true,
			show_tab_indicators = true,
			persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
			-- can also be a table containing 2 custom separators
			-- [focused and unfocused]. eg: { "|", "|" }
			separator_style = "thin", -- "slant" | "padded_slant" | "thick" | "thin" | { "any", "any" },
			enforce_regular_tabs = false,
			always_show_bufferline = false,
			offsets = { { filetype = "NvimTree", text = "Explorer", text_align = "center", padding = 1 } },
			sort_by = "id",
			-- "id" | "extension" | "relative_directory" | "directory" | "tabs" | function(buffer_a, buffer_b)
			-- add custom logic
			-- return buffer_a.modified > buffer_b.modified
			-- end
		},
	})
end

return M
