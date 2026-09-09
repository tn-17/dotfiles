return {
  {
    "smoka7/hop.nvim",
    opts = {
      multi_windows = true,
    },
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["s"] = {
                function() require("hop").hint_words { multi_windows = true } end,
                desc = "Hop hint words",
              },
            },
            x = {
              ["s"] = {
                function() require("hop").hint_words { extend_visual = true, multi_windows = false } end,
                desc = "Hop hint words",
              },
            },
            o = {
              ["s"] = {
                function() require("hop").hint_words { multi_windows = false } end,
                desc = "Hop hint words",
              },
            },
          },
        },
      },
    },
  },
}
