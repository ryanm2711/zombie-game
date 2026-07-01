class_name Zombie extends CharacterBody3D

@export_subgroup("Behaviours")
@export var move_component: MoveComponent
@export var health_component: HealthComponent
@export var pathfinding_component: PathfindingComponent

var speed: float = 5.0

func _ready() -> void:
	if move_component:
		move_component.current_speed = speed

func _on_pathfinding_change(currentPos: Vector3, nextPos: Vector3) -> void:
	if not move_component:
		return
	
	var direction = currentPos.direction_to(nextPos)
	move_component.set_movement_direction(direction)
