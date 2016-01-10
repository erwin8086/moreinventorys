minetest.register_craft({
	output = "moreinventorys:backpack",
	recipe = {
		{"group:wood", "", "group:wood"},
		{"group:wood", "moreinventorys:digable_chest", "group:wood"},
		{"group:wood", "", "group:wood"}
	}
})

minetest.register_craft({
	output = "moreinventorys:password_chest",
	recipe = {
		{"default:chest", "default:chest", "default:chest"},
		{"default:chest", "", "default:chest"},
		{"default:chest", "default:chest", "default:chest"},

	}
})

minetest.register_craft({
	output = "moreinventorys:digable_chest",
	recipe = {{"default:chest", "default:chest"}}
})

minetest.register_craft({
	output = "moreinventorys:player_chest",
	recipe = {{"moreinventorys:password_chest"}}
})