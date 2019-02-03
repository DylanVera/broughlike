GAME_OBJECT_IDS ={
    "box"
}
GAME_OBJECT_DEFS = {
    ["switch"] = {
        type = "switch",
        texture = "switches",
        frame = 2,
        width = TILE_SIZE/3,
        height = TILE_SIZE/3,
        color = {0.75,0.25,0.75},
    },
    ["food"] = {
        type = "food",
        solid = true,
        color = {0.75, 0.125, 0.375},
        width = TILE_SIZE/4,
        height = TILE_SIZE/4
    }
}