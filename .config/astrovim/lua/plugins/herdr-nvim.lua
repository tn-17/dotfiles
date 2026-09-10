return {
  {
    "jtnovellis/herdr-nvim",
    build = "sh scripts/build.sh",
    lazy = vim.env.HERDR_NVIM_DAEMON ~= "1",
    cmd = {
      "HerdrAsk",
      "HerdrReply",
      "HerdrAskTarget",
      "HerdrAnnotate",
      "HerdrAnnotations",
      "HerdrSend",
      "HerdrPaste",
      "HerdrPreview",
      "HerdrPickFile",
      "HerdrAgents",
    },
    keys = {
      "<leader>ac",
      "<leader>ar",
      "<leader>aa",
      "<leader>al",
      "<leader>as",
      "<leader>aS",
      "<leader>af",
    },
    opts = {},
  },
}
