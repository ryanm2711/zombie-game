extends ZombieState

var navmesh_map: RID

@onready var player: Player = GameManager.get_player()

func enter(_previous_state_path: String, _data := {}) -> void:
	if not navmesh_map and zombie.pathfinding_component:
		navmesh_map = zombie.pathfinding_component.navigation_agent_3d.get_navigation_map()
		
func update(_delta: float) -> void:
	if not zombie.move_component or not zombie.pathfinding_component or not navmesh_map or not player:
		return
		
	var player_pos = player.global_position
	zombie.pathfinding_component.set_target_position(player_pos)
