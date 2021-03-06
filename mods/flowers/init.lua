-- Minetest 0.4 mod: default
-- See README.txt for licensing and other information.

-- Load support for MT game translation.
local S = minetest.get_translator("flowers")

flowers = {}
-- Map Generation
dofile(minetest.get_modpath("flowers").."/mapgen.lua")

-- Register dungeon loot
if minetest.global_exists("dungeon_loot") then
	dungeon_loot.register({
		name = "flowers:mushroom_brown", chance = 0.3, count = {1, 6},
		name = "flowers:mushroom_red", chance = 0.3, count = {1, 6},
	})
end

-- Aliases for original flowers mod
minetest.register_alias("flowers:flower_dandelion_white", "flowers:dandelion_white")
minetest.register_alias("flowers:flower_dandelion_yellow", "flowers:dandelion_yellow")
minetest.register_alias("flowers:flower_geranium", "flowers:geranium")
minetest.register_alias("flowers:flower_rose", "flowers:rose")
minetest.register_alias("flowers:flower_tulip", "flowers:tulip")
minetest.register_alias("flowers:flower_viola", "flowers:viola")

flowers.flowers = {
--	flower name,		desc,			groups
	{"dandelion_white",	S("White Dandelion"),	{flower=1, flora=1, color_white=1}},
	{"dandelion_yellow",	S("Yellow Dandelion"),	{flower=1, flora=1, color_yellow=1}},
	{"geranium",		S("Blue Geranium"),	{flower=1, flora=1, color_blue=1}},
	{"rose",		S("Rose"),			{flower=1, flora=1, color_red=1}},
	{"tulip",		S("Tulip"),		{flower=1, flora=1, color_orange=1}},
	{"viola",		S("Viola"),		{flower=1, flora=1, color_violet=1}},
}

-- Flowers
for _, row in ipairs(flowers.flowers) do
	local name = row[1]
	local desc = row[2]
	local groups = row[3]
	groups.dig_immediate = 3
	groups.flammable = 2
	groups.falling_node = 1
	minetest.register_node("flowers:"..name, {
		description = desc,
		drawtype = "torchlike",
		tiles = {"flowers_"..name..".png"},
		use_texture_alpha = "clip",
		inventory_image = "flowers_"..name..".png",
		wield_image = "flowers_"..name..".png",
		sunlight_propagates = true,
		paramtype = "light",
		walkable = false,
		buildable_to = true,
		floodable = true,
		groups = groups,
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = { -0.25, -0.5, -0.25, 0.25, 0.25, 0.25},
		},
	})
end

minetest.register_craft({
	type = "fuel",
	recipe = "group:flowers",
	burntime = 1,
})

flowers.mushrooms = {
--	name,			desc,			desc spores,			groups,		hp change
	{"mushroom_brown",	S("Brown Mushroom"),	S("Brown Mushroom Spores"),	{fungi=1},	1},
	{"mushroom_red",	S("Red Mushroom"),	S("Red Mushroom Spores"),	{fungi=1},	-1},
}

-- Mushrooms
for _, row in ipairs(flowers.mushrooms) do
	local name = row[1]
	local desc = row[2]
	local desc_spores = row[3]
	local groups = row[4]
	local hp = row[5]
	groups.dig_immediate = 3
	groups.flammable = 2
	groups.falling_node = 1
	minetest.register_node("flowers:"..name, {
		description = desc,
		drawtype = "plantlike",
		tiles = {"flowers_"..name..".png"},
		use_texture_alpha = "clip",
		inventory_image = "flowers_"..name..".png",
		wield_image = "flowers_"..name..".png",
		sunlight_propagates = true,
		paramtype = "light",
		walkable = false,
		buildable_to = true,
		floodable = true,
		groups = groups,
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = { -0.25, -0.5, -0.25, 0.25, 0.25, 0.25},
		},
	on_use = minetest.item_eat(hp),
	after_dig_node = function(pos, node, metadata, digger)
		if node.param2 ~= 1 then
			minetest.add_node(pos, {name="flowers:"..name.."_spores"})
		end
	end,
	on_timer = function(pos)
		local node = minetest.get_node(pos)
		if node.param2 ~= 1 then return true end
		node.param2 = nil
		minetest.set_node(pos, node)
	end,
	after_place_node = function(pos)
		minetest.add_node(pos, {name="flowers:"..name, param2=1})
		minetest.get_node_timer(pos):start(math.random(6000,48000))
	end,
	})

	minetest.register_node("flowers:"..name.."_spores", {
		description = desc_spores,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -0.5 + (1 / 16), 0.5}
		},
		tiles = {"flowers_"..name.."_spores.png"},
		use_texture_alpha = "clip",
		inventory_image = "flowers_"..name.."_spores.png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		floodable = true,
		groups = {snappy = 3, attached_node = 1},
		drop = "",
		sounds = default.node_sound_leaves_defaults(),
		on_timer = function(pos)
			local node_under = minetest.get_node_or_nil({x = pos.x, y = pos.y - 1, z = pos.z})
			if minetest.get_item_group(node_under.name, "soil") == 0 then
				minetest.remove_node(pos)
			else
				minetest.set_node(pos, {name="flowers:"..name})
			end
		end,
		on_construct = function(pos)
			minetest.get_node_timer(pos):start(math.random(6000,48000))
		end,
	})
end
