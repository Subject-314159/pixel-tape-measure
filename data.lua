-- Shortcuts & tools
data:extend({{
    type = "custom-input",
    name = "pixel-tape-measure",
    action = "lua",
    key_sequence = "CONTROL + SHIFT + M",
    order = "a"
}, {
    type = "shortcut",
    name = "pixel-tape-measure",
    action = "lua",
    icon = {
        filename = "pixel-tape-measure/graphics/icons/ruler.png",
        size = 64
    }
}, {
    type = "selection-tool",
    name = "pixel-tape-measure-tool",
    icon = "pixel-tape-measure/graphics/icons/ruler.png",
    icon_size = 64,
    flags = {"only-in-cursor", "hidden", "spawnable", "not-stackable"},
    stack_size = 1,
    selection_mode = "nothing",
    alt_selection_mode = "nothing",
    selection_color = {255, 0, 0},
    alt_selection_color = {255, 0, 0},
    selection_cursor_box_type = "blueprint-snap-rectangle",
    alt_selection_cursor_box_type = "blueprint-snap-rectangle"
}, {
    type = "capsule",
    name = "pixel-tape-measure-capsule",
    icon = "pixel-tape-measure/graphics/icons/ruler.png",
    icon_size = 64,
    stack_size = 1,
    radius_color = {0, 0, 0, 0},
    capsule_action = {
        type = "throw",
        uses_stack = false,
        attack_parameters = {
            type = "projectile",
            range = 2147483647,
            cooldown = 30,
            ammo_category = "melee",
            ammo_type = {
                category = "melee"
            }
        }
    }
}})

-- GUI styles
local styles = data.raw["gui-style"].default

styles["content_frame"] = {
    type = "frame_style",
    parent = "inside_shallow_frame_with_padding",
    vertically_stretchable = "on"
}

styles["position_table"] = {
    type = "table_style",
    left_margin = 0,
    top_margin = 1,
    right_margin = 0,
    bottom_margin = 20,
    left_padding = 1,
    top_padding = 1,
    right_padding = 1,
    bottom_padding = 1,
    left_cell_padding = 3,
    top_cell_padding = 1,
    right_cell_padding = 3,
    bottom_cell_padding = 1,
    vertical_spacing = 1,
    horizontal_spacing = 1,
    horizontally_stretchable = "on"
}

styles["label_in_table"] = {
    type = "label_style",
    width = 100,
    minimal_height = 10,
    horizontal_align = "center"
}

styles["label_in_table_first"] = {
    type = "label_style",
    width = 50,
    minimal_height = 10
}
