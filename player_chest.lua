if minetest.get_modpath("intllib") then
		S = intllib.Getter()
	else
		S = function(s) return s end
end

minetest.register_on_joinplayer(function(player)
	local inv = player:get_inventory()
	inv:set_size("moreinventorys_player_chest",32)
end)

minetest.register_node("moreinventorys:player_chest", {
	description = S("Player Chest"),
	tiles = {"default_chest_top.png", "default_chest_top.png", "default_chest_side.png",
		"default_chest_side.png", "default_chest_side.png", "default_chest_front.png"},	
	
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", "size[8,9]"..
			"list[current_player;moreinventorys_player_chest;0,0;8,4;]"..
			"list[current_player;main;0,5;8,4;]")
	end,
})

	