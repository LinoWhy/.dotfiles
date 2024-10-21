-- A collection of global configs
vim.g.mapleader = " "
vim.g.maplocalleader = ","

_G.Lino = {}

Lino.colorscheme = "catppuccin-macchiato"
Lino.diagnose_virtual_text = false
Lino.diagnose_severity_level = vim.diagnostic.severity.HINT
Lino.inlay_hints = true
Lino.extra_width = 10
Lino.watch_and_dispatch = false

-- configuration for each file type
Lino.format_on_save = {
  lua = true,
}

Lino.icons = {
  kind = {
    Array = "",
    Boolean = "",
    Class = "",
    Codeium = "󰘦",
    Color = "",
    Constant = "",
    Constructor = "",
    Enum = "",
    EnumMember = "",
    Event = "",
    Field = "",
    File = "",
    Folder = "",
    Function = "󰊕",
    Interface = "",
    Key = "",
    Keyword = "",
    Method = "󰡱",
    Module = "",
    Namespace = "",
    Null = "󰟢",
    Number = "",
    Object = "",
    Operator = "󰆕",
    Package = "",
    Property = "",
    Reference = "󰈇",
    Snippet = "",
    Supermaven = "󰘦",
    String = "",
    Struct = "",
    Text = "",
    TypeParameter = "",
    Unit = "",
    Value = "󰎠",
    Variable = "󰫧",
  },
  git = {
    LineAdded = "",
    LineModified = "",
    LineRemoved = "",
    FileDeleted = "",
    FileIgnored = "",
    FileRenamed = "",
    FileStaged = "",
    FileUnmerged = "",
    FileUnstaged = "",
    FileUntracked = "",
    Diff = "",
    Repo = "",
    Octoface = "",
    Branch = "",
  },
  ui = {
    ArrowCircleDown = "",
    ArrowCircleLeft = "",
    ArrowCircleRight = "",
    ArrowCircleUp = "",
    BoldArrowDown = "",
    BoldArrowLeft = "",
    BoldArrowRight = "",
    BoldArrowUp = "",
    BoldClose = "",
    BoldDividerLeft = "",
    BoldDividerRight = "",
    BoldLineLeft = "▎",
    BoldLineMiddle = "┃",
    BookMark = "",
    BoxChecked = "",
    Bug = "",
    Stacks = "",
    Scopes = "",
    Watches = "󰂥",
    DebugConsole = "",
    Calendar = "",
    Check = "",
    ChevronRight = "",
    ChevronShortDown = "",
    ChevronShortLeft = "",
    ChevronShortRight = "",
    ChevronShortUp = "",
    Circle = "",
    Close = "󰅖",
    CloudDownload = "",
    Code = "",
    Comment = "",
    Dashboard = "",
    DividerLeft = "",
    DividerRight = "",
    DoubleChevronRight = "»",
    Ellipsis = "",
    EmptyFolder = "",
    EmptyFolderOpen = "",
    File = "",
    FileSymlink = "",
    Files = "",
    FindFile = "󰈞",
    FindText = "󰊄",
    Fire = "",
    Folder = "󰉋",
    FolderOpen = "",
    FolderSymlink = "",
    Forward = "",
    Gear = "",
    History = "",
    Lightbulb = "",
    LineLeft = "▏",
    LineMiddle = "│",
    List = "",
    Lock = "",
    NewFile = "",
    Note = "",
    Package = "",
    Pencil = "󰏫",
    Plus = "",
    Project = "",
    Quit = "",
    Search = "",
    Sleep = "󰒲",
    SignIn = "",
    SignOut = "",
    Tab = "󰌒",
    Table = "",
    Target = "󰀘",
    Telescope = "",
    Text = "",
    Tree = "",
    Triangle = "▸",
    TriangleShortArrowDown = "",
    TriangleShortArrowLeft = "",
    TriangleShortArrowRight = "",
    TriangleShortArrowUp = "",
  },
  diagnostics = {
    BoldError = "",
    Error = "",
    BoldWarning = "",
    Warning = "",
    BoldInformation = "",
    Information = "",
    BoldQuestion = "",
    Question = "",
    BoldHint = "",
    Hint = "",
    Debug = "",
    Trace = "✎",
  },
  dap = {
    Stopped = { "󰁕", "DiagnosticWarn", "DapStoppedLine" },
    Breakpoint = "",
    BreakpointCondition = "",
    BreakpointRejected = { "", "DiagnosticError" },
    LogPoint = ".>",
  },
  misc = {
    CircuitBoard = "",
    Command = "",
    Path = "",
    Robot = "󰚩",
    Smiley = "",
    Squirrel = "",
    Tag = "",
    Watch = "",
  },
}
