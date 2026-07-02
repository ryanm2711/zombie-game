extends ZombieState

var navmesh_map: RID

@export var player_pos_update_cooldown: float = 0.3

@onready var player: Player = GameManager.get_player()

var _attack_ray_cast: RayCast3D
var _time_since_last_player_pos_update: float = 0.0

func enter(_previous_state_path: String, _data := {}) -> void:
	if not navmesh_map and zombie.pathfinding_component:
		navmesh_map = zombie.pathfinding_component.navigation_agent_3d.get_navigation_map()
		
	if not _attack_ray_cast:
		var ray = zombie.get_node_or_null("AttackRayCast") as RayCast3D
		if ray != null:
			_attack_ray_cast = ray
		
func update(_delta: float) -> void:
	if not zombie.move_component or not zombie.pathfinding_component or not navmesh_map or not player:
		return
	
	_check_if_attacking_range()
	_update_target_location(_delta)

func _update_target_location(_delta: float) -> void:
	_time_since_last_player_pos_update += _delta
	if _time_since_last_player_pos_update >= player_pos_update_cooldown:
		_time_since_last_player_pos_update = 0.0
		
		var player_pos = player.global_position
		zombie.pathfinding_component.set_target_position(player_pos)
		
func _check_if_attacking_range() -> void:
	if not _attack_ray_cast:
		return
		
	if _attack_ray_cast.is_colliding():
		finished.emit(ATTACKING)
		return
