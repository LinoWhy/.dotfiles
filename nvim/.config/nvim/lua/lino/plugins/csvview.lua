return {
  "hat0uma/csvview.nvim",
  opts = {
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    view = {
      display_mode = "border",
      header_lnum = true,
      sticky_header = {
        enabled = true,
        separator = "─",
      },
    },
  },
}
