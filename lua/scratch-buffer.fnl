; Taken from https://github.com/MaximilianLloyd/ascii.nvim/blob/master/lua/ascii/text/neovim.lua
(local default_header
       ["                                                 "
        "                               __                "
        "  ___     ___    ___   __  __ /\\_\\    ___ ___    "
        " / _ `\\  / __`\\ / __`\\/\\ \\/\\ \\\\/\\ \\  / __` __`\\  "
        "/\\ \\/\\ \\/\\  __//\\ \\_\\ \\ \\ \\_/ |\\ \\ \\/\\ \\/\\ \\/\\ \\ "
        "\\ \\_\\ \\_\\ \\____\\ \\____/\\ \\___/  \\ \\_\\ \\_\\ \\_\\ \\_\\"
        " \\/_/\\/_/\\/____/\\/___/  \\/__/    \\/_/\\/_/\\/_/\\/_/"])

(local maps {:fennel {:extension :fnl :comment ";"}
             :lua {:extension :lua :comment "--"}
             :python {:extension :py :comment "#"}})

(fn get-heading [options]
  (let [heading []
        version (vim.version)
        comment_symbol (. (. maps options.filetype) :comment)
        neovim_version (.. version.major "." version.minor "." version.patch)]
    (each [_ v (ipairs (. options :heading))]
      (table.insert heading (.. comment_symbol v)))
    (table.insert heading comment_symbol)
    (when (= options.with_neovim_version true)
      (table.insert heading (.. comment_symbol " Version: " neovim_version))
      (table.insert heading comment_symbol))
    (table.insert heading "")
    heading))

(fn get-buffer-name [options] ; It looks like we need to have a "real file" in order to start a lsp
  (if options.with_lsp (let [buffer-path (.. (vim.fn.stdpath :data)
                                             :/scratch-buffer/ options.buffname
                                             "."
                                             (. (. maps options.filetype)
                                                :extension))]
                         buffer-path) options.buffname))

(fn create-buffer [options]
  (let [buf (vim.api.nvim_create_buf true true)]
    (vim.api.nvim_buf_set_name buf (get-buffer-name options))
    (vim.api.nvim_buf_set_option buf :filetype options.filetype)
    (vim.api.nvim_buf_set_lines buf 0 -1 true (get-heading options))
    buf))

(fn set-scratch-buffer [options]
  (let [buf (create-buffer options)
        line_number (vim.api.nvim_buf_line_count buf)]
    (vim.api.nvim_win_set_buf 0 buf)
    (vim.api.nvim_win_set_cursor 0 [line_number 0]) ; Running :LspStart doesn't seem to trigger any error if there's no LSP configure
    (when (= options.with_lsp true)
      (vim.api.nvim_exec ":LspStart" nil))))

(fn setup-autocmd [options]
  (local augroup (vim.api.nvim_create_augroup :ScratchBuffer {:clear true}))
  (vim.api.nvim_create_autocmd :VimEnter
                               {:group augroup
                                :desc "Set a fennel scratch buffer on load"
                                :once true
                                :callback (fn [] (set-scratch-buffer options))}))

(fn setup [user_options]
  (let [default_options {:filetype :lua
                         :buffname :*scratch*
                         :with_lsp true
                         :with_neovim_version true
                         :heading default_header}
        options (vim.tbl_extend :force default_options (or user_options {}))]
    (if (= (. maps options.filetype) nil)
        (error (.. "Filetype " options.filetype " is not supported")))
    (setup-autocmd options)))

{: setup}
