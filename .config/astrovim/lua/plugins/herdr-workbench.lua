return {
  {
    dir = "/home/thiennguyen/playground/herdr-workbench/nvim",
    name = "herdr-workbench",
    lazy = false,
    dependencies = {
      { "esmuellert/codediff.nvim", commit = "e08a35a56a52c290398ebfaec33c34cfcf2d0f3c" },
      { "MunifTanjim/nui.nvim", commit = "f535005e6ad1016383f24e39559833759453564e" },
    },
    config = function()
      require("herdr-workbench").setup()
    end,
  },
}
