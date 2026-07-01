class_name WeaponResource extends Resource

enum FireMode {SEMI, AUTO, BURST}

# General info
@export var weapon_name: String = "Pistol"
@export var weapon_mesh: PackedScene

# Damage info
@export var damage: float = 10.0
@export var fire_rate: float = 0.2 # Time in between shots

# Ammo
@export var clip_size: int = 6
@export var max_ammo: int = 96

@export var fire_mode: FireMode = FireMode.SEMI

@export_subgroup("Effects")
@export var weapon_muzzle_flash: PackedScene
@export var shake_intensity: float = 0.2 # How far the camera offsets
@export var shake_duration: float = 0.15 # How long the shake lasts (in seconds)

@export_subgroup("Audio")
@export var fire_sound: AudioStream
