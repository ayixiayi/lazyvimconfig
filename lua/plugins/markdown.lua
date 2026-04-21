return {
  -- ============================================================
  -- 1. Enhanced render-markdown.nvim (overrides LazyVim defaults)
  -- ============================================================
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      -- Render in insert mode too for WYSIWYG-like experience
      render_modes = { "n", "c", "t", "i" },
      heading = {
        sign = false,
        icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
        width = "full",
      },
      checkbox = {
        enabled = true,
        unchecked = { icon = "☐ " },
        checked = { icon = "☑ " },
        custom = {
          todo = { raw = "[-]", rendered = "◧ ", highlight = "RenderMarkdownTodo" },
        },
      },
      bullet = {
        icons = { "●", "○", "◆", "◇" },
      },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
        language_pad = 1,
      },
      pipe_table = {
        enabled = true,
        style = "full",
      },
      link = {
        enabled = true,
        hyperlink = "🔗 ",
        image = "🖼 ",
      },
      latex = {
        enabled = true,
        render_modes = { "n", "c", "t", "i" },
        converter = "latex2text",
        position = "center",
        top_pad = 0,
        bottom_pad = 0,
      },
    },
  },

  -- ============================================================
  -- 2. Enhanced markdown-preview.nvim (overrides LazyVim defaults)
  -- ============================================================
  {
    "iamcco/markdown-preview.nvim",
    init = function()
      vim.g.mkdp_theme = "dark"
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_browser = ""
    end,
  },

  -- ============================================================
  -- 3. markdown.nvim - Writing helpers (bold, italic, links, nav)
  -- ============================================================
  {
    "tadmccorkle/markdown.nvim",
    ft = { "markdown" },
    opts = {
      mappings = {
        inline_surround_toggle = "gs",
        inline_surround_toggle_line = "gss",
        inline_surround_delete = "ds",
        inline_surround_change = "cs",
        link_add = "gl",
        link_follow = "gx",
        go_curr_heading = "]c",
        go_parent_heading = "]p",
        go_next_heading = "]]",
        go_prev_heading = "[[",
      },
      inline_surround = {
        emphasis = {
          key = "i",
          txt = "*",
        },
        strong = {
          key = "b",
          txt = "**",
        },
        strikethrough = {
          key = "s",
          txt = "~~",
        },
        code = {
          key = "c",
          txt = "`",
        },
      },
      on_attach = function(bufnr)
        local map = vim.keymap.set
        local opts = { buffer = bufnr }
        -- TOC generation
        map("n", "<leader>mt", "<cmd>MDToc<cr>", vim.tbl_extend("force", opts, { desc = "Insert TOC" }))
        -- Toggle task list item
        map("n", "<leader>mx", "<cmd>MDTaskToggle<cr>", vim.tbl_extend("force", opts, { desc = "Toggle checkbox" }))
        map("x", "<leader>mx", "<cmd>MDTaskToggle<cr>", vim.tbl_extend("force", opts, { desc = "Toggle checkbox" }))
      end,
    },
  },

  -- ============================================================
  -- 4. zen-mode.nvim - Distraction-free writing
  -- ============================================================
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
    },
    opts = {
      window = {
        width = 90,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorline = false,
          foldcolumn = "0",
        },
      },
      plugins = {
        twilight = { enabled = true },
        gitsigns = { enabled = false },
      },
    },
    dependencies = {
      -- Twilight dims inactive code - pairs with zen-mode
      {
        "folke/twilight.nvim",
        opts = {
          dimming = { alpha = 0.3 },
          context = 15,
        },
      },
    },
  },

  -- ============================================================
  -- 5. outline.nvim - Typora-like TOC sidebar with collapsible headings
  -- ============================================================
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>mo", "<cmd>Outline<cr>", desc = "Toggle TOC Outline" },
    },
    opts = {
      outline_window = {
        position = "left",
        width = 30,
        relative_width = false,
        focus_on_open = false,
        auto_jump = false,
      },
      outline_items = {
        show_symbol_lineno = true,
        auto_set_cursor = true,
      },
      guides = {
        enabled = true,
        markers = {
          bottom = "└",
          middle = "├",
          vertical = "│",
        },
      },
      symbol_folding = {
        autofold_depth = false,
        auto_unfold = {
          hovered = true,
          only = true,
        },
        markers = { "", "" },
      },
      keymaps = {
        close = { "<Esc>", "q" },
        goto_location = "<CR>",
        peek_location = "o",
        fold = "h",
        unfold = "l",
        fold_toggle = "<Tab>",
        fold_toggle_all = "<S-Tab>",
        fold_all = "zM",
        unfold_all = "zR",
      },
      providers = {
        priority = { "markdown", "lsp" },
      },
    },
  },

  -- ============================================================
  -- 6. Disable markdownlint (too noisy for note-taking)
  -- ============================================================
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },

  -- ============================================================
  -- 7. Markdown FileType autocmds
  -- ============================================================
  {
    "LazyVim/LazyVim",
    opts = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "markdown.mdx" },
        callback = function()
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
          vim.opt_local.breakindent = true
          vim.opt_local.conceallevel = 2
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "en_us,cjk"
          vim.opt_local.textwidth = 0
          vim.opt_local.colorcolumn = ""
        end,
      })
    end,
  },
}
