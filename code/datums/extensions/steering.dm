// Steerable handling
/datum/movement_handler/mob/steering/DoMove(var/direction, var/mover)
	var/datum/extension/steering/steerer = get_extension(mover, /datum/extension/steering)
	var/atom/movable/steerable = steerer.get_steerable()
	if(!steerer)
		return MOVEMENT_REMOVE
	if(!steerer.can_steer() || !istype(steerable))
		remove_extension(steerer, /datum/extension/steering)
		return MOVEMENT_REMOVE
	// Steerables can only be moved in the direction they're 'facing' relative to the steerer.
	// You can also turn them 45 degrees.
	var/turf/dest_turf = get_step(mover, direction)
	if(direction & get_dir(mover, steerable))
		// If the steerable manages to move, we move the steerer too.
		return steerable.Move(null, direction) ? MOVEMENT_PROCEED : MOVEMENT_HANDLED
	// We need to turn before we can move it.
	steerable.Move(get_step_to(steerable, dest_turf))
	return MOVEMENT_HANDLED

/datum/extension/steering
	base_type = /datum/extension/steering
	expected_type = /mob
	flags = EXTENSION_FLAG_IMMEDIATE
	var/datum/extension/steerable/steerable_extension

/datum/extension/steering/New(mob/holder, datum/extension/steerable/_steerable_extension)
	. = ..()
	steerable_extension = _steerable_extension

/datum/extension/steering/proc/get_steerable()
	return steerable_extension?.holder

/datum/extension/steering/proc/can_steer()
	var/atom/steerable = get_steerable()
	var/mob/steerer = holder
	if(!steerer.Adjacent(steerable))
		return FALSE
	return FALSE

/datum/extension/steerable
	base_type = /datum/extension/steerable
	expected_type = /atom/movable
	flags = EXTENSION_FLAG_IMMEDIATE
	var/mob/current_steerer
	var/hands_required = 2

/datum/extension/steerable/New(datum/holder, _hands_required = 2)
	. = ..()
	hands_required = _hands_required
	events_repository.register(/decl/observ/grabbed, holder, .proc/on_grabbed)
	events_repository.register(/decl/observ/ungrabbed, holder, .proc/on_released)

/datum/extension/steerable/proc/grab_check(mob/steerer)
	var/grab_count = 0
	var/atom/movable/steerable = holder
	for(var/obj/item/grab/G in steerable.grabbed_by)
		if(G.assailant == steerer && ++grab_count >= hands_required)
			return steerer
	return FALSE

/datum/extension/steerable/proc/on_grabbed(mob/grabber)
	if(!QDELETED(current_steerer))
		// We're already being steered.
		// TODO: Implement mechanics for stealing it from someone's grip.
		// Maybe defer to whoever has the most grabs on it?
		// What about ties?
		return
	start_steering(grab_check(grabber))

/datum/extension/steerable/proc/on_released(mob/steerer)
	if(!istype(current_steerer) || QDELETED(current_steerer))
		// We're not being steered, so we don't care about this event.
		return
	if(grab_check(steerer))
		// We're still being steered.
		return
	stop_steering()

/datum/extension/steerable/proc/start_steering(mob/steerer)
	if(!istype(steerer) || QDELETED(steerer))
		return FALSE
	var/datum/extension/steering/steering_extension = get_extension(steerer, /datum/extension/steering)
	var/atom/movable/already_steering = steering_extension?.get_steerable()
	if(already_steering)
		to_chat(steerer, SPAN_WARNING("You're already steering \the [already_steering]!"))
		return FALSE
	var/atom/movable/steerable = holder
	current_steerer = steerer
	to_chat(steerer, SPAN_NOTICE("You start steering \the [steerable]."))
	set_extension(current_steerer, /datum/extension/steering, src)
	events_repository.register(/decl/observ/destroyed, current_steerer, .proc/stop_steering)
	current_steerer.AddMovementHandler(/datum/movement_handler/mob/steering) // will be added first

/datum/extension/steerable/Destroy()
	stop_steering()
	events_repository.unregister(/decl/observ/grabbed, holder, .proc/on_grabbed)
	events_repository.unregister(/decl/observ/ungrabbed, holder, .proc/on_released)
	. = ..()

/datum/extension/steerable/proc/stop_steering()
	if(!QDELETED(current_steerer))
		var/datum/extension/steering/steering_extension = get_extension(current_steerer, /datum/extension/steering)
		qdel(steering_extension)
		current_steerer.RemoveMovementHandler(/datum/movement_handler/mob/steering)
		events_repository.unregister(/decl/observ/destroyed, current_steerer, .proc/stop_steering)
	current_steerer = null
