class_name CameraComponent extends Node3D

@export var mouse_sensitivity: float = 0.002
@export var min_pitch: float = -90
@export var max_pitch: float = 90

@export var camera: Node3D
@export var entity: CharacterBody3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_input_component_on_camera_input_change(relative_motion: Vector2) -> void:
	if not entity or not camera or Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	# Rotate character horizontally
	entity.rotate_y(-relative_motion.x * mouse_sensitivity)
	
	camera.rotate_x(-relative_motion.y * mouse_sensitivity)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
