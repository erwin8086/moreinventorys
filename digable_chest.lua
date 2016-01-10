if minetest.get_modpath("intllib") then
		S = intllib.Getter()
	else
		S = function(s) return s end
end

minetest.register_node("moreinventorys:digable_chest", {
	tiles = {"default_chest_top.png", "default_chest_top.png", "default_chest_side.png",
		"default_chest_side.png", "default_chest_side.png", "default_chest_front.png"},
	groups = {choppy=2},
	stack_max=1,
	description = S("Digable Chest"),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 32)
		meta:set_string("formspec", "size[8,9]"..
			"list[context;main;0,0;8,4]"..
			"list[current_player;main;0,5;8,4]")

	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if stack:get_name()=="moreinventorys:digable_chest" then
			return 0
		end
		if stack:get_name()=="moreinventorys:backpack" then
			return 0
		end
		return stack:get_count()
	end,

	after_place_node = function(pos, placer, itemstack, pt)
		local meta = minetest.get_meta(pos)
		if itemstack:get_metadata() ~= nil and itemstack:get_metadata() ~= "" then
			local tmeta = meta:to_table()
			tmeta.inventory.main = minetest.deserialize(itemstack:get_metadata())
			meta:from_table(tmeta)
			local inv = meta:get_inventory()
			inv:set_size("main", 32)
		end
	end,	

	on_dig = function(pos, node, player)
		local pinv = player:get_inventory()
		local stack = ItemStack("moreinventorys:digable_chest")
		local meta = minetest.get_meta(pos)
		if pinv:room_for_item("main", stack) then
			local tmeta = meta:to_table()
			if tmeta.inventory.main == nil then
				return
			end
			for x=1,32 do
				if tmeta.inventory.main[x] ~= nil then
					tmeta.inventory.main[x] = tmeta.inventory.main[x]:to_table()
				end
			end
			stack:set_metadata(minetest.serialize(tmeta.inventory.main))
			pinv:add_item("main", stack)
			minetest.remove_node(pos)
		end
	end,
})