---------------------------------------------------------------------------------------------------

local g = require("code.globals")

local function get_icon_path(name)
    return g.icon_path.."/40/"..name..".png"
end

for direction,_ in pairs(g.directions) do
    data:extend({
        {
            type = "sprite",
            name = "fc-flow-"..direction,
            filename = get_icon_path("flow-"..direction),
            flags = { "gui-icon" },
            width = 40,
            height = 40,
            scale = 0.5,
            priority = "extra-high-no-scale"
        },
        {
            type = "sprite",
            name = "fc-open-"..direction,
            filename = get_icon_path("open-"..direction),
            flags = { "gui-icon" },
            width = 40,
            height = 40,
            scale = 0.5,
            priority = "extra-high-no-scale"
        },
        {
            type = "sprite",
            name = "fc-close-"..direction,
            filename = get_icon_path("close-"..direction),
            flags = { "gui-icon" },
            width = 40,
            height = 40,
            scale = 0.5,
            priority = "extra-high-no-scale"
        },
        {
            type = "sprite",
            name = "fc-block-"..direction,
            filename = get_icon_path("block-"..direction),
            flags = { "gui-icon" },
            width = 40,
            height = 40,
            scale = 0.5,
            priority = "extra-high-no-scale"
        },
    })
end

data:extend({
    {
        type = "sprite",
        name = "fc-toggle-open",
        filename = get_icon_path("toggle-open"),
        flags = { "gui-icon" },
        width = 40,
        height = 40,
        scale = 0.5,
        priority = "extra-high-no-scale",
    },
    {
        type = "sprite",
        name = "fc-toggle-close",
        filename = get_icon_path("toggle-close"),
        flags = { "gui-icon" },
        width = 40,
        height = 40,
        scale = 0.5,
        priority = "extra-high-no-scale",
    },
    {
        type = "sprite",
        name = "fc-toggle-locked",
        filename = get_icon_path("toggle-locked"),
        flags = { "gui-icon" },
        width = 40,
        height = 40,
        scale = 0.5,
        priority = "extra-high-no-scale",
    },
})

---------------------------------------------------------------------------------------------------
