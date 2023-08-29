---------------------------------------------------------------------------------------------------

local g = require("code.globals")

-- pipe utils -------------------------------------------------------------------------------------

local pipe_utils = {}

function pipe_utils.get_prototype(pipe)
    if pipe.type == "entity-ghost" then
        return pipe.ghost_prototype
    end
    return pipe.prototype
end

function pipe_utils.is_pipe(entity)
    return entity and (entity.type == "pipe" or (entity.type == "entity-ghost" and entity.ghost_type == "pipe"))
end

function pipe_utils.dir_equals(a, b)
    return a.x == b.x and a.y == b.y
end

function pipe_utils.check_flow_state(pipe, states, direction)
    if states[direction] ~= nil then return end

    local dirpos = g.directions[direction].position
    for connection in pipe.fluidbox.get_pipe_connections(1) do
        if pipe_utils.dir_equals(connection.position, dirpos) then
            states[direction] = "flow"
            table.insert(states.directions, direction)
        end
    end
end

function pipe_utils.check_open_state(pipe, states, direction)
    if states[direction] ~= nil then return end


    states[direction] = "open"
    table.insert(states.directions, direction)
    -- Open
    -- TODO
end

function pipe_utils.check_close_state(pipe, states, direction)
    if states[direction] ~= nil then return end

    states[direction] = "close"
    -- Close
    -- TODO
end

function pipe_utils.check_block_state(pipe, states, direction)
    if states[direction] ~= nil then return end
    -- Block: find pipe entities in cardinal direction and check fluid type
    -- TODO

    states[direction] = "block"
end

function pipe_utils.get_direction_states(pipe)
    local states = {}
    for dir,_ in pair(g.directions) do
        pipe_utils.check_flow_state(pipe, states, dir)
        pipe_utils.check_open_state(pipe, states, dir)
        pipe_utils.check_close_state(pipe, states, dir)
        pipe_utils.check_block_state(pipe, states, dir)
    end
    return states
end

function pipe_utils.replace_pipe(player, pipe, directions)
    -- TODO: construct name
    local name = f.construct_pipename(f.get_basename(pipe.name), directions)
    local newpipe = player.surface.create_entity(name=name, position=pipe.position, force=player.force, fast_replace=true, spill=false, create_build_effect_smoke=false)
    if newpipe ~= nil then
        player.update_selected_entity(newpipe.position)
    end
end

function pipe_utils.open_direction(player, pipe, directions, direction)
    if directions[direction] == nil then
        directions[direction] = true
        pipe_utils.replace_pipe(player, pipe, directions)
    end
end

function pipe_utils.close_direction(player, pipe, directions, direction)
    if directions[direction] ~= nil then
        directions[direction] = nil
        pipe_utils.replace_pipe(player, pipe, directions)
    end
end

function pipe_utils.toggle_direction(player, pipe, direction)
    local states = pipe_utils.get_direction_states(pipe)
    if states[direction] == "flow" or states[direction] == "open" then
        pipe_utils.close_direction(player, pipe, states.directions, direction)
        return true
    elseif states[direction] == "close" then
        pipe_utils.open_direction(player, pipe, states.directions, direction)
        return true
    end
end

-- GUI --------------------------------------------------------------------------------------------

local gui = {}

function gui.create(player)
    local frame_main_anchor = {gui = defines.relative_gui_type.pipe_gui, position = defines.relative_gui_position.right}
    local frame_main = player.gui.relative.add({type="frame", name="flow_config", caption={"gui-flow-config.configuration"}, anchor=frame_main_anchor})

    local frame_content = frame_main.add({type="frame", name="frame_content", style="inside_shallow_frame_with_padding"})
    local flow_content = frame_content.add({type="flow", name="flow_content", direction="vertical"})

    local toggle_content = flow_content.add({type="flow", name="toggle_content", direction="horizontal"})
    toggle_content.add({type="label", name="label_toggle", caption={"gui-flow-config.toggle"}, style="heading_2_label"})
    local toggle_button = toggle_content.add({type="sprite-button", name="toggle_button", caption={"gui-flow-config.open"}, sprite="icon/fc-toggle-open")

    flow_content.add({type="line", name="line", style="control_behavior_window_line"})

    flow_content.add({type="label", name="label_flow", caption={"gui-flow-config.directions"}, style="heading_2_label"})
    
    local table_direction = flow_content.add({type="table", name="table_direction", column_count=3})
    table_direction.style.horizontal_spacing = 1
    table_direction.style.vertical_spacing = 1

    for y = -1, 1, 1 do
        for x = -1, 1, 1 do
            local suffix = "_"..tostring(x+2).."_"..tostring(y+2)
            if x == 0 and y == 0 then
                local sprite = table_direction.add({type="sprite", name="sprite_pipe", sprite="item/pipe"})
                sprite.style.stretch_image_to_widget_size = true
                sprite.style.size = {32, 32}
            else
                local button = table_direction.add({type="sprite-button", name="button_flow"..suffix, style="slot_sized_button"})
                button.style.size = {32, 32}
                if x ~= 0 and y ~= 0 then
                    button.enabled = false
                end
            end
        end
    end
end

function gui.destroy(player)
    if player.gui.relative.flow_config then
        player.gui.relative.flow_config.destroy()
    end
end

function gui.create_all()
    for idx, player in pairs(game.players) do
        gui.delete(player)
        gui.create(player)
    end
end

function gui.update_toggle_button(states, button)
    -- TODO
end

function gui.update_direction_button(states, button, direction)
    if states[direction] == "flow" then
        button.sprite="icon/fc-flow-"..direction
        button.enable=true
    elseif states[direction] == "open" then
        button.sprite="icon/fc-open-"..direction
        button.enable=true
    elseif states[direction] == "close" then
        button.sprite="icon/fc-close-"..direction
        button.enable=true
    elseif states[direction] == "block" then
        button.sprite="icon/fc-block-"..direction
        button.enable=false
    else
        button.sprite=nil
        button.enable=false
    end
end

function gui.update(player, pipe)
    local gui_instance = player.gui.relative.pipe_config.frame_content.flow_content

    gui.update_toggle_button(states, gui_instance.toggle_content.toggle_button)
    gui.update_direction_button(states, gui_instance.table_direction.children[2], "north")
    gui.update_direction_button(states, gui_instance.table_direction.children[4], "west")
    gui.update_direction_button(states, gui_instance.table_direction.children[6], "south")
    gui.update_direction_button(states, gui_instance.table_direction.children[8], "east")

    local icon = "item/pipe"
    if pipe.prototype.items_to_place_this then
        icon = "item/"..pipe.prototype.items_to_place_this[1].name
    end
    gui_instance.table_direction.sprite_pipe.sprite = icon
end

function gui.update_all(pipe)
    for idx, player in pairs(game.players) do
        if (pipe and player.opened == pipe) or (not pipe and player.opened and pipe_utils.is_pipe(player.opened)) then
            gui.update(player, player.opened)
        end
    end
end

local index_to_direction = {
    2 = "north",
    4 = "west",
    6 = "east",
    8 = "south"
}

function gui.get_button_direction(button)
    local idx = button.get_index_in_parent()
    return index_to_direction[idx]
end

function gui.on_button_toggle(player, event)
    -- TODO
end

function gui.on_button_direction(player, event)
    local pipe = player.opened
    local direction = gui.get_button_direction(event.element)
    pipe_utils.toggle_direction(player, pipe, direction)
end

-- GUI events -------------------------------------------------------------------------------------

local function on_gui_opened(event)
	local player = game.players[event.player_index]

	if event.entity and event.entity.type == "pipe" then
		gui.update(player, event.entity)
	end
end

local function on_gui_click(event)
    local player = game.players[event.player_index]
    local gui_instance = player.gui.relative.flow_config.frame_content.flow_content
    if event.element.parent == gui_instance.toggle_content then
        gui.on_button_toggle(player, event)
    elseif event.element.parent == gui_instance.table_direction and event.element ~= gui_instance.table_direction.sprite_pipe then
        gui.on_button_direction(player, event)
    end
    gui.update(player, event.entity)
    

---------------------------------------------------------------------------------------------------
