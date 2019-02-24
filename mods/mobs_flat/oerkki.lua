-- Oerkki by PilzAdam

mobs:register_mob("mobs_flat:oerkki", {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 2,
	damage = 2,
	hp_min = 8,
	hp_max = 32,
	armor = 100,
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.9, 0.4},
	visual = "upright_sprite",
	visual_size = {x=2, y=2},
	textures = {
		"mobs_flat_oerkki_front.png",
		"mobs_flat_oerkki_back.png",
	},
	makes_footstep_sound = false,
	sounds = {
		random = "mobs_oerkki",
	},
	walk_velocity = 0.5,
	run_velocity = 2,
	view_range = 5,
	jump = true,
	drops = {},
	water_damage = 2,
	lava_damage = 4,
	light_damage = 0,
	fear_height = 4,
	replace_rate = 5,
	replace_what = {"default:torch"},
	replace_with = "air",
	replace_offset = -1,
	floats = 1,
})

mobs:spawn({
	name = "mobs_flat:oerkki",
	nodes = {"default:stone", "default:cobble"},
	neighbors = {"default:stone_with_copper"},
	chance = 7,
	active_object_count = 8,
})

mobs:register_egg("mobs_flat:oerkki", "Oerkki", "default_coal_block.png", 1)
