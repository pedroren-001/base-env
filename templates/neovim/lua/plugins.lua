-- Bootstrap lazy.nvim
vim.opt.runtimepath:append("~/.config/nvim/pack/gongfeng/start/vim")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Load lazy.nvim. the function of this function is to load and manage plugins
local function setup_copilot_mapping()
	vim.keymap.set("i", "<C-l>", 'copilot#Accept("\\<CR>")', {
		expr = true,
		replace_keycodes = false,
	})
	vim.g.copilot_no_tab_map = true
end

require("lazy").setup({
	{
		"junegunn/fzf.vim",
		dependencies = {
			"junegunn/fzf",
		},
		config = function() end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	-- mason
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		"rcarriga/nvim-notify",
		version = "*",
		config = function()
			-- require("notify").setup({
			--     background_colour = "#000000",
			--     stages = "fade_in_slide_out",
			--     timeout = 3000,
			--     max_height = 10,
			--     max_width = 100,
			--     render = "compact",
			-- })
			vim.notify = require("notify")
		end,
	},
	-- install without yarn or npm
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			vim.g.mkdp_open_to_the_world = 1
			vim.g.mkdp_echo_preview_url = 1
			vim.g.mkdp_port = 30888
		end,
	},
	-- {
	--     "SmiteshP/nvim-navic",
	--     dependencies = {
	--         "neoclide/coc.nvim",
	--     },
	--     config = function()
	--         local navic = require("nvim-navic")
	--         navic.setup({
	--             lsp = {
	--                 auto_attach = true,
	--                 preference = nil,
	--             },
	--         })
	--     end
	-- },
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim",
		},
		lazy = false, -- neo-tree will lazily load itself
		---@module "neo-tree"
		---@type neotree.Config?
		opts = {
			-- fill any relevant options here
		},
	},
	{
		"brenoprata10/nvim-highlight-colors",
		opts = {},
	},
	{
		"Mofiqul/vscode.nvim",
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ "neotest" },
			},
		},
	},
	-- {
	--     dir ="~/projects/neocov/",
	--     opts = {},
	-- },
	-- {
	--     dir  = "~/.local/opts/gongfeng",
	--     name = "gongfeng",
	-- },
	--
	--测试dir
	-- {
	--
	--     "github/copilot.vim",
	--     opt = {},
	-- },
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-treesitter/playground",

			-- adapters
			--
			"nvim-neotest/neotest-python",
			"pedroren-001/neotest-lua",
			"nvim-neotest/neotest-go",
		},
		config = function()
			-- 打印neotest_python的路径. 以便知道是从什么路径加载的
			-- print(package.path)
			require("neotest").setup({
				adapters = {
					-- require("neotest-gtest").setup({}),
					-- require("neotest-python")({
					--     dap = {justMyCode = false},
					--     args = {"--log-level", "DEBUG"},
					--     runner = "pytest",
					--     ignore_file_types = { "lua" },
					-- }),
					require("neotest-lua")({
						dap = { justMyCode = false },
						args = { "--log-level", "DEBUG", "--server_port_path", "~/trunk/bin/test_port.txt" },
					}),
					require("neotest-go"),
				},
				quickfix = {
					open = true,
				},
			})
		end,
	},
	-- 对齐相关的
	{
		"junegunn/vim-easy-align",
		config = function()
			-- Add a keymap to start interactive EasyAlign in visual mode (e.g. vipga)
			vim.keymap.set("x", "ga", "<Plug>(EasyAlign)", { desc = "Start interactive EasyAlign in visual mode" })
			-- Add a keymap to start interactive EasyAlign for a motion/text object (e.g. gaip)
			vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", { desc = "Start interactive EasyAlign" })
		end,
	},
	-- {
	--     'fatih/vim-go',
	-- },
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup({
				defaults = {
					layout_strategy = "center",
					preview = false,
					mappings = {
						i = {
							["<C-u>"] = false,
							["<C-w>"] = actions.close,
							-- ["<C-w>"] = as default (deletes a word)
							-- local actions = require('telescope.actions')
						},
					},
				},
			})
			vim.cmd([[
                autocmd User TelescopePreviewerLoaded setlocal number
            ]])
		end,
	},
	{
		"Bekaboo/dropbar.nvim",
		-- optional, but required for fuzzy finder support
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		config = function()
			local dropbar_api = require("dropbar.api")
			vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
			vim.keymap.set("n", "<A-[>", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
			vim.keymap.set("n", "<A-]>", dropbar_api.select_next_context, { desc = "Select next context" })
		end,
	},
	-- {
	-- 	"cbochs/portal.nvim",
	-- 	-- Optional dependencies
	-- 	dependencies = {
	-- 		"cbochs/grapple.nvim",
	-- 		"ThePrimeagen/harpoon",
	-- 	},
	-- 	config = function()
	-- 		vim.keymap.set("n", "<leader>o", "<cmd>Portal jumplist backward<cr>")
	-- 		vim.keymap.set("n", "<leader>i", "<cmd>Portal jumplist forward<cr>")
	-- 	end,
	-- },
	-- {
	--     "tiagovla/scope.nvim",
	--     config = {
	--         hooks = {
	--             pre_tab_leave = function()
	--                 vim.api.nvim_exec_autocmds('User', {pattern = 'ScopeTabLeavePre'})
	--                 -- [other statements]
	--             end,
	--
	--             post_tab_enter = function()
	--                 vim.api.nvim_exec_autocmds('User', {pattern = 'ScopeTabEnterPost'})
	--                 -- [other statements]
	--             end,
	--
	--         }
	--     }
	-- },
	{
		"ianva/vim-youdao-translater",
	},
	-- {
	--     'romgrk/barbar.nvim',
	--     dependencies = {
	--         'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
	--         'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
	--     },
	--     init = function()
	--         vim.g.barbar_auto_setup = true
	--     end,
	--     opts = {
	--         -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
	--         animation = true,
	--         auto_hide = true,
	--         tabpages = true,
	--         exclude_ft = {'qf'}
	--
	--         -- insert_at_start = true,
	--         -- …etc.
	--     },
	--     version = '^1.0.0', -- optional: only update when a new 1.x version is released
	-- },
	-- {
	-- 	"akinsho/bufferline.nvim",
	-- 	version = "*",
	-- 	dependencies = "nvim-tree/nvim-web-devicons",
	-- 	opts = {},
	-- 	config = {
	-- 		options = {
	-- 			mode = "tabs",
	-- 			diagnostics = "coc",
	-- 		},
	-- 	},
	-- },
	{
		"navarasu/onedark.nvim",
		config = function()
			-- require("onedark").setup({
			-- 	style = "warm",
			-- })
			-- require("onedark").load()
		end,
	},
	{
		"mg979/vim-visual-multi",
	},
	{
		"preservim/vimux",
		config = function() end,
	},
	-- NVIM已经原生支持这个了
	-- {
	--     "ojroques/vim-oscyank",
	--     config = function()
	--     end,
	-- },
	{
		"skywind3000/asynctasks.vim",
		dependencies = {
			"skywind3000/asyncrun.vim",
		},
		config = function()
			vim.g.asyncrun_open = 6 -- 设置打开的窗口
			vim.g.asynctasks_term_reuse = 1
			vim.g.asynctasks_term_hidden = 1
			vim.g.asynctasks_term_listed = 0
			vim.keymap.set("n", "<f5>", ":AsyncTask file-run <CR>", {
				silent = true,
				noremap = true,
				desc = "run current file",
			})
			vim.keymap.set("i", "<f9>", "<esc>:AsyncTask file-build<CR>", {
				silent = true,
				noremap = true,
				desc = "build file",
			})
			vim.keymap.set("n", "<f1>", "<esc>:AsyncTask log-show<CR>", {
				silent = true,
				noremap = true,
				desc = "show log",
			})
		end,
	},
	-- 弃用了，使用indent-blankline.nvim
	-- {
	-- 	"Yggdroot/indentLine",
	-- 	config = function()
	-- 		vim.g.indent_guides_start_level = 2
	-- 		-- vim.g.asynctasks_term_pos = 'external'
	-- 	end,
	-- },
	{
		"kstevens715/monoky.nvim", --
	},
	{
		"loctvl842/monokai-pro.nvim", -- 主题
	},
	--[[
	{
		"dense-analysis/ale",
		config = function()
			-- Configuration goes here.
			local g = vim.g
			-- Register a custom linter for 'TODO' comments

			vim.g.ale_linter_aliases["todo"] = {
				name = "todo",
				command = 'grep -Hn "TODO" %',
				output_stream = "stdout",
				format = "%f:%l:%c: %m",
				callback = function(buffer)
					local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
					local diagnostics = {}
					for line_num, line in ipairs(lines) do
						local col = line:find("TODO")
						if col then
							table.insert(diagnostics, {
								text = "TODO found",
								lnum = line_num - 1,
								col = col - 1,
								type = "I", -- I stands for info level message in ALE
							})
						end
					end
					return diagnostics
				end,
			}
			g.ale_use_neovim_diagnostics_api = 1
			g.ale_linters_explicit = 1
			g.ale_keep_list_window_open = 1
			g.ale_disable_lsp = 0
			g.ale_sign_error = '>>'
			g.ale_sign_warning = '>>'
			g.ale_open_list = 1
			g.ale_disable_lsp = 0
			g.ale_sign_column_always = 1
			g.ale_virtualtext_cursor = "current"
			g.ale_echo_msg_format = '[%linter%] %s [%severity%]'
			g.ale_echo_msg_format = "%s [%severity%]"

			g.ale_echo_msg_warning_str = "警告"
			g.ale_echo_msg_error_str = "错误"
			g.ale_echo_msg_info_str = "信息"
			vim.g.ale_sign_style_error = '✗ '
			vim.g.ale_sign_style_warning = '⚡'
			-- sign define ALEError text=✗  texthl=ALEError
			-- sign define ALEWarning text=⚡ texthl=ALEWarning
			g.ale_linters = {
				-- sql = {'sqlfluff'},
				["*"] = {
					"todo",
				},
                -- ["lua"] = {
                --     "lua_ls"
                -- },
			}
		end,
	},
    --]]
	{
		"pedroren-001/blame.nvim",
		lazy = true,
		cmd = { "BlameToggle" },
		config = function()
			require("blame").setup({})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
	{
		"LunarVim/bigfile.nvim",
		dependencies = {
			-- "echasnovski/mini.diff",
			--
		},
		lazy = false,
		config = function()
			local disable_coc = {
				name = "disable_coc",
				opts = {
					defer = false,
				},
				disable = function()
					local cmp = require("cmp")
					if cmp then
						cmp.setup({ enabled = false })
					end
					vim.lsp.stop_client(vim.lsp.get_active_clients({ bufnr = 0 }))

					-- disable flash.nvim
					-- folke/flash.nvim
					require("flash").setup({
						modes = {
							search = {
								enabled = false,
							},
						},
					})

					-- disable codebuddy

					-- default theme
					-- vim.cmd([[colorscheme default]])
					-- disable lualine
					-- vim.cmd([[lua require('lualine').setup({})]])
					-- disbale Mini.Diff
					-- require('mini.diff').disable(0)
					vim.g.minidiff_disable = true
					-- require('conform').disable()
					-- require('rainbow-delimiters').disable(0)
					vim.cmd([[
                        TSContext disable
                    ]])

					-- notify
					vim.notify("big file detected. some features are disabled", vim.log.levels.INFO)
				end,
			}
			local opt = {
				filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
				-- pattern = {
				-- 	"*",
				-- }, -- autocmd pattern or function see <### Overriding the detection of big files>
				features = { -- features to disable
					"indent_blankline",
					"illuminate",
					"lsp",
					"vimopts",
					"treesitter",
					"syntax", -- 会关闭高亮
					"matchparen",
					"vimopts",
					-- "filetype",
					disable_coc,
				},
				pattern = function(bufnr, filesize_mib)
					-- you can't use `nvim_buf_line_count` because this runs on BufReadPre
					local file_contents = vim.fn.readfile(vim.api.nvim_buf_get_name(bufnr))
					local file_length = #file_contents
					local filetype = vim.filetype.match({ buf = bufnr })

					if file_length > 20000 then
						return true
					end
				end,
			}
			require("bigfile").setup(opt)
		end,
	},
	{
		"dnlhc/glance.nvim",
		cmd = "Glance",
		config = function()
			require("glance").setup({})
			vim.keymap.set("n", "gD", "<CMD>Glance definitions<CR>")
			vim.keymap.set("n", "gR", "<CMD>Glance references<CR>")
			vim.keymap.set("n", "gY", "<CMD>Glance type_definitions<CR>")
			vim.keymap.set("n", "gM", "<CMD>Glance implementations<CR>")
		end,
	},
	{
		"goolord/alpha-nvim",
		dependencies = {
			"echasnovski/mini.icons",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("alpha").setup(require("alpha.themes.theta").config)
		end,
	},
	{
		"echasnovski/mini.diff",
		version = false,
		opts = {
			source = {
				attach = function(buf_id)
					-- Ensure the file is under SVN control
					local file_path = vim.fn.bufname(buf_id)
					local svn_status = vim.fn.systemlist("svn info " .. file_path)
					if vim.v.shell_error ~= 0 or #svn_status == 0 then
						-- vim.notify('file is not under SVN control', vim.log.levels.ERROR)
						return false
					end

					-- Define the reference text using `svn cat` for the base revision
					local ref_text = vim.fn.systemlist("svn cat " .. file_path .. "@BASE")
					if vim.v.shell_error ~= 0 then
						-- vim.notify('Failed to retrieve reference text from SVN', vim.log.levels.ERROR)
						return false
					end

					-- Remove `\r` only at the end of lines
					for i = 1, #ref_text do
						ref_text[i] = vim.fn.substitute(ref_text[i], "\r$", "", "")
					end

					-- Set reference text in MiniDiff
					require("mini.diff").set_ref_text(buf_id, ref_text)
				end,
				name = "svn",
				detach = function(buf_id)
					-- Optional: cleanup logic when buffer is disabled
					-- vim.notify("Detached MiniDiff for buffer " .. buf_id, vim.log.levels.INFO)
				end,

				apply_hunks = function(buf_id, hunks)
					-- Optional: apply changes back to SVN
					vim.notify("applying changes to SVN is not yet implemented", vim.log.levels.WARN)
				end,
			},
			view = {
				style = "sign",
			},
		},
	},
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				detection_methods = { "pattern" },
				patterns = { ".git", "Makefile", "package.json", "luahelper.json", "go.mod" },
				-- show_hidden = true,
				-- silent_chdir = false,
			})
		end,
	},

	-- {
	-- 	"folke/which-key.nvim",
	-- 	event = "VeryLazy",
	-- 	opts = {
	-- 		-- your configuration comes here
	-- 		-- or leave it empty to use the default settings
	-- 		-- refer to the configuration section below
	-- 	},
	-- 	keys = {
	-- 		{
	-- 			"<leader>?",
	-- 			function()
	-- 				require("which-key").show({
	-- 					global = false,
	-- 				})
	-- 			end,
	-- 			desc = "Buffer Local Keymaps (which-key)",
	-- 		},
	-- 	},
	-- },
	-- Lua
	{
		"folke/zen-mode.nvim",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	{
		"nvim-telescope/telescope-media-files.nvim",
		dependencies = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("telescope").load_extension("media_files")
		end,
	},
	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("github-theme").setup({
				-- ...
			})

			vim.cmd("colorscheme github_dark")
		end,
	},
	-- amongst your other plugins
	{ "akinsho/toggleterm.nvim", version = "*", config = true },
	{
		"lewis6991/gitsigns.nvim",
		config = {
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signs_staged = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signs_staged_enable = true,
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				follow_files = true,
			},
			auto_attach = true,
			attach_to_untracked = false,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
				use_focus = true,
			},
			current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
		},
	},
	{
		"nvim-tree/nvim-tree.lua",
		config = {},
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"stevearc/conform.nvim",
		-- use ConformInfo to debug
		config = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
			require("conform").setup({
				formatters_by_ft = {
                    json = {"jq"},
					lua = {
						"stylua",
						lsp_format = "prefer",
						-- range_args = function(self, ctx)
						--
						-- end
					},
					go = {
						"gofmt",
						"goimports",
						lsp_format = "prefer",
					},
					sql = {
						"sql_formatter",
					},
					mysql = {
						"sql_formatter",
					},
					-- Use the "*" filetype to run formatters on all filetypes.
					["*"] = { "codespell" },
					-- Use the "_" filetype to run formatters on filetypes that don't
					-- have other formatters configured.
					["_"] = { "trim_whitespace" },
				},
				formatters = {
					sql_formatter = {
						command = "sql-formatter",
						prepend_args = {
							"-l",
							"mysql",
							"-c",
							"/home/pedroren/.config/sqls/sql-format.json",
						},
					},
				},
			})

			--          -- Global Format command
			--          vim.api.nvim_create_user_command('Format', function()
			--              require('conform').format()
			--          end, {})
			--
			--
			-- vim.keymap.set('v', "<leader>ff",
			--              function()
			--                  require('conform').format({async=true, lsp_fallback=false})
			--              end
			--          )
		end,
		keys = {
			{
				"<leader>ff",
				function()
                    require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = { "n", "v" },
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {
			"nvim-treesitter",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = { ["<leader>fn"] = "@function.outer" },
						goto_previous_start = { ["<leader>fp"] = "@function.outer" },
					},
					select = {
						enable = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
							["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
						},
					},
				},
			})
		end,
	},
	{
		"kylechui/nvim-surround",
		opts = {},
	},
	{
		"lambdalisue/vim-suda",
		opts = {},
		config = function()
			vim.g.suda_smart_edit = 1
			vim.api.nvim_create_user_command("W", "SudaWrite", {})
		end,
	},
	-- 这玩意文件大了以后贼卡
	-- {
	-- 	"HiPhish/rainbow-delimiters.nvim",
	-- 	dependencies = {
	-- 		"nvim-treesitter",
	-- 	},
	-- },
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
			"onsails/lspkind.nvim",
			-- "SirVer/ultisnips",
			-- "honza/vim-snippets", -- 社区维护的大量的snippets
			-- "quangnguyen30192/cmp-nvim-ultisnips",
		},
		config = function()
			-- 当前的光标前面是否是空格. 当前的光标前面是空格, 则返回true
			local check_backspace = function()
				local col = vim.fn.col(".") - 1
				return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
			end

			local cmp = require("cmp")
			if not cmp then
				return
			end

			-- ultisnips directory setup
			-- vim.g.UltiSnipsSnippetDirectories = { "~/.config/nvim/snippets/ultisnippets/", "vim-snippets/UltiSnips" }

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
				preselect = cmp.PreselectMode.None,
			})

			local lsp_kind = require("lspkind")

			cmp.setup({
				sources = {
					{ name = "buffer" },
					{ name = "nvim_lsp" },
					{ name = "neorg" },
					{ name = "path" },
					{ name = "nvim_lsp_signature_help" },
				},
				preselect = cmp.PreselectMode.Item,
				mapping = {
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Replace }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Replace }),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<s-tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true, behavior = cmp.SelectBehavior.Replace })
						elseif check_backspace() then
							fallback()
						else
							cmp.complete()
						end
					end, { "i", "s" }),
					["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.SelectBehavior.Replace }),
				},
				snippet = {
					-- expand = function(args)
					-- 	vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					-- end,
				},
				formatting = {
					format = lsp_kind.cmp_format({
						mode = "symbol",
						preset = "codicons",
						before = function(entry, vim_item)
							vim_item.menu = ({
								buffer = "[Buffer]",
								nvim_lsp = "[LSP]",
								neorg = "[Neorg]",
								path = "[Path]",
							})[entry.source.name]
							return vim_item
						end,
					}),
				},
			})

			cmp.setup.cmdline(":", {
				-- mapping = {
				-- 	["<tab>"] = cmp.mapping(function(callback)
				-- 		if cmp.visible() then
				-- 			if cmp.get_selected_entry() then
				-- 				cmp.confirm({ select = true })
				-- 			else
				-- 				cmp.complete()
				-- 			end
				-- 		else
				-- 			cmp.complete()
				-- 		end
				-- 	end),
				-- },

                mapping = cmp.mapping.preset.cmdline(),

				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				-- matching = { disallow_symbol_nonprefix_matching = false },
				completion = {
					completeopt = "menu,menuone,noinsert",
					autocomplete = false,
				},
			})

			setup_copilot_mapping()
		end,
	},
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			-- add any options here
		},
	},
	{
		-- yet another fuzzy finder
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- or if using mini.icons/mini.nvim
		-- dependencies = { "echasnovski/mini.icons" },
		config = function()
			local project_rg = vim.fn.getcwd() .. "/.ripgreprc"
			local has_local_rc = vim.loop.fs_stat(project_rg) ~= nil
			require("fzf-lua").setup({
				grep = {
					RIPGREP_CONFIG_PATH = has_local_rc and project_rg or vim.env.RIPGREP_CONFIG_PATH,
				},
			})
		end,
		opts = {},
	},
	{
		"yanskun/gotests.nvim",
		ft = "go",
		config = function()
			require("gotests").setup()
		end,
	},
	-- 这个插件是自己写的. 如果需要初始化，可以写在 config 里
	{
		dir = "~/.config/nvim/gongfeng-copilot",
		name = "gongfeng-copilot", -- 插件显示名字
		config = function()
			-- 如果插件需要初始化，这里写初始化命令
			-- 比如确保二进制路径或 API key
		end,
	},
	{
		"mistweaverco/kulala.nvim",
		keys = {
			{ "<leader>Rs", desc = "Send request" },
			{ "<leader>Ra", desc = "Send all requests" },
			{ "<leader>Rb", desc = "Open scratchpad" },
		},
		ft = { "http", "rest" },
		opts = {
			global_keymaps = true,
			global_keymaps_prefix = "<leader>R",
			kulala_keymaps_prefix = "",
		},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {
			modes = {
				search = {
					enabled = true,
				},
			},
		},
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
	},
	{
		"RRethy/vim-illuminate",
		config = function() end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},

		config = function()
			-- 设置 IndentBlanklineChar 的高亮
			require("ibl").setup({
				scope = { 
                    enabled = true,
                    show_start = false,
                    char = "▏",
                },
				indent = {
                    char = "▏",
				},
			})
		end,
	},
    {
        "rachartier/tiny-code-action.nvim",
        dependencies = {
            {"nvim-lua/plenary.nvim"},

            -- optional picker via telescope
            {"nvim-telescope/telescope.nvim"},
            -- optional picker via fzf-lua
            {"ibhagwan/fzf-lua"},
            {
                "folke/snacks.nvim",
                opts = {
                    terminal = {},
                }
            }
        },
        event = "LspAttach",
        opts = {},
    },
    {
        "filipdutescu/renamer.nvim",
        opts = {},
        event = "LspAttach",
        keys = {
            {"<leader>rn", "<cmd>lua require('renamer').rename()<cr>", desc = "Rename" },
        },
    },
    -- last-place
    {
        "ethanholz/nvim-lastplace",
        event = "BufReadPost",
        config = function()
            require("nvim-lastplace").setup({})
        end,
    },

    -- Marks
    {
        "chentoast/marks.nvim",
        event = "VeryLazy",
        opts = {},
    },
    
    -- dressing.nvim - 美化 vim.ui.input 和 vim.ui.select
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {
            input = {
                -- 设置为 true 启用输入框
                enabled = true,
                -- 默认提示符
                default_prompt = "Input:",
                -- 提示符是否使用高亮
                trim_prompt = true,
                -- 输入框标题对齐方式
                title_pos = "left",
                -- 插入模式自动进入
                start_in_insert = true,
                -- 输入框边框样式
                border = "rounded",
                -- 相对位置
                relative = "cursor",
                -- 首选宽度
                prefer_width = 40,
                -- 最大宽度
                width = nil,
                -- 最小宽度
                min_width = 20,
                -- 浮动窗口配置
                win_options = {
                    winblend = 10,
                    wrap = false,
                    list = true,
                    listchars = "precedes:…,extends:…",
                },
            },
            select = {
                -- 启用 select
                enabled = true,
                -- 后端优先级
                backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
                -- Trim trailing `:` from prompt
                trim_prompt = true,
                -- fzf-lua 配置
                fzf_lua = {
                    winopts = {
                        height = 0.5,
                        width = 0.5,
                    },
                },
            },
        },
    },
    -- remote
    {
        "amitds1997/remote-nvim.nvim",
        version = "*", -- Pin to GitHub releases
        dependencies = {
            "nvim-lua/plenary.nvim", -- For standard functions
            "MunifTanjim/nui.nvim", -- To build the plugin UI
            "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
        },
        config = function()
            require("remote-nvim").setup({
                devpod = {
                    enabled = false,
                },
            })
        end
    },
    -- {
    --     "navarasu/onedark.nvim",
    --     priority = 1000, -- make sure to load this before all the other start plugins
    --     config = function()
    --         require('onedark').setup {
    --             style = 'warmer'
    --         }
    --         require('onedark').load()
    --     end
    -- }
    
    -- 展示代码提示
    -- { 
    --     'kosayoda/nvim-lightbulb',
    --     opts = {
    --          autocmd = { 
    --              enabled = true 
    --          }
    --     }
    -- },


})
