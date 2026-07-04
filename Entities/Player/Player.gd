class_name Player extends CharacterBody3D

@export var input_component: InputComponent
@export var movement_component: MoveComponent
@export var camera_component: CameraComponent
@export var combat_component: CombatComponent

var is_dead: bool = false

func _ready() -> void:
	GameManager.register_player(self)
	
	if movement_component and input_component:
		input_component.on_movement_input_change.connect(movement_component._on_input_component_on_movement_input_change)
			
	if camera_component and input_component:
		input_component.on_camera_input_change.connect(camera_component._on_input_component_on_camera_input_change)
	
	if combat_component:
		input_component.attack_pressed.connect(combat_component.press_trigger)
		input_component.attack_released.connect(combat_component.release_trigger)
		
func _exit_tree() -> void:
	GameManager.unregister_player()


func _on_player_death(entity: Node3D) -> void:
	is_dead = true
