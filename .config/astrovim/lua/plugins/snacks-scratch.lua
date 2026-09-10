---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    opts = { scratch = {} },
    keys = {
      {
        "<Leader>?",
        function()
          Snacks.scratch {
            name = "Keybind Notes",
            ft = "markdown",
            template = [[# Neovim + AstroNvim development keybindings

Most mappings below start in Normal mode. `<Space>` is AstroNvim's leader key. Press `<Space>` and pause to browse the which-key menu. Capitalization matters.

## Essential mode changes

- `<Esc>` — Return to Normal mode
- `i` / `a` — Insert before / after the cursor
- `I` / `A` — Insert at the first non-blank / end of the line
- `o` / `O` — Open a new line below / above
- `v` / `V` / `<C-v>` — Select characters / lines / a block
- `:` — Enter a command

## Move around code

- `h` `j` `k` `l` — Left, down, up, right
- `w` / `b` / `e` — Next word / previous word / end of word
- `0` / `^` / `$` — Start / first non-blank / end of line
- `gg` / `G` — First / last line in the file
- `{` / `}` — Previous / next paragraph or code block
- `<C-d>` / `<C-u>` — Half-page down / up
- `%` — Jump between matching brackets
- `f{char}` / `F{char}` — Find a character forward / backward on the line
- `t{char}` / `T{char}` — Move just before a character forward / backward
- `;` / `,` — Repeat the last `f`, `F`, `t`, or `T` forward / backward
- `<C-o>` / `<C-i>` — Move backward / forward through jump history

## Marks

- `ma` — Set local mark `a`
- `mA` — Set global mark `A`
- `` `a `` — Jump to the exact position of mark `a`
- `'a` — Jump to the line containing mark `a`
- `:marks` — List marks
- `:delmarks a` — Delete mark `a`
- `<Space>f'` — Search marks with Snacks Picker
- `'.` — Jump to the last change
- `''` — Jump to the previous position
- `'<` / `'>` — Start/end of the last Visual selection

## Edit text

- `u` / `<C-r>` — Undo / redo
- `.` — Repeat the last edit
- `x` — Delete the character under the cursor
- `dd` / `D` — Delete the line / to the end of the line
- `yy` / `Y` — Copy the line / to the end of the line
- `p` / `P` — Paste after / before the cursor
- `cc` / `C` — Replace the line / to the end of the line
- `ciw` / `diw` / `yiw` — Change / delete / copy the current word
- `ci"` / `di"` / `yi"` — Change / delete / copy inside quotes
- `ci(` / `di(` / `yi(` — Change / delete / copy inside parentheses
- `d{motion}` / `c{motion}` / `y{motion}` — Delete / change / copy over any motion
- `>` / `<` in Visual mode — Indent / unindent selection
- `=` in Visual mode — Reindent selection
- `ys{motion}{char}` — Add surrounding quotes, brackets, or tags
- `ds{char}` — Delete surrounding delimiters
- `cs{target}{replacement}` — Change surrounding delimiters
- `<Space>fy` — Browse yank history
- `[y` / `]y` — Cycle forward / backward through yank history
- `gcc` — Toggle comment on the current line
- `gc` in Visual mode — Toggle comments on the selection
- `<C-s>` or `<Space>w` — Save

Useful pattern: operators compose with motions and text objects. Examples: `dw` deletes to the next word, `d$` deletes to line end, `ciw` replaces a word, and `ci"` replaces text inside quotes. Prefix with a count, such as `3dd`.

## Search and replace

- `/text` then `<Enter>` — Search forward
- `?text` then `<Enter>` — Search backward
- `n` / `N` — Next / previous search match
- `*` / `#` — Search forward / backward for the word under the cursor
- `:%s/old/new/gc` — Replace throughout the file, asking before each change
- `<Space>fw` — Search text across the project
- `<Space>fW` — Search project text, including hidden files
- `<Space>fc` — Search for the word under the cursor
- `<Space>fl` — Search lines in the current buffer
- `<Space>ss` — Search/replace across the workspace with Grug Far
- `<Space>se` — Search/replace files of the current filetype
- `<Space>sf` — Search/replace in the current file
- `<Space>sw` — Replace the word under the cursor
- Visual `<Space>s` — Search/replace the selected text

## Files, buffers, and windows

- `<Space>ff` / `<Space>fF` — Find files / find files including hidden files
- `<Space>fo` — Open a recent file
- `<Space>fb` — Search open buffers
- `<Space>e` — Toggle the file explorer
- `<Space>o` — Focus the file explorer; press again to return
- `]b` / `[b` — Next / previous buffer
- `<Space>bb` — Pick an open buffer
- `<Space>c` — Close the current buffer
- `\` / `|` — Open a horizontal / vertical split
- `<C-h>` `<C-j>` `<C-k>` `<C-l>` — Focus the left / lower / upper / right window
- `<C-Up>` `<C-Down>` `<C-Left>` `<C-Right>` — Resize the current window

## Yazi file manager

- `<Space>-` — Open Yazi at the current file
- `<Space>Yc` — Open Yazi in Neovim's working directory
- `<Space>Yt` — Resume the last Yazi session
- `<F1>` in Yazi — Show Yazi help

## Navigate and understand code (LSP)

These mappings appear when a language server supports the operation.

- `gd` — Go to definition
- `gD` — Go to declaration
- `grr` or `<Space>lR` — Find references
- `gri` — Go to implementation
- `gy` — Go to type definition
- `K` — Show documentation for the symbol under the cursor
- `<Space>ls` — Search symbols in the current file
- `<Space>lG` — Search symbols across the workspace
- `<Space>lS` — Toggle the symbols outline
- `<Space>uT` — Toggle sticky Treesitter code context
- `<C-o>` — Return after jumping to a definition or reference

## Diagnostics and code changes (LSP)

- `gl` or `<Space>ld` — Show diagnostics for the current line
- `]d` / `[d` — Next / previous diagnostic
- `]e` / `[e` — Next / previous error
- `]w` / `[w` — Next / previous warning
- `<Space>lD` — Search all diagnostics
- `<Space>lw` — Search workspace diagnostics
- `<Space>la` — Show available code actions
- `<Space>lr` — Rename the symbol under the cursor
- `<Space>lf` — Format the current file
- `<Space>lh` — Show function signature help
- `<Space>uh` / `<Space>uH` — Toggle inlay hints for the buffer / globally
- `<Space>xx` / `<Space>xX` — Trouble diagnostics for the buffer / workspace
- `<Space>xQ` / `<Space>xL` — Trouble quickfix / location list
- `<Space>xt` / `<Space>xT` — Trouble todos / TODO-FIX-FIXME items

## Git

- `]g` / `[g` — Next / previous changed hunk
- `<Space>gp` — Preview the current hunk
- `<Space>gl` — Show blame for the current line
- `<Space>gs` — Stage or unstage the current hunk
- `<Space>gr` — Reset the current hunk; destructive
- `<Space>gd` — View the current file's diff
- `<Space>gt` — Open Git status picker
- `<Space>gc` — Search repository commits
- `<Space>tl` — Open Lazygit when installed

## Herdr workspace and Gitview

Herdr's global prefix is `<C-Space>`. Press it, release it, then press the
next key.

- `<C-Space>` then `e` — Toggle or focus the jtnovellis Neovim sidebar
- `<C-Space>` then `f` — Pick a file touched by the agent
- `<C-Space>` then `<S-v>` — Toggle Gitview in the current tab
- `<C-Space>` then `g` — Open or focus the dedicated Gitview tab

## Gitview

These keys work inside the Gitview pane.

- `j` / `k` or arrows — Move through changed files; the diff follows the selection
- `Enter` — Open the selected file in real Neovim at its first changed line
- `s` / `u` — Stage / unstage the selected file or directory
- `x` — Discard the selected change; confirm before it is removed
- `c` — Commit; write the message in Neovim, then `:wq` to commit or `:q!` to cancel
- `w` — Toggle worktree changes and changes against the branch base
- `Tab` — Toggle the unstaged and staged diff for the selected file
- `l` — Browse commit history; `w` filters to commits added by this branch
- `r` — Refresh the view
- `?` — Open Gitview help
- `q` / `<Esc>` — Close Gitview
- `v`, then `j` / `k` — Select diff lines for an agent review note
- `a` — Annotate the selected diff lines; type the note and press `<Enter>`
- `p` — Pick an agent and paste the notes into its input
- `n` — Open the notes view; `d` deletes the selected note

## jtnovellis/herdr-nvim

`<Space>` is the Neovim leader key. These mappings work in normal Neovim
and in the Herdr Neovim sidebar.

- `<Space>ac` — Ask the agent about the current line; Visual mode asks about the selection
- `<Space>ar` — Follow up with the last agent, without attaching code
- `<Space>aa` — Queue a comment on the current line or Visual selection
- `<Space>al` — List annotations
- `<Space>as` / `<Space>aS` — Paste annotations into the agent / send them
- `<Space>af` — Pick a file the agent touched this session
- `]n` / `[n` — Next / previous annotation
- `]r` / `[r` — Next / previous edit made by the agent
- `<Space>au` — Revert the agent edit under the cursor
- `<Space>ak` — Keep the agent edit under the cursor
- `<Space>at` — Choose which agent receives `HerdrAsk`
- `<Space>ag` — List agents visible from the current workspace
- `:HerdrPreview` — Preview the exact prompt without sending it
- `:HerdrReplyView` — Focus the agent's reply window
- `:HerdrClear` — Clear all annotations

## Completion while typing

- `<C-Space>` — Open completion suggestions
- `<C-n>` / `<C-p>` — Select the next / previous suggestion
- `<Enter>` — Accept the selected suggestion
- `<C-e>` — Close completion suggestions
- `<Tab>` / `<S-Tab>` — Next / previous snippet location

## Terminal

- `<Space>tf` — Toggle a floating terminal
- `<Space>th` / `<Space>tv` — Toggle a horizontal / vertical terminal
- `<F7>` — Toggle the terminal
- `<C-\><C-n>` — Return from Terminal mode to Normal mode

## Discover commands and keybindings

- `<Space>` then pause — Browse available mapping groups with which-key
- `<Space>fk` — Search every active keybinding
- `<Space>fC` — Search available commands
- `<Space>fh` — Search Neovim help topics
- `:help {topic}` — Open help for a topic, such as `:help text-objects`
- `<C-]>` / `<C-t>` in help — Follow a help link / go back

## Personal additions

Add frequently used bindings here. Remove them once they become automatic.
]],
            filekey = {
              id = "keybind-notes",
              cwd = false,
              branch = false,
              count = false,
            },
          }
        end,
        desc = "Keybind Notes",
      },
    },
  },
}
