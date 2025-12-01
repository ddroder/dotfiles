
require('telescope').setup{
    defaults = {
        -- Defining how to display paths. Other options: "hidden", "tail", "absolute"
        path_display = {"smart"},  -- This can be set to "absolute", "shorten", "hidden", etc.
        mappings = {
            i = {
                ["<esc>"] = require('telescope.actions').close
            }
        }
    }
}
