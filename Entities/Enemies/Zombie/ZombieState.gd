class_name ZombieState extends State

const IDLE = "States/Idle"
const CHASING = "States/Chase"
const WANDERING = "States/Wander"
const ATTACKING = "States/Attack"

var zombie: Zombie

func _ready() -> void:
	await owner.ready
	zombie = owner as Zombie
	assert(zombie != null, "The ZombieState state type must be used only in the zombie scene. It needs the owner to be a Player node.")
