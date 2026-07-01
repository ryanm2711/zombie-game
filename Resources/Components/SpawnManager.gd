class_name SpawnManager extends Node

@export var object_to_spawn: PackedScene

@export var spawn_points_node: Node

@export var max_objects: int = 5

var _spawn_count: int = 0
var _spawn_points: Array

var _last_used_spawn_point: Marker3D

func _ready() -> void:
	await owner.ready
	# Load all spawn points
	if spawn_points_node:
		for spawnPoint in spawn_points_node.get_children():
			_spawn_points.append(spawnPoint)
	else:
		push_error("[SPAWN MANAGER] Failed to load spawn points: Spawn points node not loaded in the inspector!")
		return
		
	for i in range(max_objects):
		spawn_object()

func pick_spawn_pos() -> Vector3:
	var marker3d := _last_used_spawn_point
	while marker3d == _last_used_spawn_point:
		marker3d = _spawn_points.pick_random() as Marker3D
		
	_last_used_spawn_point = marker3d
	var pos = marker3d.global_position
	
	return pos

func spawn_object():
	if not object_to_spawn:
		return
		
	var obj = object_to_spawn.instantiate() as Node3D
	add_child(obj)
	
	obj.global_position = pick_spawn_pos()
	
	_spawn_count += 1
