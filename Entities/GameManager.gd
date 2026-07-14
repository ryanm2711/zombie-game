extends Node

var round_manager: RoundManager

const GRAVITY: float = -9.81

var _player: Player = null
var _paused: bool = false

signal on_game_pause_toggled(isPaused: bool)

func register_player(player_instance: Player) -> void:
	_player = player_instance
	
func unregister_player() -> Player:
	return _player
	
func get_player() -> Player:
	return _player

func has_player() -> bool:
	return _player != null

func set_game_paused(bPause: bool) -> void:
	_paused = bPause
	get_tree().paused = bPause
	
	on_game_pause_toggled.emit(bPause)

func is_game_paused() -> bool:
	return _paused
