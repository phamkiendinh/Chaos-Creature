extends Node

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"attack" : attack,
		"defense" : defense,
		"current_health" : current_health,
		"max_health" : max_health,
		"damage" : damage,
		"regen" : regen,
		"experience" : experience,
		"tnl" : tnl,
		"level" : level,
		"attack_growth" : attack_growth,
		"defense_growth" : defense_growth,
		"health_growth" : health_growth,
		"is_alive" : is_alive,
		"last_attack" : last_attack
	}
	return save_dict
