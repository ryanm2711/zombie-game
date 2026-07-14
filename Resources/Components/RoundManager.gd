class_name RoundManager extends Node

@export var spawn_manager: SpawnManager

@export_category("Settings")
@export var base_enemy_spawn_count: int = 4

var _current_round: int = 0

signal on_round_change(newRound: int)

func _ready() -> void:
	set_round(1)
	GameManager.round_manager = self

func set_round(round: int) -> void:
	_current_round = max(1, round)
	
	if spawn_manager:
		spawn_manager.max_total_spawn = base_enemy_spawn_count * _current_round
		spawn_manager.auto_spawn = true
		
	on_round_change.emit(round)
	
	print("NEW ROUND: ", round)
	
func get_round() -> int:
	return _current_round
	
func increase_round(amount: int):
	amount = max(1, amount)
	set_round(get_round() + amount)

func _on_spawn_manager_on_all_enemies_cleared() -> void:
	increase_round(1)
