local function toggle_checkbox()
  local line = vim.api.nvim_get_current_line()
  local patterns = {
    "^(%s*[-*+]%s+%[)([ xX])(%])",
    "^(%s*%d+[.)]%s+%[)([ xX])(%])",
  }

  for _, pattern in ipairs(patterns) do
    local new_line, changed = line:gsub(pattern, function(prefix, state, suffix)
      return prefix .. (state == " " and "x" or " ") .. suffix
    end, 1)

    if changed > 0 then
      vim.api.nvim_set_current_line(new_line)
      return
    end
  end
end

vim.keymap.set("n", "<leader>tc", toggle_checkbox, {
  buffer = true,
  desc = "Toggle Markdown checkbox",
})
