local function get_hls()
  local bg_colors = {
    "#b2e061",
    "#ffee65",
    "#ffb55a",
    "#fd7f6f",
    "#fdcce5",
    "#bd7ebe",
    "#beb9db",
    -- "#8bd3c7",
    -- "#7eb0d5",
  }

  local hls = {}
  for i, color in ipairs(bg_colors) do
    hls[#hls + 1] = {
      "HiMyWordsHLG" .. i - 1,
      { ctermfg = 0, ctermbg = 10, fg = "#000000", bg = color, bold = true, italic = true },
    }
  end

  return hls
end

return {
  "dvoytik/hi-my-words.nvim",
  event = { "BufRead", "BufNewFile" },
  keys = {
    { "<leader>k", "<cmd>HiMyWordsToggle<cr>", desc = "Highlight Keyword" },
    { "<leader>K", "<cmd>HiMyWordsClear<cr>", desc = "Clear Highlighted" },
  },
  opts = {
    silent = true,
    hl_grps = get_hls(),
  },
}
