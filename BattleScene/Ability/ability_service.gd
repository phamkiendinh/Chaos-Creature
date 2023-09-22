extends Node2D
class_name AbilityService

#@onready var atk = load("res://BattleScene/Service/attacks_service.gd").new()
#@onready var effect_obj = load("res://BattleScene/Effect/effect_service.gd").new()
#var effect_inst = effect_obj.new()


"""Might need later"""
#	var key_array =  ally.keys()
#	var random_key
#	if enemy != {}:
#		var enemy_key_array = enemy.keys()
#		random_key =  enemy_key_array[randi() %  enemy_key_array.size()]

"""Each only applies to 1 ability a time"""
func apply_ability_effect(card:Object, effect_node:Node, ability_node:Node, current_cycle:int):
	var card_ability = card.active_ability
	var target
	var stored_effect:Object = find_effect_by_name_attri(card_ability, effect_node)
	var stored_ability:Object = find_ability_by_name_attri(card_ability, ability_node)
	var is_a_active = check_active_effect(card, stored_effect)
	var end_cycle:int = current_cycle + stored_ability.duration
	if !is_a_active: 
		stored_effect.mod_value = stored_ability.modified_amount
		append_effect_to_card(card, stored_effect, end_cycle)
		print("Something happened")
	else: print("Effect already active")
	
#For autobattle
#This function only execute 1 effect at a time
func execute_effect(card:Object, current_cycle:int):
	var cycle = 5
	var effect_arr = card.active_effect
	for effect in effect_arr:
		match effect.effect_name:
			"attack_up": #Example of attribute modification effect
				card.attack_power += effect.mod_value
				print("Attack Power ", card.attack_power)
			"max_lp_up":
				card.max_life_point += effect.mod_value
				print("Max Life Point ", card.max_life_point)
			"destined_death": #Example of conditional, multistage effect
				card.life_point = 1 #Stage 1, initial effect
				card.attack_power += card.attack_power + effect.mod_value
				if current_cycle == effect.end_cycle && card.life_point != card.max_life_point - 1: #Stage 2 exit effect
					card.life_point = 0
			"draw": #Example of utility effect
				#draw a card
				print("Draw a card")
			
#Apply Effect
func append_effect_to_card(card:Object, effect:Object, end_cycle:int):
	effect.end_cycle = end_cycle
	card.active_effect.append(effect)
		
func check_active_effect(card:Object, effect:Object)-> bool:
	var is_active = false
	# Check for it inside the object
	var effect_arr = card.active_effect
	for i in effect_arr:
		if effect == i:
			is_active = true
	return is_active

#	append_effect_to_dict(card_affected, effect_obj, current_cycle + duration, effect_dict, id)	
func check_effect_duration(dict:Dictionary, current_cycle:int) -> void:
	var cycle_start = 0
	for card in dict.values(): 
		var all_effects_active_in_card = card.active_effect
		if all_effects_active_in_card != []:
			for i in all_effects_active_in_card:
				if current_cycle > i.end_cycle:
					cancel_modifier_effect(i, card)
					card.active_effect.erase(i)
					print("Effect canceled")
				if card == null:
					cancel_modifier_effect(i, card)
					card.active_effect.erase(i)
					print("Effect canceled due to Natural Death")

#Manual Labor :skull:
func cancel_modifier_effect(effect:Object, card):
	var effect_name = effect.effect_name
	match effect_name:
		"attack_up": 
			card.attack_power -= effect.mod_value
			print(card.mon_name, "'s ", effect_name , " is lost")
		"max_lp_up": card.max_life_point - effect.mod_value
		
func erase_value_from_dict(dict:Dictionary, value) -> void:
	for key in dict.keys():
		if dict[key] == value:
			dict.erase(key)

func find_ability_by_name_attri(name:String, node:Node):
	var found_obj
	for i in node.get_children():
		if name == i.ability_name:
			found_obj = i
#			print("What is ability? ", i)
			break
	if found_obj == null:
		print("Is NUll")
	return found_obj

func find_effect_by_name_attri(name:String, node:Node):
	var found_obj
	for i in node.get_children():
		if i.effect_name == name:
#			print("What is effect? ", i)
			found_obj = i
			break
	if found_obj == null:
		print("Is NUll")
	return found_obj
	
func stat_effect(card, target, effect, damge):
	pass

func attack_up_anim(card:Object):
	var card_path = card.get_path()
	var initial_pos = card.position
	var card_sprite = card.get_node(card_path)
	var tween = card_sprite.create_tween()
	
	tween.tween_property(card_sprite, "modulate", Color.GOLD, 2).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(card_sprite, "modulate", Color.BLUE_VIOLET, 1).set_trans(Tween.TRANS_CIRC)
