
require('telescope').setup{
    defaults = {
        -- Defining how to display paths. Other options: "hidden", "tail", "absolute"
        path_display = {"smart"},  -- This can be set to "absolute", "shorten", "hidden", etc.
        preview = {
            treesitter = false,
        },
        mappings = {
            i = {
                ["<esc>"] = require('telescope.actions').close
            }
        }
    }
}
