ENTITY_IDS = {
    'healer',
    'tank',
    'testEnemy',
    'smallson'
}

ENTITY_DEFS = {
    ['healer'] = {
        name = 'healer',
        team = 'ALLY_TEAM',
        size = {
            x = TILE_SIZE * 0.6,
            y = TILE_SIZE * 0.6
        },
        animations = {
            ['idle'] = {
                frames = {1, 2, 3, 4},
                interval = 0.1,
                texture = 'tiles'
            },
            ['walk'] = {
                frames = {5, 6, 7, 8},
                interval = 0.1,
                texture = 'tiles'
            },
            
        },
        abilities = {
            ABILITY_DEFS["heal"],
            ABILITY_DEFS["smite"]
            -- Ability(ABILITY_DEFS["heal"]),
            -- Ability(ABILITY_DEFS["smite"]),
            -- Ability(ABILITY_DEFS["strike"]),
            -- Ability(ABILITY_DEFS["block"])
        },
        flipOffset = TILE_SIZE * 0.6,
        color = {0.25, 0.15, 0.5}
    },
    ['tank'] = {
        name = 'tank',
        team = 'ALLY_TEAM',
        size = {
            x = TILE_SIZE * 0.6,
            y = TILE_SIZE * 0.6
        },
        animations = {
            ['idle'] = {
                frames = {1},
                interval = 0.1,
                texture = 'ragebaby'
            },
            ['walk'] = {
                frames = {1},
                interval = 0.1,
                texture = 'ragebaby'
            }
        },
        abilities = {
            ABILITY_DEFS["strike"],
            ABILITY_DEFS["block"]
        },
        flipOffset = TILE_SIZE * 0.6,
        color = {32, 96, 64}
    },
    ['bigboy'] = {
        name = 'bigboy',
        size = {
            x = TILE_SIZE * 0.6,
            y = TILE_SIZE * 0.6
        },
        animations = {
            ['idle'] = {
                frames = {1},
                interval = 0.1,
                texture = 'ragebaby'
            },
            ['walk'] = {
                frames = {1},
                interval = 0.1, 
                texture = 'ragebaby'
            }
        },
        abilities = {
            ABILITY_DEFS["eat"],
            ABILITY_DEFS["barf"]
        },
        maxHealth = 3,
        flipOffset = TILE_SIZE * 0.6,
        color = {0.5, 0.125, 0.375},
        team = ALLY_TEAM
    },
    ['smallson'] = {
        name = 'smallson',
        team = ALLY_TEAM,
        size = {
            x = TILE_SIZE * 0.6,
            y = TILE_SIZE * 0.6
        },
        color = {0.5, 0.125, 0.25},
        abilities = {
        },
        animations = {
            ['idle'] = {
                frames = {1, 2, 3, 4},
                interval = 0.1,
                texture = 'tiles'
            },
            ['walk'] = {
                frames = {5, 6, 7, 8},
                interval = 0.1,
                texture = 'tiles'
            },
            
        },
        flipOffset = TILE_SIZE * 0.6,
        edible = true
    },
    ['testboy'] = {
        name = "testboy",
        team = NEUTRAL,
        size = {
            x = TILE_SIZE * 0.6,
            y = TILE_SIZE * 0.6
        },
        color = {0.125, 0.375, 0.5},
        animations = {
            ['idle'] = {
                frames = {1},
                interval = 0.1,
                texture = 'ragebaby'
            },
            ['walk'] = {
                frames = {1},
                interval = 0.1, 
                texture = 'ragebaby'
            }
        },
        abilities = {
            ABILITY_DEFS["eat"],
            ABILITY_DEFS["barf"]
        },
        flipOffset = TILE_SIZE * 0.6,
        states = {
            -- ChaseState(),
            -- PatrolState(),
            -- AttackState(),
            -- CastState()
        }
    }
}