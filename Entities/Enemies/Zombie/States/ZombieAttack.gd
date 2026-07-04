extends ZombieState

@export var attack_ray_cast: RayCast3D
@export var attack_damage: float = 30.0
@export var attack_windup_time: float = 0.3
@export var attack_cooldown: float = 1.2

var _attack_timer: float = 0.0
var _has_damaged_this_swing: bool = false

func enter(_previous_state_path: String, _data := {}) -> void:
	_attack_timer = 0.0
	_has_damaged_this_swing = false
	
	if zombie.move_component:
		zombie.move_component.set_movement_direction(Vector3.ZERO)
		
func update(_delta: float) -> void:
	_attack_timer += _delta
	
	if zombie.move_component:
		zombie.move_component.set_movement_direction(Vector3.ZERO)
	
	if _attack_timer >= attack_windup_time and not _has_damaged_this_swing:
		_attack()
		
	if _attack_timer >= attack_cooldown:
		finished.emit(CHASING)

func _attack() -> void:	
	if not attack_ray_cast:
		return
		
	_has_damaged_this_swing = true
	
	attack_ray_cast.force_raycast_update()
	
	if attack_ray_cast.is_colliding():
		var target = attack_ray_cast.get_collider()
		
		var health_component = target.get_node_or_null("Behaviours/HealthComponent") as HealthComponent
		if health_component != null:
			health_component.take_damage(attack_damage)
