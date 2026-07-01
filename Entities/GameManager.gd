extends Node

const GRAVITY: float = -9.81

var _player: Player = null

func register_player(player_instance: Player) -> void:
	_player = player_instance
	
func unregister_player() -> Player:
	return _player
	
func get_player() -> Player:
	return _player

func has_player() -> bool:
	return _player != null
