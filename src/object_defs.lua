GAME_OBJECT_IDS ={
    "box"
}
GAME_OBJECT_DEFS = {
    ["box"] = {
        type = "switch",
        texture = "switches",
        frame = 2,
        width = TILE_SIZE/3,
        height = TILE_SIZE/3,
        solid = true,
        pushable = true,
        color = {196,64,196},
    },
    food = {
        type = "food",
        solid = true,
        color = {196, 32, 96},
        width = TILE_SIZE/4,
        height = TILE_SIZE/4
    }
}