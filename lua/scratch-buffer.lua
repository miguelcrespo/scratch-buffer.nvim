local default_header = {"                                                 ", "                               __                ", "  ___     ___    ___   __  __ /\\_\\    ___ ___    ", " / _ `\\  / __`\\ / __`\\/\\ \\/\\ \\\\/\\ \\  / __` __`\\  ", "/\\ \\/\\ \\/\\  __//\\ \\_\\ \\ \\ \\_/ |\\ \\ \\/\\ \\/\\ \\/\\ \\ ", "\\ \\_\\ \\_\\ \\____\\ \\____/\\ \\___/  \\ \\_\\ \\_\\ \\_\\ \\_\\", " \\/_/\\/_/\\/____/\\/___/  \\/__/    \\/_/\\/_/\\/_/\\/_/"}
local maps = {fennel = {extension = "fnl", comment = ";"}, lua = {extension = "lua", comment = "--"}, python = {extension = "py", comment = "#"}}
local function get_heading(options)
  local heading = {}
  local version = vim.version()
  local comment_symbol = maps[options.filetype].comment
  local neovim_version = (version.major .. "." .. version.minor .. "." .. version.patch)
  for _, v in ipairs(options.heading) do
    table.insert(heading, (comment_symbol .. v))
  end
  table.insert(heading, comment_symbol)
  if (options.with_neovim_version == true) then
    table.insert(heading, (comment_symbol .. " Version: " .. neovim_version))
    table.insert(heading, comment_symbol)
  else
  end
  table.insert(heading, "")
  return heading
end
local function get_buffer_name(options)
  if options.with_lsp then
    local buffer_path = (vim.fn.stdpath("data") .. "/scratch-buffer/" .. options.buffname .. "." .. maps[options.filetype].extension)
    return buffer_path
  else
    return options.buffname
  end
end
local function create_buffer(options)
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(buf, get_buffer_name(options))
  vim.api.nvim_buf_set_option(buf, "filetype", options.filetype)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, get_heading(options))
  return buf
end
local function set_scratch_buffer(options)
  local buf = create_buffer(options)
  local line_number = vim.api.nvim_buf_line_count(buf)
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_win_set_cursor(0, {line_number, 0})
  if (options.with_lsp == true) then
    return vim.api.nvim_exec(":LspStart", nil)
  else
    return nil
  end
end
local function setup_autocmd(options)
  local augroup = vim.api.nvim_create_augroup("ScratchBuffer", {clear = true})
  local function _4_()
    return set_scratch_buffer(options)
  end
  return vim.api.nvim_create_autocmd("VimEnter", {group = augroup, desc = "Set a fennel scratch buffer on load", once = true, callback = _4_})
end
local function setup(user_options)
  if (#vim.v.argv > 2) then
    return
  else
  end
  local default_options = {filetype = "lua", buffname = "*scratch*", with_lsp = true, with_neovim_version = true, heading = default_header}
  local options = vim.tbl_extend("force", default_options, (user_options or {}))
  if (maps[options.filetype] == nil) then
    error(("Filetype " .. options.filetype .. " is not supported"))
  else
  end
  return setup_autocmd(options)
end
return {setup = setup}
