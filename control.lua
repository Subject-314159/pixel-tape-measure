--------------------------------------------------
-- Helper functions
--------------------------------------------------
local function pretty_format(val)
    -- Format the number to 5 decimal places
    local formatted = string.format("%.5f", val)
    -- Remove trailing zeros and the decimal point if it's not needed
    formatted = formatted:gsub("%.?0+$", "")
    return formatted
end

local function remove_lines()
    if global.pixels.lines then
        for _, line in pairs(global.pixels.lines) do
            rendering.destroy(line)
        end
        global.pixels.lines = nil
    end
end

local function remove_circle()
    if global.pixels.circle then
        rendering.destroy(global.pixels.circle)
        global.pixels.circle = nil
    end
end

local function get_gui(player)
    return player.gui.left["pixel_tape_measure_gui"]
end

--------------------------------------------------
-- GUI functions
--------------------------------------------------

local function destroy_gui(player)
    local gui = get_gui(player)
    if gui then
        gui.destroy()
    end
    remove_lines()
    remove_circle()
end

local function create_gui(player)
    -- Destroy previous GUI if exists
    destroy_gui(player)

    -- Build the main frame
    local screen = player.gui.left
    local main_frame = screen.add {
        type = "frame",
        name = "pixel_tape_measure_gui",
        -- caption = {"pixel_tape_measure_gui"},
        direction = "vertical"
    }
    -- main_frame.style.size = {450, 300}

    -- Create the content
    local content_frame = main_frame.add {
        type = "frame",
        name = "content_frame",
        style = "content_frame",
        direction = "vertical"
    }

    --------------------------------------------------
    -- First table = X/Y position
    --------------------------------------------------

    content_frame.add {
        type = "label",
        caption = "Start & end coordinates"
    }
    local pt = content_frame.add {
        type = "table",
        name = "position_table",
        style = "position_table",
        column_count = 3,
        draw_vertical_lines = true,
        draw_horizontal_lines = true,
        vertical_centering = true
    }
    -- Header --
    pt.add {
        type = "label",
        style = "label_in_table_first",
        caption = ""
    }
    pt.add {
        type = "label",
        style = "label_in_table",
        caption = "X"
    }
    pt.add {
        type = "label",
        style = "label_in_table",
        caption = "Y"
    }
    -- First row / starting point --
    pt.add {
        type = "label",
        style = "label_in_table_first",
        caption = "Start"
    }
    pt.add {
        type = "label",
        style = "label_in_table",
        name = "X_start",
        caption = "?"
    }
    pt.add {
        type = "label",
        style = "label_in_table",
        name = "Y_start",
        caption = "?"
    }
    -- Second row / ending point --
    pt.add {
        type = "label",
        style = "label_in_table_first",
        caption = "End"
    }
    pt.add {
        type = "label",
        style = "label_in_table",
        name = "X_end",
        caption = "?"
    }
    pt.add {
        type = "label",
        style = "label_in_table",
        name = "Y_end",
        caption = "?"
    }

    --------------------------------------------------
    -- Second table = distance
    --------------------------------------------------
    content_frame.add {
        type = "label",
        caption = "Distance"
    }
    local dt = content_frame.add {
        type = "table",
        name = "distance_table",
        column_count = 4,
        draw_vertical_lines = true,
        draw_horizontal_lines = true,
        vertical_centering = true
    }

    -- Header --
    dt.add {
        type = "label",
        style = "label_in_table_first",
        caption = ""
    }
    dt.add {
        type = "label",
        style = "label_in_table",
        caption = "X"
    }
    dt.add {
        type = "label",
        style = "label_in_table",
        caption = "Y"
    }
    dt.add {
        type = "label",
        style = "label_in_table",
        caption = "abs"
    }
    -- First row / starting point --
    dt.add {
        type = "label",
        style = "label_in_table_first",
        caption = "Grid"
    }
    dt.add {
        type = "label",
        style = "label_in_table",
        name = "dX_grid",
        caption = "?"
    }
    dt.add {
        type = "label",
        style = "label_in_table",
        name = "dY_grid",
        caption = "?"
    }
    dt.add {
        type = "label",
        style = "label_in_table",
        name = "d_grid",
        caption = "?"
    }
    -- Second row / ending point --
    dt.add {
        type = "label",
        style = "label_in_table_first",
        caption = "Px"
    }
    dt.add {
        type = "label",
        style = "label_in_table",
        name = "dX_px",
        caption = "?"
    }
    dt.add {
        type = "label",
        style = "label_in_table",
        name = "dY_px",
        caption = "?"
    }
    dt.add {
        type = "label",
        style = "label_in_table",
        name = "d_px",
        caption = "?"
    }
end

--------------------------------------------------
-- Interaction
--------------------------------------------------

local function toggle_tapemeasure(player)
    local stack = player.cursor_stack

    -- Check if player already has the tapemeasure in their hand
    if stack and stack.valid_for_read and stack.name == "pixel-tape-measure-capsule" then
        -- Player is holding the tape measure, close GUI and remove item
        stack.clear()
        destroy_gui(player)
    else
        -- Player is not holding the tape measure, initialize
        player.cursor_stack.set_stack({
            name = "pixel-tape-measure-capsule",
            count = 1
        })

        global.pixels = {
            gui = nil,
            points = {
                first = nil,
                second = nil
            },
            lines = nil,
            circle = nil
        }

        create_gui(player)
    end
end

local function process_measurement(e)
    -- Get some variables to work with
    local player = game.players[e.player_index]
    local x, y = e.position.x, e.position.y
    local pos = {
        x = x,
        y = y
    }

    -- Store the coordinates
    if global.pixels.points.second or not global.pixels.points.first then
        global.pixels.points.first = pos
        global.pixels.points.second = nil
    else
        global.pixels.points.second = pos
    end

    -- Update the GUI
    local gui = get_gui(player)
    local pt = gui.content_frame.position_table
    local dt = gui.content_frame.distance_table

    if global.pixels.points.first then
        -- Update GUI with absolute XY coordinates of first position
        pt.X_start.caption = pretty_format(global.pixels.points.first.x)
        pt.Y_start.caption = pretty_format(global.pixels.points.first.y)
    end

    if global.pixels.points.second then
        -- Update GUI with absolute XY coordinates of first position 
        pt.X_end.caption = pretty_format(global.pixels.points.second.x)
        pt.Y_end.caption = pretty_format(global.pixels.points.second.y)

        -- Calculate relative distances
        local dgrid = {
            x = global.pixels.points.second.x - global.pixels.points.first.x,
            y = global.pixels.points.second.y - global.pixels.points.first.y
        }
        dgrid.abs = math.sqrt(dgrid.x ^ 2 + dgrid.y ^ 2)

        local dpx = {
            x = dgrid.x * 32,
            y = dgrid.y * 32
        }
        dpx.abs = math.sqrt(dpx.x ^ 2 + dpx.y ^ 2)

        -- Update GUI with the delta
        dt.dX_grid.caption = pretty_format(dgrid.x)
        dt.dY_grid.caption = pretty_format(dgrid.y)
        dt.d_grid.caption = pretty_format(dgrid.abs)

        dt.dX_px.caption = pretty_format(dpx.x)
        dt.dY_px.caption = pretty_format(dpx.y)
        dt.d_px.caption = pretty_format(dpx.abs)

        -- Draw & store line
        -- Do some calculations upfront
        local xpos, first, second
        if global.pixels.points.first.x < global.pixels.points.second.x then
            first = global.pixels.points.first
            second = global.pixels.points.second
        else
            first = global.pixels.points.second
            second = global.pixels.points.first
        end

        local slope = (second.y - first.y) / (second.x - first.x)
        if (first.x == second.x) or slope > 0 then
            xpos = first.x
        else
            xpos = second.x
        end
        local ypos = math.max(global.pixels.points.first.y, global.pixels.points.second.y)

        -- Draw the lines, diagonal last to draw on top
        local liney = rendering.draw_line {
            color = {
                r = 0,
                g = 1,
                b = 0,
                a = 1
            },
            width = 2,
            from = {xpos, global.pixels.points.first.y},
            to = {xpos, global.pixels.points.second.y},
            surface = player.surface
        }
        local linex = rendering.draw_line {
            color = {
                r = 0,
                g = 0,
                b = 1,
                a = 1
            },
            width = 2,
            from = {global.pixels.points.first.x, ypos},
            to = {global.pixels.points.second.x, ypos},
            surface = player.surface
        }
        local lined = rendering.draw_line {
            color = {
                r = 1,
                g = 0,
                b = 0,
                a = 1
            },
            width = 2,
            from = global.pixels.points.first,
            to = global.pixels.points.second,
            surface = player.surface
        }
        global.pixels.lines = {lined, linex, liney}
    else
        -- Remove previous circle
        remove_circle()

        -- Reset GUI labels
        pt.X_end.caption = "?"
        pt.Y_end.caption = "?"

        dt.dX_grid.caption = "?"
        dt.dY_grid.caption = "?"
        dt.d_grid.caption = "?"

        dt.dX_px.caption = "?"
        dt.dY_px.caption = "?"
        dt.d_px.caption = "?"

        -- Draw & store starting point circle
        local circle = rendering.draw_circle {
            color = {
                r = 1,
                g = 1,
                b = 1,
                a = 1
            },
            radius = (4 / 32),
            width = 1,
            filled = false,
            target = global.pixels.points.first,
            surface = player.surface
        }
        global.pixels.circle = circle

        -- Remove lines because we don't have an end point
        remove_lines()
    end
end

--------------------------------------------------
-- Event handlers
--------------------------------------------------

script.on_event("pixel-tape-measure", function(e)
    local player = game.players[e.player_index]
    if not player then
        return
    end
    toggle_tapemeasure(player)
end)

script.on_event(defines.events.on_lua_shortcut, function(e)
    local player = game.players[e.player_index]
    if not player then
        return
    end
    if e.prototype_name == "pixel-tape-measure" then
        toggle_tapemeasure(player)
    end
end)

script.on_event(defines.events.on_player_used_capsule, function(e)
    local player = game.players[e.player_index]
    if not player then
        return
    end
    if e.item.name == "pixel-tape-measure-capsule" then
        process_measurement(e)
    end
end)

script.on_event(defines.events.on_player_cursor_stack_changed, function(e)
    -- Get player & cursor stack
    local player = game.players[e.player_index]
    if not player then
        return
    end
    local stack = player.cursor_stack

    -- Close GUI if player is no longer holding the tape measure
    if stack and stack.valid_for_read and stack.name == "pixel-tape-measure-capsule" then
        -- Player is now holding tape measure, do nothing
    else
        -- Close the GUI and remove any rules from the inventory
        destroy_gui(player)
        local inv = player.get_inventory(defines.inventory.character_main)
        while inv.get_item_count("pixel-tape-measure-capsule") > 0 do
            inv.remove("pixel-tape-measure-capsule")
        end
    end
end)
