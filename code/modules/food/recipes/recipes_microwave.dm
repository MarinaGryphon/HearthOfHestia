/decl/recipe/loadedbakedpotato
	appliance = MICROWAVE|OVEN
	fruit = list("potato" = 1)
	items = list(/obj/item/chems/food/cheesewedge)
	result = /obj/item/chems/food/loadedbakedpotato

/decl/recipe/cheesyfries
	appliance = MICROWAVE|SKILLET
	items = list(
		/obj/item/chems/food/fries,
		/obj/item/chems/food/cheesewedge,
	)
	result = /obj/item/chems/food/cheesyfries

/decl/recipe/popcorn
	appliance = MICROWAVE|SAUCEPAN|POT
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 5)
	fruit = list("corn" = 1)
	result = /obj/item/chems/food/popcorn

/decl/recipe/plainsteak
	appliance = MICROWAVE|SKILLET
	items = list(/obj/item/chems/food/meat)
	result = /obj/item/chems/food/plainsteak

/decl/recipe/meatsteak
	appliance = MICROWAVE|SKILLET
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(/obj/item/chems/food/cutlet)
	result = /obj/item/chems/food/meatsteak

/decl/recipe/loadedsteak
	appliance = MICROWAVE|SKILLET
	reagents = list(/decl/material/liquid/nutriment/garlicsauce = 5)
	fruit = list("onion" = 1, "mushroom" = 1)
	items = list(/obj/item/chems/food/cutlet)
	result = /obj/item/chems/food/loadedsteak

/decl/recipe/syntisteak
	appliance = MICROWAVE|SKILLET
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(/obj/item/chems/food/meat/syntiflesh)
	result = /obj/item/chems/food/meatsteak/synthetic

/decl/recipe/rofflewaffles
	appliance = MICROWAVE
	reagents = list(/decl/material/liquid/psychotropics = 5, /decl/material/liquid/nutriment/batter/cakebatter = 20)
	reagent_mix = REAGENT_REPLACE // no raw batter
	result = /obj/item/chems/food/rofflewaffles

/decl/recipe/boiledrice
	appliance = MICROWAVE|SAUCEPAN|POT
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/nutriment/rice = 10)
	reagent_mix = REAGENT_REPLACE // remove the water
	result = /obj/item/chems/food/boiledrice

/decl/recipe/pastatomato
	appliance = MICROWAVE|SAUCEPAN|POT
	fruit = list("tomato" = 2)
	reagents = list(/decl/material/liquid/water = 10)
	items = list(/obj/item/chems/food/spagetti)
	reagent_mix = REAGENT_REPLACE // get that water outta here
	result = /obj/item/chems/food/pastatomato

/decl/recipe/meatballspagetti
	appliance = MICROWAVE|SAUCEPAN|POT
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/spagetti,
		/obj/item/chems/food/meatball = 2,
	)
	reagent_mix = REAGENT_REPLACE // get that water outta here
	result = /obj/item/chems/food/meatballspagetti

/decl/recipe/spesslaw
	appliance = MICROWAVE|SAUCEPAN|POT
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/spagetti,
		/obj/item/chems/food/meatball = 4,
	)
	reagent_mix = REAGENT_REPLACE // get that water outta here
	result = /obj/item/chems/food/spesslaw

/decl/recipe/nanopasta
	appliance = MICROWAVE|SAUCEPAN|POT
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/spagetti,
		/obj/item/stack/nanopaste
	)
	reagent_mix = REAGENT_REPLACE // get that water outta here
	result = /obj/item/chems/food/nanopasta