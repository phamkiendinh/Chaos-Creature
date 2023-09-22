extends Node2D

class_name BattleScene
signal discarding
# Variables
@export var player:String
@export var monster:String
@export var draw_phase:bool = true
@export var battle_phase:bool = false
@export var end_phase:bool = false
@export var discard:bool = false
@export var number_card_to_remove:int = 0
@export var turn:int = 0
@export var player_turn = true
@export var enemy_turn = false
@export var cycle_count = 1
@export var is_ally_attacking:bool
@export var current_cycle:int = 0
@export var wait_time = 0.5
@export var total_wait_time = 0
@export var turn_queue = [ ]
@export var turn_index:int = 0 #current location on the turn_q array
@export var battle_status:int = 2 
# 2: In Progress
# 1: Victory
# 0: Lost
	

@export var dunegon_effect = {}

"""Dictionaries"""
var ally_on_battle_dict = {}
var enemy_on_battle_dict = {} #Spawn enemy here
var ally_battle_effect_dict = {}
var enemy_battle_effect_dict = {} 
var battle_effect_dict = {}
var ability_on_standby_dict = {} # card:ability_name

# CONSTANTS
const _SPELL_BASE = preload("res://Card/Spell/spell_base.tscn")
const _MONSTER_BASE = preload("res://Card/Monster/monster_base.tscn")
const _CARD_SLOTS = preload("res://BattleScene/Slots/card_slot.tscn")
const _MONSTER_DATA = preload("res://Card/Monster/monster_database.gd")
const _SPELL_DATA = preload("res://Card/Spell/spell_database.gd")
const _ABILITY_DATA = preload("res://BattleScene/Ability/ability_database.gd")
const _EFFECT_DATA = preload("res://BattleScene/Effect/effect_database.gd")

# DATA
var a_json = _ABILITY_DATA.new()
var e_json = _EFFECT_DATA.new()

var cards_selected_index = []
var deck_size:int = 30
var result = -1
@onready var hero = $PlayerField/Hero
"""
	Draw Phase Logic
"""
#Scripts load
@onready var attack_serv = load("res://BattleScene/Service/attacks_service.gd").new()
@onready var ability_serv = load("res://BattleScene/Ability/ability_service.gd").new()
@onready var effect_serv = load("res://BattleScene/Effect/effect_service.gd").new()

@onready var ability = preload("res://BattleScene/Ability/ability.tscn")
@onready var effect = preload("res://BattleScene/Effect/battle_effect.tscn")
var damage_number_2d_template = preload("res://damage_number.tscn")
var damage_number_2d_pool:Array[DamageNumber2D] = []
#@onready var ability_serv = Ability.new()

@onready var title_card = preload("res://BattleScene/Animation/battle_tittle_card_anim.tscn")
@onready var block = false

var slot_index:int = 0

#@onready var level_manager = preload("res://Levels/Manager.tscn")
"""Input & System"""
func _physics_process(delta):
	if result != 1 and not $BattleSound.playing:
		$BattleSound.play()
		
	if discard:
		if $LeftBlock.visible == false && $RightBlock.visible == false && $TopBlock.visible == false:
			$LeftBlock.visible = true
			$RightBlock.visible = true
			$TopBlock.visible = true
			
		for card in self.get_node('PlayerField/Hand').get_children():
			if card.state['discard']:
				var index = card.card_index
				self.get_node('PlayerField/Hand').remove_child(card)
				self.get_node('PlayerField').remove_card_from_hand(index)
				if number_card_to_remove > 0:
					number_card_to_remove -= 1
				if number_card_to_remove == 0:
					discard = false
					$LeftBlock.visible = false
					$RightBlock.visible = false
					$TopBlock.visible = false
		pass
	elif draw_phase:
		draw_phase = false
		start_draw_phase()
	elif end_phase:
		end_phase = false
		start_end_phase()

func _input(event):
	pass

func start_draw_phase():
	if not discard:
		if turn == 0:
			$HUD/Line.color = Color(0,1,0,1)
			$HUD/Text.text = "\t\tGame Start"
			$Light.enabled = true
			$HUD.show()
			await get_tree().create_timer(1).timeout
			$Light.enabled = false
			$HUD.hide()
			$HUD/Text.text = "Starting Draw Phase"
			$Light.enabled = true
			$HUD.show()
			await get_tree().create_timer(1).timeout
			$Light.enabled = false
			$HUD.hide()
			$HUD/Text.text = "\t\t  Draw Phase"
			$Light.enabled = true
			$HUD.show()
			for i in range(5):
				$PlayerField.draw_card()
				$EnemyField.draw_card()
				$FlipCardSound.play()
				await get_tree().create_timer(0.5).timeout
			if $PlayerField.hero_rune + $PlayerField.rune_gain_per_turn <= $PlayerField.max_hero_rune:
				$PlayerField.hero_rune += $PlayerField.rune_gain_per_turn
			else:
				$PlayerField.hero_rune = $PlayerField.max_hero_rune
			$Light.enabled = false
			$HUD.hide()
			$HUD/Line.color = Color(0,0,1,1)
			$HUD/Text.text =  str("\t\t\t Turn ", turn + 1)
			$Light.enabled = true
			$HUD.show()
			await get_tree().create_timer(1).timeout
			$Light.enabled = false
			$HUD.hide()
			$HUD/Line.color = Color(0,0,1,1)
			$HUD/Text.text = "\t\t  Your Turn"
			$Light.enabled = true
			$HUD.show()
			await get_tree().create_timer(1).timeout
			$Light.enabled = false
			$HUD.hide()
		else:
			$Light.enabled = false
			$HUD.hide()
			$HUD/Line.color = Color(0,0,1,1)
			$HUD/Text.text =  str("\t\t\t Turn ", turn + 1)
			$Light.enabled = true
			$HUD.show()
			await get_tree().create_timer(1).timeout
			$HUD/Line.color = Color(0,0,1,1)
			$Light.enabled = true
			$HUD/Text.text = "\t\t  Draw Phase"
			$HUD.show()
			$PlayerField.draw_card()
			$FlipCardSound.play()
			
			await get_tree().create_timer(0.8).timeout
			$Light.enabled = false
			$HUD.hide()
			if $PlayerField.hero_rune + $PlayerField.rune_gain_per_turn <= $PlayerField.max_hero_rune:
				$PlayerField.hero_rune += $PlayerField.rune_gain_per_turn
			else:
				$PlayerField.hero_rune = $PlayerField.max_hero_rune
		turn += 1
		if $PlayerField.number_cards_in_hand >= $PlayerField.max_cards_on_hand:
			discard = true
			return
			
func start_end_phase():
	$Light.enabled = true
	$HUD/Text.text = "\t\tEnd Phase"
	$HUD.show()
	await get_tree().create_timer(1).timeout
	$Light.enabled = false
	$HUD.hide()
	if $PlayerField.number_cards_in_hand >= $PlayerField.max_cards_on_hand:
		discard = true
		return
#func auto_spawn_player():
#	pass
func battle_data_reader():
	for s in $PlayerField/HeroCardSlot.get_children():
		if s.get_child_count() == 3:
			if not s.get_child(2).state['spell']:
				ally_on_battle_dict[str(s.name.replace("&", ""))] = s.get_child(2)

	for s in $EnemyField.get_children():
		if s.get_child_count() == 3:
			if not s.get_child(2).state['spell']:			
				enemy_on_battle_dict[str(s.name.replace("&", ""))] = s.get_child(2)

func load_in_ability_data():
	var index = 0
	for i in a_json.DATA.get('Ability'):
		var a = ability.instantiate()
		a.i = index
		index += 1
		$Abilities.add_child(a)
			
func load_in_effect_data():
	var index = 0
	for i in e_json.DATA.get('Effect'):
		var a = effect.instantiate()
		a.i = index
		index += 1
		$CombatEffects.add_child(a)
		
func get_attri_arr(dict:Dictionary, attri:String):
	var dict_value_arr = dict.values()
	var name_arr = []
	for i in dict_value_arr:
		name_arr.append(i.get(attri))
	return name_arr	
"""
	Battle Functions
"""
#var battle_true_end:bool = true

#Generate new turn pair every call
func generate_turn():
	turn_queue.append(1)
	turn_queue.append(0)
	
func turn_call(turn_index):
	var whose_turn:int
	whose_turn = turn_queue[turn_index]
	return whose_turn

func advance_turn(): turn_index += 1

var log_text = ""
func battle(turn):
	$Battle.disabled = true
	if cycle_count > 1:
		$PlayerField.hero_rune += $PlayerField.rune_gain_per_turn
	Global.log_text += "!!!!!!!!!!------------Cycle " + str(cycle_count) + " Started------------!!!!!!!!!! \n \n"
	Global.log_text += "------------Player Turn------------!!!!!!!!!! \n \n"
	ally_turn_auto()
	ability_serv.check_effect_duration(ally_on_battle_dict, cycle_count)
	await get_tree().create_timer(1.5).timeout
	Global.log_text += "------------Enemy Turn------------!!!!!!!!!! \n \n"
	enemy_turn_auto()
	ability_serv.check_effect_duration(enemy_on_battle_dict, cycle_count)	
	Global.log_text += "!!!!!!!!!!------------Cycle " + str(cycle_count) + " Ended------------!!!!!!!!!! \n \n"
	$Log.text = Global.log_text
	battle_condition_check()
	await get_tree().create_timer(total_wait_time + 1).timeout

func ally_turn_auto():
	print("------------Ally's Turn------------")
	for i in ally_on_battle_dict.keys():
		is_ally_attacking = true
		wait_time = attack_serv.attack_type_rotation(i, ally_on_battle_dict, enemy_on_battle_dict, cycle_count, hero)
		total_wait_time += 1.2
		$Log.text = Global.log_text
		await get_tree().create_timer(1 + 0.2).timeout
			
		
func enemy_turn_auto():
	if !enemy_on_battle_dict.is_empty():
		for e in enemy_on_battle_dict:
			is_ally_attacking = false
			wait_time = attack_serv.attack_type_rotation(e, enemy_on_battle_dict, ally_on_battle_dict, cycle_count, hero)
			total_wait_time += 1.2
			$Log.text = Global.log_text
			await get_tree().create_timer(1 + 0.2).timeout
				
func battle_condition_check() -> int:
	var result:int = 2
	if cycle_count > 2:
		if Global.hero_lp <= 0:
			result = 0
			print("Lost")
		if cycle_count > 1 && enemy_on_battle_dict.is_empty():
			result = 1
	#		win()
			print("Win")
	return result
	
"""Input & System"""
func _ready():
	generate_hud()
	generate_turn()
	load_in_ability_data()
	load_in_effect_data()
	pass
	
func generate_hud():
	$Light.enabled = false
	$HUD.size = get_viewport_rect().size
	$HUD/Text.size = $HUD.size / 11
	$HUD/Text.position.x = get_viewport_rect().size.x * 0.31
	$HUD/Text.position.y = get_viewport_rect().size.y * 0.25
	$HUD/Line.size.x = $HUD.size.x
	$HUD/Line.size.y = $HUD/Text.size.y
	$HUD/Line.position.y = $HUD/Text.position.y
	$HUD.hide()
	
	$LeftBlock.size.y = get_viewport_rect().size.y
	$LeftBlock.size.x = get_viewport_rect().size.x * 0.2
	
	$RightBlock.size.y = get_viewport_rect().size.y
	$RightBlock.size.x = get_viewport_rect().size.x * 0.2
	$RightBlock.position.x = get_viewport_rect().size.x * 0.8
	
	$TopBlock.size.y = get_viewport_rect().size.y * 0.9
	$TopBlock.size.x = get_viewport_rect().size.x * 0.6
	$TopBlock.position.x = $LeftBlock.size.x + 0.1
	
	$TopBlock/Discard.size = $TopBlock.size * 0.7
	$TopBlock/Discard.position.x = $TopBlock.size.x * 0.3
	$TopBlock/Discard.position.y = $TopBlock.size.y * 0.3
	
	$TopBlock/Line.size.x = $TopBlock.size.x * 0.41
	$TopBlock/Line.size.y = $HUD/Line.size.y
	$TopBlock/Line.position.y = $HUD/Line.position.y
	$TopBlock/Line.position.x = $TopBlock/Discard.position.x
	
	$LeftBlock.visible = false
	$RightBlock.visible = false
	$TopBlock.visible = false
	
func ablity_activation(dict:Dictionary):
	for card in dict:
		ability_serv.execute_effect(dict[card], cycle_count)
		
func apply_ability(dict:Dictionary):
	for card in dict:
		ability_serv.apply_ability_effect(dict[card], $CombatEffects, $Abilities, cycle_count)
		print("Something Happened")
		
func _on_battle_pressed():
	battle_data_reader()
	generate_turn()
	ablity_activation(ally_on_battle_dict)
	to_battle_phase()
	if ally_on_battle_dict.is_empty() || enemy_on_battle_dict.is_empty():
		print("No card is drawn")
	else:
		battle(turn_call(turn_index))
		advance_turn()
	
func _on_ability_pressed():
	battle_data_reader()
	if ally_on_battle_dict.is_empty():
		print("No card is drawn")
	else:
		print("Something happened")
		apply_ability(ally_on_battle_dict)
		
func _on_end_phase_pressed():
	to_end_phase()

func _on_end_turn_pressed():
	battle_data_reader()
	to_end_turn()
	generate_turn()
	player_turn = false
	enemy_turn = true
	
	$Draw.disabled = true
	$Battle.disabled = true
	$EndPhase.disabled = true
	$EndTurn.disabled = true
	
	$Light.enabled = true
	$HUD/Text.text = "\t\tTurn Ended"
	$HUD.show()
	await get_tree().create_timer(1).timeout
	$Light.enabled = false
	$HUD.hide()
	$HUD/Line.color = Color(1,0,0,1)
	$HUD/Text.text = "\t\tEnemy Turn"
	await get_tree().create_timer(0.5).timeout
	$HUD.show()
	$Light.enabled = true
	if not draw_phase:
		$EnemyField.draw_card()
		$FlipCardSound.play()
	await get_tree().create_timer(1).timeout
	$Light.enabled = false
	$HUD.hide()
	start_enemy_turn()
	battle_status = battle_condition_check()
	print("Battle Over")

func start_enemy_turn():
	if $EnemyField.enemy_rune + $EnemyField.rune_gain_per_turn <= $EnemyField.max_enemy_rune:
		$EnemyField.enemy_rune += $EnemyField.rune_gain_per_turn
	else:
		$EnemyField.enemy_rune = $EnemyField.max_enemy_rune
		
	await $EnemyField.enemy_turn()

	
	battle_data_reader()
	battle(turn_call(turn_index))
	
	
	$Light.enabled = true
	$HUD/Text.text = "\t\tTurn Ended"
	$HUD.show()
	await get_tree().create_timer(1).timeout
	$Light.enabled = false
	$HUD.hide()
	$HUD/Line.color = Color(0,0,1,1)
	$HUD/Text.text = "\t\tPlayer Turn"
	await get_tree().create_timer(0.5).timeout
	$Light.enabled = true
	$HUD.show()
	await get_tree().create_timer(1).timeout
	$Light.enabled = false
	$HUD.hide()
	
	if cycle_count > 1:
		battle(turn_call(turn_index))
	$Draw.disabled = false
	$Battle.disabled = false
	$EndPhase.disabled = false
	$EndTurn.disabled = false
	player_turn = true
	enemy_turn = false
	draw_phase = true
	#advance_turn()
	print("------------Enemy Turn Ends------------")
	await self.get_tree().create_timer(total_wait_time).timeout
	cycle_count += 1
	print("------------Player Turn Starts------------")
		
func to_battle_phase():
	var t_c = title_card.instantiate()
	t_c.set_values_and_animate("BATTLE", $Control.position)
	add_child($Control, true)
	draw_phase = false
	battle_phase = true
	end_phase = false
	
func to_end_phase():
	draw_phase = false
	battle_phase = false
	end_phase = true
	
func to_end_turn():
	draw_phase = false
	battle_phase = false
	end_phase = false
	
func get_damage_number() -> DamageNumber2D:
		return damage_number_2d_template.instantiate()

func spawn_damage_number(value:float, pos):
	var damage_number = get_damage_number()	
	var val = str(round(value))
	var height = 100
	var spread = 1
	add_child(damage_number, true)
	damage_number.set_values_and_animate(val, pos, height, spread)

func _on_draw_phase_pressed():
	draw_phase = true
	battle_phase = false
	end_phase = false

func win():
	var manager_node = get_node("/root/Manager")
	self.visible = true
	self.set_physics_process(false)
	self.set_process_input(false)
	var parent = self.get_parent()
	parent.inst_drop_manager()
	emit_signal("battle_status_changed")
	
func _on_win_pressed():
	win()
