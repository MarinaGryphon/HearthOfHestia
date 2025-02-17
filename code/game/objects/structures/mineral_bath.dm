/obj/structure/mineral_bath
	name = "mineral bath"
	desc = "A deep, narrow basin filled with a swirling, semi-opaque liquid."
	icon = 'icons/obj/structures/mineral_bath.dmi'
	icon_state = "bath"
	anchored = TRUE
	density = TRUE
	opacity = FALSE
	var/mob/living/occupant

/obj/structure/mineral_bath/Destroy()
	eject_occupant()
	. = ..()

/obj/structure/mineral_bath/return_air()
	var/datum/gas_mixture/venus = new(CELL_VOLUME, SYNTH_HEAT_LEVEL_1 - 10)
	venus.adjust_multi(/decl/material/gas/chlorine, MOLES_N2STANDARD, /decl/material/gas/hydrogen, MOLES_O2STANDARD)
	return venus

/obj/structure/mineral_bath/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/grab))
		var/obj/item/grab/G = thing
		if(enter_bath(G.affecting))
			qdel(G)
		return
	. = ..()

/obj/structure/mineral_bath/proc/enter_bath(var/mob/living/patient, var/mob/user)

	if(!istype(patient))
		return FALSE

	var/self_drop = (user == patient)

	if(!user.Adjacent(src) || !(self_drop || user.Adjacent(patient)))
		return FALSE

	if(occupant)
		to_chat(user, "<span class='warning'>\The [src] is occupied.</span>")
		return FALSE

	if(self_drop)
		user.visible_message("<span class='notice'>\The [user] begins climbing into \the [src].</span>")
	else
		user.visible_message("<span class='notice'>\The [user] begins pushing \the [patient] into \the [src].</span>")

	if(!do_after(user, 3 SECONDS, src))
		return FALSE

	if(!user.Adjacent(src) || !(self_drop || user.Adjacent(patient)))
		return FALSE

	if(occupant)
		to_chat(user, "<span class='warning'>\The [src] is occupied.</span>")
		return FALSE

	if(self_drop)
		user.visible_message("<span class='notice'>\The [user] climbs into \the [src].</span>")
	else
		user.visible_message("<span class='notice'>\The [user] pushes \the [patient] into \the [src].</span>")

	playsound(loc, 'sound/effects/slosh.ogg', 50, 1)
	patient.forceMove(src)
	occupant = patient
	START_PROCESSING(SSobj, src)
	return TRUE

/obj/structure/mineral_bath/attack_hand(var/mob/user)
	eject_occupant()

/obj/structure/mineral_bath/proc/eject_occupant()
	if(occupant)
		occupant.dropInto(loc)
		playsound(loc, 'sound/effects/slosh.ogg', 50, 1)
		if(occupant.loc != src)
			if(occupant.client)
				occupant.client.eye = occupant.client.mob
				occupant.client.perspective = MOB_PERSPECTIVE
			occupant.update_icon()
			occupant = null
			STOP_PROCESSING(SSobj, src)

/obj/structure/mineral_bath/receive_mouse_drop(var/atom/dropping, var/mob/user)
	. = ..()
	if(!. && ismob(dropping))
		enter_bath(dropping, user)
		return TRUE

/obj/structure/mineral_bath/relaymove(var/mob/user)
	if(user == occupant)
		eject_occupant()

/obj/structure/mineral_bath/Process()

	if(!occupant)
		STOP_PROCESSING(SSobj, src)
		return

	if(occupant.loc != src)
		occupant = null
		STOP_PROCESSING(SSobj, src)
		return

	if(ishuman(occupant))

		var/mob/living/carbon/human/H = occupant
		var/repaired_organ

		// Replace limbs for crystalline species.
		if(H.species.is_crystalline && prob(10))
			for(var/limb_type in H.species.has_limbs)
				var/obj/item/organ/external/E = H.get_organ(limb_type)
				if(E && !E.is_usable() && !(E.limb_flags & ORGAN_FLAG_HEALS_OVERKILL))
					H.remove_organ(E)
					qdel(E)
					E = null
				if(!E)
					var/list/organ_data = H.species.has_limbs[limb_type]
					var/limb_path = organ_data["path"]
					var/obj/item/organ/O = new limb_path(H)
					organ_data["descriptor"] = O.name
					H.species.post_organ_rejuvenate(O, H)
					to_chat(occupant, "<span class='notice'>You feel your [O.name] reform in the crystal bath.</span>")
					H.update_body()
					repaired_organ = TRUE
					break

		// Repair crystalline internal organs.
		if(prob(10))
			for(var/obj/item/organ/internal/I in H.get_internal_organs())
				if(BP_IS_CRYSTAL(I) && I.damage)
					I.heal_damage(rand(3,5))
					if(prob(25))
						to_chat(H, "<span class='notice'>The mineral-rich bath mends your [I.name].</span>")

		// Repair robotic external organs.
		if(!repaired_organ && prob(25))
			for(var/obj/item/organ/external/E in H.get_external_organs())
				if(BP_IS_PROSTHETIC(E))
					for(var/obj/implanted_object in E.implants)
						if(!istype(implanted_object,/obj/item/implant) && !istype(implanted_object,/obj/item/organ/internal/augment) && prob(25))	// We don't want to remove REAL implants. Just shrapnel etc.
							LAZYREMOVE(E.implants, implanted_object)
							to_chat(H, "<span class='notice'>The mineral-rich bath dissolves the [implanted_object.name].</span>")
							qdel(implanted_object)
					if(E.brute_dam || E.burn_dam)
						E.heal_damage(rand(3,5), rand(3,5), robo_repair = 1)
						if(prob(25))
							to_chat(H, "<span class='notice'>The mineral-rich bath mends your [E.name].</span>")
						if(!BP_IS_CRYSTAL(E) && !BP_IS_BRITTLE(E))
							E.status |= ORGAN_BRITTLE
							to_chat(H, "<span class='warning'>It feels a bit brittle, though...</span>")
						break
