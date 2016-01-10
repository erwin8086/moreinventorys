if minetest.get_modpath("intllib") then
		S = intllib.Getter()
	else
		S = function(s) return s end
end

local save_inbox = function(name, inv)
	local filename = minetest.get_worldpath().."/moreinventorys_inbox_"..name
	local file = io.open(filename, "w")
	local list = inv:get_list(name)
	for x=1,32 do
		list[x] = list[x]:to_table()
	end
	file:write(minetest.serialize(list))
	file:close()
end

local load_inbox = function(name, inv)
	local filename = minetest.get_worldpath().."/moreinventorys_inbox_"..name
	local file = io.open(filename, "r")
	inv:set_size(name, 32)
	if file ~= nil then
		inv:set_list(name, minetest.deserialize(file:read()))
		file:close()
	end
end

local inv = minetest.create_detached_inventory("moreinventorys_inbox", {
	allow_move = function(inv, from_list, from_index, to_list, to_index, count, player) 
		return 0
	end,
	allow_put = function(inv, listname, index, stack, player) 
		return 0
	end,
	on_take = function(inv, listname, index, stack, player) 
		save_inbox(listname, inv)
	end,

})

local send = minetest.create_detached_inventory("moreinventorys_send", {
	allow_take = function(inv, listname, index, stack, player) 
		return 0
	end,
	allow_move = function(inv, from_list, from_index, to_list, to_index, count, player) 
		return 0
	end,
	on_put = function(sinv, listname, index, stack, player) 
		if inv:room_for_item(listname, stack) then
			inv:add_item(listname, stack)
			sinv:set_stack(listname, 1, nil)
			save_inbox(listname, inv)
		else
			local pinv = player:get_inventory()
			pinv:add_item("main", stack)
		end
		
	end,

})

minetest.register_on_joinplayer(function(player)
	load_inbox(player:get_player_name(),inv)
end)

minetest.register_chatcommand("inbox", {
	params = "",
	description = S("Open the INBOX"),
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false
		end
		minetest.show_formspec(name, "moreinventorys:inbox", "size[8,9]"..
			"list[detached:moreinventorys_inbox;"..name..";0,0;8,4;]"..
			"list[current_player;main;0,5;8,4;]")
	end,
})

minetest.register_chatcommand("send", {
	params = "<player>",
	description = S("Send Stuff to players INBOX."),
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false
		end
		if param:match("%W") then
			minetest.chat_send_player(name, "Error only a_zA_Z0_9 allowed in player name")
		end
		load_inbox(name, inv)
		send:set_size(name, 1)
		minetest.show_formspec(name, "moreinventorys:inbox", "size[8,9]"..
			"list[detached:moreinventorys_send;"..param..";0,0;1,1;]"..
			"list[current_player;main;0,5;8,4;]")
	end,
})

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >=15 then
		for _,player in ipairs(minetest.get_connected_players()) do
			local name = player:get_player_name()
			if not inv:is_empty(name) then
				minetest.chat_send_player(name, S("You have post. use /inbox to check."))
			end
		end
		timer=0
	end
end)

