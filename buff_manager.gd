extends Node

@export var single_attack_buff = 0
@export var mitigation_buff = 0
@export var max_life_point_buff = 0
@export var aoe_attack_buff = 0

func get_single_attack_buff():
	return single_attack_buff

func set_single_attack_buff(value:float):
	single_attack_buff = value

func get_aoe_attack_buff():
	return aoe_attack_buff

func set_aoe_attack_buff(value:float):
	aoe_attack_buff = value

func get_mitigation_buff():
	return mitigation_buff

func set_mitigation_buff(value:float):
	mitigation_buff = value

func get_max_life_point_buff():
	return max_life_point_buff

func set_max_life_point_buff(value:float):
	max_life_point_buff = value
