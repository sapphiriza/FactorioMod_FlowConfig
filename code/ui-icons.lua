---------------------------------------------------------------------------------------------------

local g = require("code.globals")

local function get_icon_path(name)
    return g.icon_path.."/40/"..name
end

for direction,_ in pairs(g.directions) do
    data:extend({
        {
            type = "sprite",
            name = "icon/fc-flow-"..direction,
            filename = get_icon_path("flow-"..direction),
            width = 40,
            height = 40,
            scale = 0.5,
            priority = "extra-high-no-scale"
        },
        {
            type = "sprite",
            name = "icon/fc-open-"..direction,
            filename = get_icon_path("open-"..direction),
            width = 40,
            height = 40,
            scale = 0.5,
            priority = "extra-high-no-scale"
        },
        {
            type = "sprite",
            name = "icon/fc-close-"..direction,
            filename = get_icon_path("close-"..direction),
            width = 40,
            height = 40,
            scale = 0.5,
            priority = "extra-high-no-scale"
        },
        {
            type = "sprite",
            name = "icon/fc-block-"..direction,
            filename = get_icon_path("block-"..direction),
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
        name = "icon/fc-toggle-open",
        filename = get_icon_path("toggle-open"),
        width = 40,
        height = 40,
        scale = 0.5,
        priority = "extra-high-no-scale",
    },
    {
        type = "sprite",
        name = "icon/fc-toggle-close",
        filename = get_icon_path("toggle-close"),
        width = 40,
        height = 40,
        scale = 0.5,
        priority = "extra-high-no-scale",
    },
    {
        type = "sprite",
        name = "icon/fc-toggle-locked",
        filename = get_icon_path("toggle-locked"),
        width = 40,
        height = 40,
        scale = 0.5,
        priority = "extra-high-no-scale",
    },
})

---------------------------------------------------------------------------------------------------
