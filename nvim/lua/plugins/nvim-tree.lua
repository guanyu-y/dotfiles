-- ~/.config/nvim/lua/plugins/nvim-tree.lua
-- File tree with Telescope integration and Git actions
--
-- Required tools:
-- - ripgrep (rg): for live_grep
-- - fd-find (fdfind): for find_files
-- Ubuntu: sudo apt install ripgrep fd-find

return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeOpen" },
    config = function()
      -- Disable netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      local api = require("nvim-tree.api")
      local tree, fs, node = api.tree, api.fs, api.node

      -- Command menu for Telescope
      local menuCommand = {}

      local function actionsMenu(nd)
        local default_options = {
          results_title = "NvimTree",
          finder = require("telescope.finders").new_table({
            results = menuCommand,
            entry_maker = function(menu_item)
              return {
                value = menu_item,
                ordinal = menu_item.name,
                display = menu_item.name,
              }
            end,
          }),
          sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
          attach_mappings = function(prompt_buffer_number)
            local actions = require("telescope.actions")
            actions.select_default:replace(function()
              actions.close(prompt_buffer_number)
              require("telescope.actions.state").get_selected_entry().value.handler(nd)
            end)
            return true
          end,
        }

        require("telescope.pickers")
          .new({ prompt_title = "Command", layout_config = { width = 0.3, height = 0.5 } }, default_options)
          :find()
      end

      -- Command definitions
      local command = {
        { "", tree.change_root_to_node, "CD" },
        { "", node.open.replace_tree_buffer, "Open: In Place" },
        { "", node.show_info_popup, "Info" },
        { "", fs.rename_sub, "Rename: Omit Filename" },
        { "", node.open.tab, "Open: New Tab" },
        { "", node.open.vertical, "Open: Vertical Split" },
        { "", node.open.horizontal, "Open: Horizontal Split" },
        { "<BS>", node.navigate.parent_close, "Close Directory" },
        { "<CR>", node.open.edit, "Open" },
        { "<Tab>", node.open.preview, "Open Preview" },
        { ">", node.navigate.sibling.next, "Next Sibling" },
        { "<", node.navigate.sibling.prev, "Previous Sibling" },
        { ".", node.run.cmd, "Run Command" },
        { "-", tree.change_root_to_parent, "Up" },
        { "a", fs.create, "Create" },
        { "", api.marks.bulk.move, "Move Bookmarked" },
        { "B", tree.toggle_no_buffer_filter, "Toggle No Buffer" },
        { "c", fs.copy.node, "Copy" },
        { "C", tree.toggle_git_clean_filter, "Toggle Git Clean" },
        { "[c", node.navigate.git.prev, "Prev Git" },
        { "]c", node.navigate.git.next, "Next Git" },
        { "d", fs.remove, "Delete" },
        { "", fs.trash, "Trash" },
        { "E", tree.expand_all, "Expand All" },
        { "", fs.rename_basename, "Rename: Basename" },
        { "]e", node.navigate.diagnostics.next, "Next Diagnostic" },
        { "[e", node.navigate.diagnostics.prev, "Prev Diagnostic" },
        { "F", api.live_filter.clear, "Clean Filter" },
        { "f", api.live_filter.start, "Filter" },
        { "g?", tree.toggle_help, "Help" },
        { "gy", fs.copy.absolute_path, "Copy Absolute Path" },
        { "H", tree.toggle_hidden_filter, "Toggle Dotfiles" },
        { "I", tree.toggle_gitignore_filter, "Toggle Git Ignore" },
        { "J", node.navigate.sibling.last, "Last Sibling" },
        { "K", node.navigate.sibling.first, "First Sibling" },
        { "m", api.marks.toggle, "Toggle Bookmark" },
        { "o", node.open.edit, "Open" },
        { "O", node.open.no_window_picker, "Open: No Window Picker" },
        { "p", fs.paste, "Paste" },
        { "P", node.navigate.parent, "Parent Directory" },
        { "q", tree.close, "Close" },
        { "r", fs.rename, "Rename" },
        { "R", tree.reload, "Refresh" },
        { "s", node.run.system, "Run System" },
        { "S", tree.search_node, "Search" },
        { "U", tree.toggle_custom_filter, "Toggle Hidden" },
        { "W", tree.collapse_all, "Collapse" },
        { "x", fs.cut, "Cut" },
        { "y", fs.copy.filename, "Copy Name" },
        { "Y", fs.copy.relative_path, "Copy Relative Path" },
        { "<Space>", actionsMenu, "Command" },
        -- Git operations
        {
          "ga",
          function()
            local nd = api.tree.get_node_under_cursor()
            if nd and nd.absolute_path then
              vim.fn.system("git add " .. vim.fn.shellescape(nd.absolute_path))
              print("git add: " .. nd.name)
              api.tree.reload()
            else
              print("Error: No file selected")
            end
          end,
          "Git Add",
        },
        {
          "gu",
          function()
            local nd = api.tree.get_node_under_cursor()
            if nd and nd.absolute_path then
              vim.fn.system("git restore --staged " .. vim.fn.shellescape(nd.absolute_path))
              print("git unstage: " .. nd.name)
              api.tree.reload()
            else
              print("Error: No file selected")
            end
          end,
          "Git Unstage",
        },
      }

      -- Build menu command list
      for _, cmd in pairs(command) do
        table.insert(menuCommand, { name = cmd[3], handler = cmd[2] })
      end

      -- on_attach function for key mappings
      local function on_attach(bufnr)
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, nowait = true }
        end

        -- Apply command key mappings
        for _, cmd in pairs(command) do
          if string.len(cmd[1]) > 0 then
            vim.keymap.set("n", cmd[1], cmd[2], opts(cmd[3]))
          end
        end

        -- Telescope: Find files
        vim.keymap.set("n", "<C-f>", function()
          require("telescope.builtin").find_files()
        end, opts("Telescope: Find Files"))

        -- Telescope: Live grep
        vim.keymap.set("n", "<C-g>", function()
          require("telescope.builtin").live_grep()
        end, opts("Telescope: Live Grep"))

        -- Telescope: Jump to directory
        vim.keymap.set("n", "<C-d>", function()
          require("telescope.builtin").find_files({
            prompt_title = "Jump to Directory",
            find_command = { "fdfind", "--type", "d", "." },
            attach_mappings = function(_, map)
              local actions = require("telescope.actions")
              local action_state = require("telescope.actions.state")
              local select_dir = function(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if selection and selection[1] then
                  local abs_path = vim.fn.fnamemodify(selection[1], ":p")
                  api.tree.change_root(abs_path)
                end
              end
              map("i", "<CR>", select_dir)
              map("n", "<CR>", select_dir)
              return true
            end,
          })
        end, { desc = "Fuzzy: Jump to Directory", buffer = bufnr, nowait = true })
      end

      -- Setup nvim-tree
      require("nvim-tree").setup({
        view = {
          width = "20%",
          signcolumn = "no",
        },
        renderer = {
          highlight_git = true,
          highlight_opened_files = "name",
          icons = {
            glyphs = {
              git = {
                unstaged = "!",
                renamed = ">>",
                untracked = "?",
                deleted = "x",
                staged = "+",
                unmerged = "",
                ignored = "o",
              },
            },
          },
        },
        actions = {
          expand_all = {
            max_folder_discovery = 100,
            exclude = { ".git", "target", "build" },
          },
        },
        on_attach = on_attach,
      })

      -- :Ex command alias
      vim.api.nvim_create_user_command("Ex", function()
        vim.cmd.NvimTreeToggle()
      end, {})
    end,
  },
}
