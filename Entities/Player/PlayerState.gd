class_name PlayerState extends State

const IDLE = "States/Idle"
const RUNNING = "States/Running"
const SPRINTING = "States/Sprinting"
const CROUCHING = "States/Crouching"
const PRONE = "States/Prone"
const JUMPING = "States/Jumping"
const FALLING = "States/Falling"

var player: Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")
