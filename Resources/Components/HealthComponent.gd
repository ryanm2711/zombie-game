class_name HealthComponent extends Node3D

@export var health: float = 100.0

var entity: Node3D

signal on_entity_take_damage(entity:Node3D, newHealth: float, oldHealth: float)

func _ready():
	await owner.ready
	entity = owner as Node3D
	assert(entity != null, "The HealthComponent must be inside a tree with a Node3D root node.")

func _process(_delta: float):
	if health <= 0 and entity:
		entity.queue_free() # Temporary, idk if to have death handled in here or not

func set_health(newHP: float):
	health = newHP
	
func add_health(amount: float) -> float:
	var newHealth = health + amount
	health = newHealth
	
	return newHealth
	
func remove_health(amount: float) -> float:
	var newHealth = health - amount
	if newHealth < 0:
		newHealth = 0
		
	health = newHealth
	return newHealth

func take_damage(amount: float) -> float:
	var oldHealth = health
	var newHealth = remove_health(amount)
	
	on_entity_take_damage.emit(entity, oldHealth, newHealth)
	return newHealth
