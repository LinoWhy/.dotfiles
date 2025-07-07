local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
local adapters = {
  -- gdb 14.0+
  gdb = {
    type = "executable",
    command = "gdb",
    args = { "-i", "dap" },
  },
  cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = mason_path .. "bin/OpenDebugAD7",
  },
  codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = mason_path .. "bin/codelldb",
      args = { "--port", "${port}" },
      -- On windows you may have to uncomment this:
      -- detached = false,
    },
  },
}

local function dap_configurations()
  -- use telescope to pick a executable as debugee
  local function pick_program()
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local themes = require("telescope.themes")
    local command = { "fd", "--hidden", "--follow", "--no-ignore", "--type", "x" }

    return coroutine.create(function(coro)
      local opt = vim.deepcopy(themes.get_dropdown())
      pickers
        .new(opt, {
          prompt_title = "Find executable to debug",
          finder = finders.new_oneshot_job(command, {}),
          sorter = conf.generic_sorter(opt),
          attach_mappings = function(buffer_number)
            actions.select_default:replace(function()
              actions.close(buffer_number)
              coroutine.resume(coro, action_state.get_selected_entry()[1])
            end)
            return true
          end,
        })
        :find()
    end)
  end

  local function get_args()
    local opts = { prompt = "Args: ", completion = "file", relative = "editor" }
    return coroutine.create(function(coro)
      vim.ui.input(opts, function(input)
        local args = {}

        if input then
          -- handles multiple spaces
          -- TODO: handle quotes
          for word in input:gmatch("%S+") do
            table.insert(args, word)
          end
        end

        coroutine.resume(coro, args)
      end)
    end)
  end

  local configurations = {
    cpp = {
      {
        name = "Launch file - lldb",
        type = "codelldb",
        request = "launch",
        program = pick_program,
        args = get_args,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
      {
        -- If you get an "Operation not permitted" error using this, try disabling YAMA:
        --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        name = "Attach to process - lldb",
        type = "codelldb",
        request = "attach",
        pid = function()
          return require("dap.utils").pick_process()
        end,
        args = {},
      },
      {
        name = "Launch file - cppdbg",
        type = "cppdbg",
        request = "launch",
        program = pick_program,
        args = get_args,
        cwd = "${workspaceFolder}",
        stopAtEntry = false,
        setupCommands = {
          {
            text = "-enable-pretty-printing",
            description = "enable pretty printing",
            ignoreFailures = false,
          },
        },
      },
      {
        name = "Attach to gdb-multiarch server",
        type = "cppdbg",
        request = "launch",
        MIMode = "gdb",
        miDebuggerServerAddress = "localhost:1234",
        miDebuggerPath = "gdb-multiarch",
        cwd = "${workspaceFolder}",
        stopAtEntry = false,
        program = pick_program,
        setupCommands = {
          {
            text = "-enable-pretty-printing",
            description = "enable pretty printing",
            ignoreFailures = false,
          },
        },
      },
      -- build gdb from source with "--enable-targets=all" for all target triplets
      {
        name = "Attach to gdb server - cppdbg",
        type = "cppdbg",
        request = "launch",
        MIMode = "gdb",
        miDebuggerServerAddress = "localhost:1234",
        -- miDebuggerPath = "/usr/local/bin/gdb",
        cwd = "${workspaceFolder}",
        stopAtEntry = false,
        program = pick_program,
        setupCommands = {
          {
            text = "-enable-pretty-printing",
            description = "enable pretty printing",
            ignoreFailures = false,
          },
        },
      },
      {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = pick_program,
        args = get_args,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
      },
    },
  }
  configurations.c = configurations.cpp
  configurations.rust = configurations.cpp

  return configurations
end

local keys = {
  -- dap
  { "<F4>", "<cmd>lua require('dap').run_to_cursor()<cr>", desc = "Run to Cursor" },
  { "<F5>", "<cmd>lua require('dap').continue()<cr>", desc = "Continue" },
  { "<F6>", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
  { "<F9>", "<cmd>lua require('dap').step_into()<cr>", desc = "Step Into" },
  { "<F10>", "<cmd>lua require('dap').step_over()<cr>", desc = "Step Over" },
  { "<F12>", "<cmd>lua require('dap').step_out()<cr>", desc = "Step Out" },
  {
    "<leader>dB",
    "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
    desc = "Conditional Breakpoint",
  },
  { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
  { "<leader>dC", "<cmd>lua require('dap').run_to_cursor()<cr>", desc = "Run to Cursor" },
  { "<leader>dc", "<cmd>lua require('dap').continue()<cr>", desc = "Continue" },
  { "<leader>dj", "<cmd>lua require('dap').down()<cr>", desc = "Down" },
  { "<leader>dk", "<cmd>lua require('dap').up()<cr>", desc = "Up" },
  { "<leader>dl", "<cmd>lua require('dap').run_last()<cr>", desc = "Run Last" },
  { "<leader>dp", "<cmd>lua require('dap').pause()<cr>", desc = "Pause" },
  { "<leader>dt", "<cmd>lua require('dap').terminate()<cr>", desc = "Terminate" },
  -- dapui
  { "<F1>", "<cmd>lua require 'dapui'.eval()<cr>", mode = { "n", "v" }, desc = "Eval" },
  { "<leader>du", "<cmd>lua require('dapui').toggle({})<cr>", desc = "Toggle UI" },
  { "<leader>de", "<cmd>lua require('dapui').eval()<cr>", desc = "Eval", mode = { "n", "v" } },
}

return {
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    opts = {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.38 },
            { id = "breakpoints", size = 0.12 },
            { id = "stacks", size = 0.3 },
            { id = "watches", size = 0.2 },
          },
          size = 0.33,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.45 },
            { id = "console", size = 0.55 },
          },
          size = 0.23,
          position = "bottom",
        },
      },
      expand_lines = false, -- Expand current line to hover window if larger
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup(opts)

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({ reset = true })
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
    opts = {
      show_stop_reason = true,
      all_references = false,
      virt_text_pos = "eol",
    },
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope.nvim",
      {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        config = function()
          if vim.fn.has("win32") == 1 then
            require("dap-python").setup(mason_path .. "packages/debugpy/venv/Scripts/pythonw.exe")
          else
            require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
          end
        end,
      },
    },
    keys = keys,
    lazy = true,
    config = function()
      local dap = require("dap")

      dap.adapters = adapters
      dap.configurations = dap_configurations()

      -- highlight stoppedline
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      -- change dap sign
      for name, sign in pairs(Lino.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end
    end,
  },
}
