extends ZombieState

@export var min_wander_distance: float = 10.0
@export var max_wander_distance: float = 25.0

var current_target_pos := Vector3.ZERO
var navmesh_map: RID

func enter(_previous_state_path: String, _data := {}) -> void:
	if not navmesh_map:
		navmesh_map = zombie.pathfinding_component.navigation_agent_3d.get_navigation_map()

func get_random_pos() -> Vector3:
	var rndPos := NavigationServer3D.map_get_random_point(navmesh_map, 1, true)
	while rndPos.distance_to(zombie.global_position) < min_wander_distance or rndPos.distance_to(zombie.global_position) > max_wander_distance:
		rndPos = NavigationServer3D.map_get_random_point(navmesh_map, 1, true)
		
	return rndPos
	

func update(_delta: float) -> void:
	if not zombie.move_component or not zombie.pathfinding_component or not navmesh_map:
		return
	
	if zombie.pathfinding_component.navigation_agent_3d.is_navigation_finished():
		var rndPos = get_random_pos()
		zombie.pathfinding_component.set_target_position(rndPos)
