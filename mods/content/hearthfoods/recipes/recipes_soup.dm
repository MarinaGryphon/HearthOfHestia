/decl/recipe/onionsoup
	appliance = SAUCEPAN | POT
	fruit = list("onion" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	result = /obj/item/chems/food/onionsoup

/decl/recipe/goulash
	appliance = SAUCEPAN | POT
	fruit = list("tomato" = 1)
	reagents = list(/decl/material/liquid/water = 5)
	items = list(
		/obj/item/chems/food/cutlet,
		/obj/item/chems/food/spagetti
	)
	result = /obj/item/chems/food/goulash

/decl/recipe/hotandsoursoup
	appliance = SAUCEPAN | POT
	fruit = list("cabbage" = 1, "mushroom" = 1)
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 2, /decl/material/solid/blackpepper = 2, /decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/tofu
	)
	result = /obj/item/chems/food/hotandsoursoup