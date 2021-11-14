//	Observer Pattern Implementation: Ungrabbed
//		Registration type: /atom/movable
//
//		Raised when: A grab on an /atom/movable instance has been released by a mob.
//
//		Arguments that the called proc should expect:
//			/atom/movable/released_instance: The instance that was formerly grabbed.
//			/mob/assailant: Whoever was grabbing the instance.

/decl/observ/ungrabbed
	name = "Grab Released"
	expected_type = /atom/movable
	flags = OBSERVATION_NO_GLOBAL_REGISTRATIONS