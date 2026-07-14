class_name CombatComponent extends Node3D

@export var current_weapon: WeaponResource:
	set(new_wep):
		on_weapon_change.emit(current_weapon, new_wep)
		current_weapon = new_wep
@export var weapon_hand: Node3D
@export var target_ray: RayCast3D
@export var bullet_hole_decal: PackedScene

@export var shake_component: CameraShakeComponent

@export var audio_player: AudioStreamPlayer3D

signal on_weapon_ammo_change(new_clip: int, new_max_ammo: int)
signal on_weapon_change(oldWep: WeaponResource, newWep: WeaponResource)
signal on_weapon_ray_colliding(ray: RayCast3D)

var can_fire: bool = true
var fire_timer: Timer
var is_holding_trigger: bool = false
var ammo_clip: int:
	set(new_clip):
		ammo_clip = new_clip
		on_weapon_ammo_change.emit(ammo_clip, max_ammo)
var max_ammo: int:
	set(new_max_ammo):
		max_ammo = new_max_ammo
		on_weapon_ammo_change.emit(ammo_clip, max_ammo)

func _ready() -> void:
	fire_timer = Timer.new()
	fire_timer.one_shot = true
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	add_child(fire_timer)
	
	spawn_weapon_mesh()
		
func spawn_weapon_mesh() -> void:
	if current_weapon and current_weapon.weapon_mesh:
		for child in weapon_hand.get_children():
			child.queue_free()
			
		var mesh_instance = current_weapon.weapon_mesh.instantiate()
		weapon_hand.add_child(mesh_instance)
		
		ammo_clip = current_weapon.clip_size
		max_ammo = current_weapon.max_ammo
	
func _process(_delta: float) -> void:
	if not current_weapon:
		return
		
	if current_weapon.fire_mode == WeaponResource.FireMode.AUTO and is_holding_trigger:
		fire()
		
func fire() -> void:
	if not can_fire or not current_weapon or ammo_clip <= 0:
		return
		
	can_fire = false
	fire_timer.start(current_weapon.fire_rate)
	
	ammo_clip -= 1
	
	_trigger_muzzle_flash()
	_play_weapon_sound()
	
	if shake_component:
		shake_component.apply_shake(current_weapon.shake_intensity, current_weapon.shake_duration)
	
	if target_ray.is_colliding():
		var collider := target_ray.get_collider()
		_create_bullet_hole_impact(collider, target_ray.get_collision_point(), target_ray.get_collision_normal())
		
		if collider.has_node("Behaviours/HealthComponent"):
			# Take damage
			on_weapon_ray_colliding.emit(target_ray)
			var healthComponent = collider.get_node("Behaviours/HealthComponent") as HealthComponent
			healthComponent.take_damage(current_weapon.damage)
			
func reload() -> void:
	if not current_weapon or max_ammo <= 0 or ammo_clip >= current_weapon.clip_size:
		return
		
	var new_clip = current_weapon.clip_size
	if max_ammo < new_clip:
		new_clip = max_ammo
		
	ammo_clip = new_clip
	max_ammo -= new_clip
	
func press_trigger() -> void:
	is_holding_trigger = true
	if current_weapon and current_weapon.fire_mode == WeaponResource.FireMode.SEMI:
		fire()
		
func release_trigger() -> void:
	is_holding_trigger = false

func _on_fire_timer_timeout() -> void:
	can_fire = true

func _trigger_muzzle_flash() -> void:
	if not current_weapon or not current_weapon.weapon_muzzle_flash:
		return
		
	if weapon_hand.get_child_count() == 0:
		return
		
	var current_gun_mesh = weapon_hand.get_child(0)
	
	if current_gun_mesh.has_node("Muzzle"):
		var muzzle_marker = current_gun_mesh.get_node("Muzzle") as Marker3D
		var flash_instance = current_weapon.weapon_muzzle_flash.instantiate()
		
		muzzle_marker.add_child(flash_instance)

func _play_weapon_sound() -> void:
	if not audio_player or not current_weapon or not current_weapon.fire_sound:
		return
		
	audio_player.stream = current_weapon.fire_sound
	audio_player.play()

func _create_bullet_hole_impact(obj: Object, hitPos: Vector3, hitNormal: Vector3) -> void:
	var bullet_hole = bullet_hole_decal.instantiate() as Node3D
	obj.add_child(bullet_hole)
	
	bullet_hole.global_position = hitPos
	
	var dir := Vector3.UP
	if abs(hitNormal.dot(Vector3.UP)) > 0.99:
		dir = Vector3.FORWARD
	bullet_hole.look_at(hitPos + hitNormal, dir)


func _on_input_component_reload_weapon() -> void:
	reload()
