local count=0
local inv = minetest.create_detached_inventory("moreinventorys_backpack", {
	allow_move = function(inv, form_list, from_index, to_list, to_index, count, player)
		return count
	end,

	allow_put = function(inv, listname, index, stack, player)
		if stack:get_name()=="moreinventorys:backpack" then
			return 0
		end
		if stack:get_name()=="moreinventorys:digable_chest" then
			return 0
		end
		return stack:get_count()
	end, 
	allow_take = function(inv, listname, index, stack, player) 
		return stack:get_count()
	end,
	on_move = function(inv, from_list, from_index, to_list, to_index, count, player) 
		if from_list==to_list then
			local stack = player:get_wielded_item()
			local list = inv:get_list(to_list)
			for x=1,32 do
				list[x] = list[x]:to_table()
			end
			stack:set_metadata(minetest.serialize(list))
			player:set_wielded_item(stack)
		end
	end,

 	on_put = function(inv, listname, index, stack, player) 
		local stack = player:get_wielded_item()
		local list = inv:get_list(listname)
		for x=1,32 do
			list[x] = list[x]:to_table()
		end
		stack:set_metadata(minetest.serialize(list))
		player:set_wielded_item(stack)
	end,
	on_take = function(inv, listname, index, stack, player) 
		local stack = player:get_wielded_item()
		local list = inv:get_list(listname)
		for x=1,32 do
			list[x] = list[x]:to_table()
		end
		stack:set_metadata(minetest.serialize(list))
		player:set_wielded_item(stack)
	end,

})
minetest.register_craftitem("moreinventorys:backpack", {
	description = "Backpack",
	stack_max=1,
	inventory_image = "default_chest_front.png",
	on_use = function(stack, user, pt)
		local list = tostring(count)
		count=count+1
		inv:set_size(list, 32)
		if stack:get_metadata() ~= nil and stack:get_metadata() ~= "" then
			inv:set_list(list, minetest.deserialize(stack:get_metadata()))
		end
		minetest.show_formspec(user:get_player_name(), "moreinventorys:backpack", "size[8,9]"..
			"list[detached:moreinventorys_backpack;"..list..";0,0;8,4;]"..
			"list[current_player;main;0,5;8,4;]")
	end,
})