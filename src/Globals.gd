extends Node

# Globals used for controlling the behavoirs of the boids and hunters.
# This is attached to an auto-load/singleton scene so that these parameters
# can be shared across multiple scenes.

# boid settings
var Coherence = 0.0
var Seperation = 0.0
var Alignment = 0.0
var BoidSpeed = 0.0
var VisionRadius = 0.0

# hunter settings
var HunterCoherence = 0.0
var HunterSeperation = 0.0
var HunterAlignment = 0.0
var HunterSpeed = 0.0

# other settings
var MouseAttracts = false
var MouseAvoid = false
var MouseRadius = 0.0
var Looped = false

