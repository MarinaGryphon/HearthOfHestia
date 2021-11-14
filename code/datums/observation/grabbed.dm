//	Observer Pattern Implementation: Grabbed
//		Registration type: /atom/movable
//
//		Raised when: An /atom/movable instance has been grabbed by a mob.
//
//		Arguments that the called proc should expect:
//			/atom/movable/grabbed_instance: The instance that was grabbed.
//			/mob/assailant: Whoever grabbed the instance.
//			/obj/item/grab/grab: The grab object.

/decl/observ/grabbed
	name = "Grabbed"
	expected_type = /atom/movable
	flags = OBSERVATION_NO_GLOBAL_REGISTRATIONS