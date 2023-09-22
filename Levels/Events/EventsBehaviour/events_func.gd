extends Node

func apply_stat_mod(stat, value:float):
	match stat:
		"single_attack": BuffManager.set_single_attack_buff(value)
		"aoe_attack": BuffManager.set_aoe_attack_buff(value)
		"mitigation": BuffManager.set_mitigation_buff(value)
		"max_life_point": BuffManager.set_max_life_point_buff(value)
		"restore_life_point": print("Something happened")
