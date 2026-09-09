-- Make AstroDark use true black for OLED-friendly UI surfaces.
---@type LazySpec
return {
  "AstroNvim/astrotheme",
  opts = {
    palettes = {
      astrodark = {
        ui = {
          base = "#000000",
          inactive_base = "#000000",
          float = "#000000",
          tool = "#000000",
          tabline = "#000000",
          statusline = "#000000",
          prompt = "#000000",
        },
        term = {
          black = "#000000",
          background = "#000000",
        },
      },
    },
  },
}
