class_name HUDComponent extends CanvasLayer

@export var crosshair: TextureRect
@export var round_label: Label

@export_subgroup("WeaponInfo")
@export var weapon_name_label: Label
@export var weapon_ammo_label: Label

var _crosshair_accent_color: Color

func _ready() -> void:
	if crosshair:
		crosshair.material.set_shader_parameter("newColor", _crosshair_accent_color)
		
	if GameManager.round_manager:
		GameManager.round_manager.on_round_change.connect(_on_round_manager_round_change)


func _on_combat_component_on_weapon_ammo_change(new_clip: int, new_max_ammo: int) -> void:
	if not weapon_name_label:
		push_warning("[HUDComponent] Weapon ammo label is not valid!")
		return
	weapon_ammo_label.text = str(new_clip) + " / " + str(new_max_ammo)


func _on_combat_component_on_weapon_change(oldWep: WeaponResource, newWep: WeaponResource) -> void:
	if not weapon_name_label:
		push_warning("[HUDComponent] Weapon name label is not valid!")
		return
	weapon_name_label.text = newWep.weapon_name


func _on_combat_component_on_weapon_ray_colliding(ray: RayCast3D) -> void:
	pass

func _on_round_manager_round_change(round: int) -> void:
	if not round_label:
		push_warning("[HUDComponent] Round label is not valid!")
		return
		
	round_label.text = str(round)
