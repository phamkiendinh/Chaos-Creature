#extends BattleScene
extends Node2D
class_name AttackService

const  BLOOD_ANIM  = preload("res://BattleScene/Animation/blood_anim.tscn")
@onready var  buffmanager = preload("res://buff_manager.gd")
@onready var  BuffManager = buffmanager.new()

func blood_animation(position):
	var scene = BLOOD_ANIM.instantiate()
	add_child(scene)
	var bloodSprite = scene.get_node("blood")
	var bloodAnimation = scene.get_node("blood/AnimationPlayer")
	bloodSprite.global_position = Vector2(500,200)
	bloodAnimation.play("blood_splash")
	print("animation triggered")
	#scene._play_blood_anim_as_pos(position)
	#bloodSprite.play("blood_splash")
	

func attack_single(card, target, damage:int, enemy_dict:Dictionary, key):
	remove_lp(target, damage)
	check_lp(target, enemy_dict)
			
func attack_aoe(card, enemy_battle_dict:Dictionary, damage):
	var key_arr = enemy_battle_dict.keys()
	for i in key_arr:
		remove_lp(enemy_battle_dict[i], damage)
		check_lp(enemy_battle_dict[i], enemy_battle_dict)
#	attack_aoe_anim(card, enemy_battle_dict)
	print(card.mon_name," did an AOE attack, dealing ", damage, " damage")

func heal(card, target, damage:int, ally_dict:Dictionary, key):
	var battle_lp = target.life_point
	var max_lp = target.max_life_point
	if battle_lp + damage > max_lp:
		battle_lp = max_lp
	else:
		add_lp(target, damage)
#	check_lp(target)
	
func heal_aoe(card, dict:Dictionary, damage):
	var key_arr = dict.keys()
	for i in key_arr:
		var battle_lp = dict[i].life_point
		var max_lp = dict[i].max_life_point
		if battle_lp + damage > max_lp:
			battle_lp = max_lp
		else:
			add_lp(dict[i], damage)
			
func attack_type_rotation(key, ally:Dictionary, enemy:Dictionary, cycle:int, hero):
	var wait_time = 0
	var card = ally[key] #Get object from the key
	var type = card.attack_type
	var damage = card.attack_power
	var target
	var enemy_key_array = enemy.keys()
	var random_key
	if enemy_key_array.size() > 0:
		random_key = enemy_key_array[randi() %  enemy_key_array.size()]
	var card_path = card.get_path()
	var card_sprite = card.get_node(card_path)
#	var tween
#	if tween: tween.kill()
#	tween = card_sprite.create_tween()
	if enemy_key_array.size() <= 0:
		Global.attack_hero(damage)
		Global.log_text += "Attacking Hero for " + damage
	else: 
		var melee_target_arr = targeting(enemy, "melee")
		var range_target_arr = targeting(enemy, "range")
		var melee_target
		var range_target
		match type:
			"melee": 
				if melee_target_arr.is_empty(): 
					print("No Target for Melee ")
				else: 
					var melee_target_index = randi() % melee_target_arr.size()
					melee_target = melee_target_arr[melee_target_index]
					attack_single(card, melee_target, damage, enemy, key)
					Global.log_text += str(card.mon_name) + " melee single attacked " + str(melee_target.mon_name) + " doing " + str(damage) + " damage.\n"
			"range": 
				if range_target_arr.is_empty(): 
					print("No Target for Range ")
				else:
					var range_target_index = randi() % range_target_arr.size()
					range_target = range_target_arr[range_target_index]
					attack_single(card, range_target, damage, enemy, key)
					Global.log_text += str(card.mon_name) + " range single attacked " + str(range_target.mon_name) + " doing " + str(damage) + " damage.\n"
			"random": 
				var enemy_rand = enemy[random_key]
				attack_single(card, enemy_rand, damage, enemy, key)
				Global.log_text += card.mon_name + " random single attacked " + enemy_rand.mon_name + " doing " + str(damage) + " damage.\n"
			"aoe": 
				attack_aoe(card, enemy, damage)
				Global.log_text += card.mon_name + " aoe attacked all targets" + " doing " + str(damage) + " damage.\n"
				for i in enemy.keys():
					var true_target = enemy[i] #Get target obj 
					var target_path = true_target.get_path() #Path to target obj sprite
					var target_sprite = true_target.get_node(target_path) #Get target obj sprite
					var target_sprite_parent = true_target.get_parent() #Get the slot the sprite is currently in
#					wait_time = TweenBehaviours.tween_manager(tween, card, true_target, type)
			"execution": 
				var lowest_lp_target = enemy[min_attri(enemy, "life_point")]
				attack_single(card, lowest_lp_target, damage, enemy, key)
				Global.log_text += card.mon_name + " execution attacked " + lowest_lp_target.mon_name + " doing " + str(damage) + " damage.\n"
			"challenger": 
				var highest_attack_target = enemy[max_attri(enemy, "attack_power")]
				attack_single(card,  highest_attack_target, damage, enemy, key)
				Global.log_text += card.mon_name + " challenged attacked " + highest_attack_target.mon_name + " doing " + str(damage) + " damage.\n"
			"melee_salvo": 
				attack_aoe(card, salvo_targeting_dict(melee_target_arr, enemy), damage)
				Global.log_text += card.mon_name + " aoe attacked all melee targets" + " doing " + str(damage) + " damage.\n"
			"range_salvo": 
				attack_aoe(card, salvo_targeting_dict(range_target_arr, enemy), damage)
				Global.log_text += card.mon_name + " aoe attacked all ranged targets" + " doing " + str(damage) + " damage.\n"
			"heal": 
				var lowest_lp_ally = ally[min_attri(ally, "life_point")]
				heal(card, lowest_lp_ally, damage, ally, key)
				Global.log_text += card.mon_name + " healed " + lowest_lp_ally.mon_name + " for " + str(damage) + " \n "
			"aoe_heal": 
				heal_aoe(card, ally, damage)
				Global.log_text += card.mon_name + " healed all allies" + " for " + str(damage) + " \n "
				for i in ally.keys():
					var true_target = ally[i] #Get target obj 
					var target_path = true_target.get_path() #Path to target obj sprite
					var target_sprite = true_target.get_node(target_path) #Get target obj sprite
					var target_sprite_parent = true_target.get_parent() #Get the slot the sprite is currently in
		check_lp(card, ally)
		check_lp(card, enemy)
	return wait_time

# Returns an array of object	
func targeting(enemy_list, type:String):
	var target_array = []
	var target
	for i in enemy_list:
		match String(type):
			"range":
				if i == "Slot1" || i == "Slot3" || i == "Slot5":
					target_array.append(enemy_list[i])
			"melee":
				if i == "Slot2" || i == "Slot4" || i == "Slot6":
					target_array.append(enemy_list[i])
	return target_array

func salvo_targeting_dict(arr:Array, enemy_dict):
	#Dict builder
	var enemy_list = enemy_dict.values()
	var target_dict = {}
	for i in arr.size():
		target_dict[arr[i]] = enemy_list[i]
	return target_dict
			
func check_lp(card, dict:Dictionary):
	var current_lp:int = card.life_point
#	var node = card.get_node()
	if current_lp <= 0:
		card.status = "Dead"
		erase_value_from_dict(dict, card)
		death_anim(card)
		card.life_point = 0

func update_lp(card: Object, slot: Object, enemy_slot: Object):
	enemy_slot.update_slot_life_point(card, slot)
	pass

func remove_lp(card, amount):
	var lp_removed:bool = false
	if card.status != "Dead":
		card.life_point -= amount
		lp_removed = true
	return lp_removed	

func add_lp(card, amount):
	var lp_added:bool = false
	if card.status != "Dead":
		card.life_point += amount
		lp_added = true
	return lp_added	

func erase_value_from_dict(dict:Dictionary, value) -> void:
	for key in dict.keys():
		if dict[key] == value:
			dict.erase(key)
			
func empty_slot_check(dict:Dictionary, key):
	var is_empty:bool = true
	if key in dict:
		is_empty = false
	return is_empty

# Return dictionary key
func max_attri(dict:Dictionary, attri:String):
	var arr = get_obj_array(dict)
	var arr_keys = dict.keys()
	var lp_arr = []
	var final_obj_key
	for i in range(arr.size()):
		lp_arr.append(arr[i].get(attri))
	lp_arr.sort()
	var max = lp_arr[-1]
	final_obj_key = arr_keys[arr_keys.find(lp_arr[lp_arr.find(max, 0)])]
	return final_obj_key

# Return dictionary key
func min_attri(dict:Dictionary, attri:String):
	var arr = get_obj_array(dict)
	var arr_keys = dict.keys()
	var lp_arr = []
	var final_obj_key
	for i in range(arr.size()):
		lp_arr.append(arr[i].get(attri))
	lp_arr.sort()

	var min = lp_arr[0]
	final_obj_key = arr_keys[arr_keys.find(lp_arr[lp_arr.find(min, 0)])]
	return final_obj_key
	
func get_obj_array(dict:Dictionary):
	var obj_arr = dict.values()
	return obj_arr

#Tween
func tween_manager(tween:Tween, card:Object, target:Object, type:String): #Get object from the key
#	var type = card.attack_type
	var wait_time = 0
	
	var card_path = card.get_path()
	var card_sprite = card.get_node(card_path)
	
	var target_path = target.get_path()
	var target_sprite = target.get_node(target_path)
	var target_sprite_parent = target.get_parent()
		
	match type:
		"melee": wait_time = attack_single_anim(tween, card_sprite, target_sprite, target_sprite_parent)
		"range": wait_time = attack_single_anim(tween, card_sprite, target_sprite, target_sprite_parent)
		"random": wait_time = attack_random_anim(tween, card_sprite, target_sprite, target_sprite_parent)
		"aoe": wait_time = attack_aoe_anim(tween, card_sprite, target_sprite, target_sprite_parent)
		"execution": pass
		"challenger": pass
		"melee_salvo": pass
		"range_salvo": pass
		"heal": wait_time = heal_anim(tween, card_sprite, target_sprite, target_sprite_parent)
		"heal_aoe": wait_time = heal_aoe_anim(tween,card_sprite,target_sprite,target_sprite_parent)
	return wait_time

"""Always return total animation time"""
func attack_single_anim(tween:Tween, card_sprite, target_sprite, target_sprite_parent) -> int:
	var anim_time = 2
	var original_sprite_modulate = card_sprite.modulate
	var og_sprite_rotation = card_sprite.rotation
	
	#blood_animation(target_sprite_parent.position)
	tween.tween_property(card_sprite, "global_position", target_sprite_parent.position , 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(target_sprite, "modulate", Color.RED, 0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(target_sprite,'scale',Vector2.ONE, 0.1)
	tween.tween_property(target_sprite,'rotation', 0.2, 0.1)
	tween.tween_property(target_sprite,'rotation',og_sprite_rotation , 0.1)		
	tween.tween_property(target_sprite,'rotation', -0.2, 0.1)
	tween.tween_property(target_sprite,'rotation',og_sprite_rotation , 0.1)	
	tween.tween_property(target_sprite, "modulate", original_sprite_modulate, 0.5).set_trans(Tween.TRANS_SINE)
	return anim_time


func attack_random_anim(tween:Tween, card_sprite, target_sprite, target_sprite_parent) -> int:
	var anim_time = 4
	var original_sprite_modulate = card_sprite.modulate
	var card_sprite_parent = card_sprite.get_parent()
	tween.tween_property(card_sprite, "global_position", card_sprite_parent.position.y + 10 , 2)
	tween.tween_property(card_sprite, "global_position", target_sprite_parent.position , 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(target_sprite, "modulate", Color.RED, 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(target_sprite, "modulate", original_sprite_modulate, 0.5).set_trans(Tween.TRANS_SINE)
	return anim_time 
	
#func attack_aoe_anim(card, enemy_battle_dict:Dictionary):
#	var key_arr = enemy_battle_dict.keys()
#	var card_path = card.get_path()
#	var card_sprite = card.get_node(card_path)
#	var tween = card_sprite.create_tween()

	
func attack_aoe_anim(tween:Tween, card_sprite, target_sprite, target_sprite_parent) -> int:
	var anim_time = 0
	var original_sprite_modulate = card_sprite.modulate
	var og_sprite_rotation = card_sprite.rotation
	
	#blood_animation(target_sprite_parent.position)
	tween.tween_property(card_sprite, "modulate", Color.YELLOW, 0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(target_sprite, "modulate", Color.RED, 0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(target_sprite,'scale',Vector2.ONE, 0.1)
	tween.tween_property(target_sprite,'rotation', 0.2, 0.1)
	tween.tween_property(target_sprite,'rotation',og_sprite_rotation , 0.1)		
	tween.tween_property(target_sprite,'rotation', -0.2, 0.1)
	tween.tween_property(target_sprite,'rotation',og_sprite_rotation , 0.1)	
	tween.tween_property(target_sprite, "modulate", original_sprite_modulate, 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(card_sprite, "modulate", original_sprite_modulate, 0.5).set_trans(Tween.TRANS_SINE)
	return anim_time

func heal_aoe_anim(tween:Tween, card_sprite, target_sprite, target_sprite_parent) -> int:
	var anim_time = 0
	var original_sprite_modulate = card_sprite.modulate
	var og_sprite_rotation = card_sprite.rotation
	tween.tween_property(card_sprite, "modulate", Color.ORANGE, 0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(target_sprite, "modulate", Color.LAWN_GREEN, 0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(target_sprite,'scale',Vector2.ONE, 0.1)
	tween.tween_property(target_sprite,'rotation', 0.2, 0.1)	
	tween.tween_property(target_sprite, "modulate", original_sprite_modulate, 0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(card_sprite, "modulate", original_sprite_modulate, 0).set_trans(Tween.TRANS_SINE)
	return anim_time
	
func heal_anim(tween:Tween, card_sprite, target_sprite, target_sprite_parent) -> int:
	var anim_time = 2
	var original_sprite_modulate = card_sprite.modulate
	var og_sprite_rotation = card_sprite.rotation
	#tween.tween_property(card_sprite, "global_position", target_sprite_parent.position , 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(target_sprite, "modulate", Color.LAWN_GREEN, 0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(target_sprite,'scale',Vector2.ONE, 0.1)
	tween.tween_property(target_sprite,'rotation', 0.2, 0.1)
	tween.tween_property(target_sprite,'rotation',og_sprite_rotation , 0.1)		
	tween.tween_property(target_sprite, "modulate", original_sprite_modulate, 0.5).set_trans(Tween.TRANS_SINE)
	return anim_time
	
func death_anim(card:Object):
	var card_path = card.get_path()
	var initial_pos = card.position
	var card_sprite = card.get_node(card_path)
	var tween = card_sprite.create_tween()
	tween.tween_property(card_sprite, "modulate", Color.RED, 1).set_trans(Tween.TRANS_SINE)
	tween.tween_property(card_sprite, "scale", Vector2(), 1).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_callback(card_sprite.queue_free)
