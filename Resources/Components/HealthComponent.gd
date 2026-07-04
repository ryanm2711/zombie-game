class_name HealthComponent extends Node3D

@export var health: float = 100.0:
	set(new_health):
		health = max(0, new_health)
		print("Owner: ", owner, " New Health: ", new_health)
	get:
		return health

var entity: Node3D

signal on_entity_take_damage(entity:Node3D, newHealth: float, oldHealth: float)
signal on_entity_death(entity: Node3D)

func _ready():
	await owner.ready
	entity = owner as Node3D
	assert(entity != null, "The HealthComponent must be inside a tree with a Node3D root node.")

func _process(_delta: float):
	if health <= 0 and entity:
		on_entity_death.emit(entity)

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
