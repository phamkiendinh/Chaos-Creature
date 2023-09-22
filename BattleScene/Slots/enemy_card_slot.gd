extends Node2D

@onready var view_port_size: Vector2 = get_viewport().size
@onready var left_margin: float = view_port_size.x * 0.61 #20% from 0
@onready var top_margin: float = view_port_size.y * 0.3 #30% from 0

@onready var centre_card_oval: Vector2 = view_port_size * Vector2(0.63, 0.1)
@onready var horizontal_radian: float = view_port_size.x * 0.41
@onready var vertical_radian: float = view_port_size.y * 0.1
@onready var field:String = "enemy"

@onready var _MONSTER_ = preload("res://Card/Monster/monster_base.tscn")
@onready var _SPELL_ = preload("res://Card/Spell/spell_base.tscn")
@onready var enemy_deck = Global.enemy_deck

var number_cards_in_hand: int = 0
var angle: float = 0
var card_spread: float = 0.2
var oval_angle_vector: Vector2 = Vector2()
var card_index: int = 0
const max_cards_on_hand: int = 8
var card_spreading: bool = false
var slot_components = 3
#Load Hero Information here later
var life_point
var max_life_point
var max_enemy_rune
var enemy_rune
var time = 0
var rune_gain_per_turn

var card_size = 0

#Load Hero Information here later
# Called when the node enters the scene tree for the first time.
func _ready():
	max_enemy_rune = $Enemy.rune_capacity
	enemy_rune = $Enemy.current_enemy_rune
	rune_gain_per_turn = $Enemy.rune_gain_per_turn
	life_point = $Enemy.life_point
	max_life_point = life_point
	var card = _MONSTER_.instantiate()
	card_size = card.size
	$Deck.scale *= card.size * 0.5 / $Deck.texture.get_size()
	$Deck.position = Vector2(view_port_size.x * 0.95, view_port_size.y * 0.14)
	
	var ideal_size = Vector2(view_port_size.x / 11, view_port_size.y / 8)
	
	var horizontal_gap_between_slots = ideal_size.x * 1.3
	var vertical_gap_between_slots = ideal_size.y * 0.85
	#Scaling All Slots

	$Slot1.scale *= ideal_size / $Slot1/Shape.shape.size
	$Slot2.scale *= ideal_size / $Slot2/Shape.shape.size	
	$Slot3.scale *= ideal_size / $Slot3/Shape.shape.size	
	$Slot4.scale *= ideal_size / $Slot4/Shape.shape.size	
	$Slot5.scale *= ideal_size / $Slot5/Shape.shape.size	
	$Slot6.scale *= ideal_size / $Slot6/Shape.shape.size
	
	$Slot1.slot_id = 1
	$Slot2.slot_id = 2
	$Slot3.slot_id = 3
	$Slot4.slot_id = 4
	$Slot5.slot_id = 5
	$Slot6.slot_id = 6
	
	"""
		Slot Positioning:
			1	2
			3	4
			5	6
	"""
	$Slot2.position += Vector2(left_margin, top_margin)

	$Slot1.position += Vector2(left_margin + horizontal_gap_between_slots * 1.2,top_margin)

	$Slot4.position += Vector2(left_margin, top_margin + vertical_gap_between_slots * 2)

	$Slot3.position += Vector2(left_margin + horizontal_gap_between_slots * 1.2,top_margin + vertical_gap_between_slots * 2)

	$Slot6.position += Vector2(left_margin,top_margin + vertical_gap_between_slots * 4)

	$Slot5.position += Vector2(left_margin + horizontal_gap_between_slots * 1.2,top_margin + vertical_gap_between_slots * 4)


	var life_point_font_size = 27
	
	var slot_1_size = $Slot1.get_node('Image').texture.get_size() * $Slot1.scale
	$LifePoint1.size.x = slot_1_size.x
	$LifePoint1.size.y = slot_1_size.y / 3
	$LifePoint1.position = $Slot1.position
	$LifePoint1.position += Vector2(3,3)
	$LifePoint1/Number.add_theme_font_size_override("normal_font_size", life_point_font_size)
	$LifePoint1/Number.size = $LifePoint1.size
	$LifePoint1/Number.position = Vector2(0,0)
	$LifePoint1.visible = false
	
	var slot_2_size = $Slot2.get_node('Image').texture.get_size() * $Slot2.scale
	$LifePoint2.size.x = slot_2_size.x
	$LifePoint2.size.y = slot_2_size.y / 3
	$LifePoint2.position = $Slot2.position
	$LifePoint2.position += Vector2(3,3)
	$LifePoint2/Number.add_theme_font_size_override("normal_font_size", life_point_font_size)
	$LifePoint2/Number.size = $LifePoint2.size
	$LifePoint2/Number.position = Vector2(0,0)
	$LifePoint2.visible = false
	
	
	var slot_3_size = $Slot3.get_node('Image').texture.get_size() * $Slot3.scale
	$LifePoint3.size.x = slot_3_size.x
	$LifePoint3.size.y = slot_3_size.y / 3
	$LifePoint3.position = $Slot3.position
	$LifePoint3.position += Vector2(3,3)
	$LifePoint3/Number.add_theme_font_size_override("normal_font_size", life_point_font_size)
	$LifePoint3/Number.size = $LifePoint3.size
	$LifePoint3/Number.position = Vector2(0,0)
	$LifePoint3.visible = false
	
	var slot_4_size = $Slot4.get_node('Image').texture.get_size() * $Slot4.scale
	$LifePoint4.size.x = slot_4_size.x
	$LifePoint4.size.y = slot_4_size.y / 3
	$LifePoint4.position = $Slot4.position
	$LifePoint4.position += Vector2(3,3)
	$LifePoint4/Number.add_theme_font_size_override("normal_font_size", life_point_font_size)
	$LifePoint4/Number.size = $LifePoint4.size
	$LifePoint4/Number.position = Vector2(0,0)
	$LifePoint4.visible = false
	
	var slot_5_size = $Slot5.get_node('Image').texture.get_size() * $Slot5.scale
	$LifePoint5.size.x = slot_5_size.x
	$LifePoint5.size.y = slot_5_size.y / 3
	$LifePoint5.position = $Slot5.position
	$LifePoint5.position += Vector2(3,3)
	$LifePoint5/Number.add_theme_font_size_override("normal_font_size", life_point_font_size)
	$LifePoint5/Number.size = $LifePoint5.size
	$LifePoint5/Number.position = Vector2(0,0)
	$LifePoint5.visible = false
	
	var slot_6_size = $Slot6.get_node('Image').texture.get_size() * $Slot6.scale
	$LifePoint6.size.x = slot_6_size.x
	$LifePoint6.size.y = slot_6_size.y / 3
	$LifePoint6.position = $Slot6.position
	$LifePoint6.position += Vector2(3,3)
	$LifePoint6/Number.add_theme_font_size_override("normal_font_size", life_point_font_size)
	$LifePoint6/Number.size = $LifePoint6.size
	$LifePoint6/Number.position = Vector2(0,0)
	$LifePoint6.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$Enemy/Rune.value = enemy_rune 
	$Enemy.current_enemy_rune = enemy_rune
	$Enemy/Rune/Number.text = str($Enemy/Rune.value, "/", max_enemy_rune)
	$Enemy/LifePoint.value = life_point 
	$Enemy/LifePoint/Number.text = str($Enemy/LifePoint.value, "/", max_life_point)
	for i in range(6):
		var slot = self.get_child(i)
		if slot.get_child_count() < slot_components:
			continue
		else:
			if slot.get_child(slot_components - 1).state['spell'] and slot.get_child(slot_components - 1).type == "Utility":
				var card = slot.get_child(slot_components - 1)
				if card.remove_turn == card.get_parent().get_parent().get_parent().turn:
					remove_turn_spell_card(card, slot)
				else:
					print(str(card.name, " has ", card.remove_turn - card.get_parent().get_parent().get_parent().turn, " turns left"))
			else:
				for j in range(slot_components, slot.get_child_count()):
					if slot.get_child(j) == null:
						break
					var card = slot.get_child(j)
					
					if slot.get_child_count() >= slot_components && card.type != "Equip":
						return
						
					if self.enemy_rune - card.rune < 0:
						return

					if card.state['spell']:
						if card.type == "Equip" and slot.get_child_count() <= 2:
							return
						if card.remove_turn > 0:
							if card.remove_turn == card.get_parent().get_parent().get_parent().turn:
								remove_turn_spell_card(card, slot)
							else:
								print(str(card.name, " has ", card.remove_turn - card.get_parent().get_parent().get_parent().turn, " turns left"))



func draw_card():

	var random: int = randi_range(0, enemy_deck.size() - 1)
	var card = enemy_deck[random]

	var template = null
	var new_card = null

	new_card = _MONSTER_.instantiate()
	template = card
	new_card.id = template.get('id')
	new_card.life_point = template.get('life_point')
	new_card.attack_power = template.get('attack_power')
	new_card.affinity = template.get('affinity')
	new_card.status =  template.get('status')
	new_card.image  = template.get('image')
	new_card.attack_type = template.get('attack_type')
	new_card.ability  = template.get('ability')
	new_card.text  = template.get('text')
	new_card.rune  = template.get('rune')
	new_card.life_point = template.get('life_point')
	new_card.max_life_point = template.get('max_life_point')
	new_card.status = template.get('status')
	new_card.mon_name = template.get('name')
	new_card.enemy_card_back = true


	new_card.position = $Deck.position - Vector2(new_card.size.x/4, new_card.size.y/2)
	new_card.start_position = new_card.position 
	new_card.scale *= 0.5
	card_index = 0
	$Hand.add_child(new_card)
	new_card.state['hero'] = false
	new_card.state['ally'] = false
	number_cards_in_hand += 1
	organize_hand()
	
func organize_hand():
	for card in $Hand.get_children(): # reorganise hand
		card.size = card_size
		angle = PI/2 + card_spread * (float(number_cards_in_hand)/2 - card_index)
		oval_angle_vector = Vector2(horizontal_radian * cos(angle),  vertical_radian * sin(angle))
		card.target_position = centre_card_oval + oval_angle_vector - card.size
		card.hand_position = card.target_position
		card.start_rotation = card.rotation
		card.target_rotation = - (PI) - (PI/2 - angle) / 6
		card.card_index = card_index
		card.in_hand_rotation = card.target_rotation
		card_index += 1
		if card.state['on_hand']:
			card.state['organize'] = true
			card.start_position = card.position
			
func remove_card_from_hand(index: int):
	card_index = 0
	number_cards_in_hand -= 1
	var current_index: int = 0
	for card in $Hand.get_children():
		card.card_index = current_index
		current_index += 1
	organize_hand()

func enemy_turn():
	var monster_type_on_field:int = 0
	var spell_type_on_field:int = 0
	var monster_type_on_hand:int = 0
	var spell_type_on_hand:int = 0
	var empty_position:Array = []


	var current_enemy_rune = self.enemy_rune
	var rune_gain_per_turn = $Enemy.rune_gain_per_turn
	var rune_capacity = $Enemy.rune_capacity
	
	
	for i in range(6):
		if not self.get_child(i).get_child_count() < 3:
			var child_on_field = self.get_child(i).get_child(2)
			var child_on_hand = $Hand.get_child(i)
			#if child_on_field.state['spell']:
			#	spell_type_on_field += 1
			#else:
			#	monster_type_on_field += 1
			#if child_on_hand.state['spell'] and child_on_hand.rune <= current_enemy_rune:
			#	spell_type_on_hand += 1
			#if child_on_hand.state['monster'] and child_on_hand.rune <= current_enemy_rune:
			#	monster_type_on_hand += 1
		else:
			empty_position.append(i)
	if not empty_position.size() == 0:
		while (current_enemy_rune > 0):
			var monster_card = choose_monster_card(current_enemy_rune)
			#var spell_card = choose_spell_card(current_enemy_rune)
			if monster_card == null: #|| spell_card == null:
				break
			current_enemy_rune -= move_monster_card(monster_card, current_enemy_rune, empty_position)
			enemy_rune = current_enemy_rune
			await get_tree().create_timer(1).timeout
			#continue
			#if monster_type_on_hand < spell_type_on_hand:
			#	current_enemy_rune -= move_monster_card(monster_card, current_enemy_rune, empty_position)
			#	enemy_rune = current_enemy_rune
			#else:
			#	current_enemy_rune -= move_spell_card(spell_card, current_enemy_rune, empty_position)
			#	enemy_rune = current_enemy_rune

func choose_monster_card(current_enemy_rune):
	var max_rune_monster_child = null
	var current_max_rune = 0
	for child in $Hand.get_children():
		if child.state['monster']:
			if child.rune == current_enemy_rune:
				max_rune_monster_child = child
				break
			if child.rune > current_max_rune and child.rune < current_enemy_rune:
				current_max_rune = child.rune
				max_rune_monster_child = child
	return max_rune_monster_child

func choose_spell_card(current_enemy_rune):
	var max_rune_spell_child = null
	var current_max_rune = 0
	for child in $Hand.get_children():
		if child.state['spell']:
			if child.rune > current_max_rune and child.rune <= current_enemy_rune:
				current_max_rune = child.rune
				max_rune_spell_child = child
	return max_rune_spell_child
	
func move_monster_card(card, rune, empty_position):
	#if empty_position.size == 0:
	#	return
	var slot = self.get_child(empty_position[0])
	var image = slot.get_node('Image')
	var temp = card
	$Hand.remove_child(card)
	card = temp
	self.remove_card_from_hand(card.card_index)
	card.start_position  = card.hand_position
	card.target_position = image.position
	card.target_position.x += card.size.x / 5
	card.target_position.y -= card.size.y / 30
	card.start_scale = card.scale
	card.target_scale = Vector2((slot.get_node("Shape").shape.size.y / card.size.x) * 0.7, (slot.get_node("Shape").shape.size.x / card.size.y) * 0.7)
	card.state['in_slot'] = true
	card.state['in_mouse'] = false
	card.state['zoom_in'] = false
	card.state['on_hand'] = false
	card.time = 0
	card.target_rotation = deg_to_rad(90)
	card.get_node('CardBack').visible = false
	if card.state['monster']:
		initiate_slot_life_point(card,slot)
	$Enemy.current_enemy_rune -= card.rune
	slot.add_child(card)
	empty_position.pop_front()
	return card.rune
	
func move_spell_card(card, rune, empty_position):
		
	var slot = self.get_child(empty_position[0])
	var image = slot.get_node('Image')
	$Hand.remove_child(card)
	self.remove_card_from_hand(card.card_index)
	card.start_position  = get_global_mouse_position() - card.size / 2
	card.target_position = image.position
	card.target_position.x += card.size.x / 2
	card.start_scale = card.scale
	card.target_scale = Vector2(slot.get_node('Shape').shape.size.x / card.size.x * 0.85, slot.get_node('Shape').shape.size.y / card.size.y * 1.35)
	card.state['in_slot'] = true
	card.state['in_mouse'] = false
	card.state['zoom_in'] = false
	card.state['on_hand'] = false
	card.time = 0
	card.target_rotation = deg_to_rad(90)
	card.get_node('CardBack').visible = false
	if card.state['monster']:
		initiate_slot_life_point(card,slot)
	$Enemy.current_enemy_rune -= card.rune
	slot.add_child(card)
	empty_position.pop_front()
	return card.rune



func play_spell_card(card: Object, slot: Object, image: Object, shape: Object):
	var id = card.id
	match id:
		#Draw 2 cards
		1:
			slot.add_child(card)
			await get_tree().create_timer(card.organize_time).timeout
			self.get_parent().draw_card()
			await get_tree().create_timer(card.organize_time).timeout
			self.get_parent().draw_card()
			slot.remove_child(card)
			if self.get_parent().number_cards_in_hand >= self.get_parent().max_cards_on_hand:
				self.get_parent().get_parent().discard = true
				self.get_parent().get_parent().number_card_to_remove = self.get_parent().number_cards_in_hand - self.get_parent().max_cards_on_hand
			pass
		#Draw 1 card
		2:
			slot.add_child(card)
			await get_tree().create_timer(card.organize_time).timeout
			self.get_parent().draw_card()
			slot.remove_child(card)
			pass
		#Gain 2 runes
		3: 
			slot.add_child(card)
			await get_tree().create_timer(card.organize_time).timeout
			self.get_parent().hero_rune += 2
			slot.remove_child(card)
			pass
		#Heal a monster for 200 lp
		4: 
			card.target_scale = Vector2(shape.shape.size.x / card.size.x * 0.45, shape.shape.size.y / card.size.y * 0.65)
			slot.add_child(card)
			await get_tree().create_timer(card.organize_time).timeout
			if slot.get_child(2).life_point + 200 < slot.get_child(2).max_life_point:
				slot.get_child(2).life_point += 200
			else:
				slot.get_child(2).life_point = slot.get_child(2).max_life_point
			update_slot_life_point(slot.get_child(2),slot)
			slot.remove_child(card)
			pass
		#Heal all monsters to full health
		5:
			slot.add_child(card)
			await get_tree().create_timer(card.organize_time).timeout
			for hero_slot in self.get_children():
				if hero_slot.get_child_count() >= 3:
					var monster = hero_slot.get_child(2)
					if not monster.state['spell']:
						monster.life_point = monster.max_life_point
						update_slot_life_point(monster, hero_slot)
			slot.remove_child(card)
			pass
		# +10% attack power
		6:
			card.target_scale = Vector2(shape.shape.size.x / card.size.x * 0.45, shape.shape.size.y / card.size.y * 0.65)
			slot.add_child(card)
			await get_tree().create_timer(card.organize_time).timeout
			var monster = slot.get_child(2)
			print(str("Monster's current attack power: ", monster.attack_power))
			monster.attack_power += monster.attack_power * 0.1
			print(str("Monster's after attack power: ", monster.attack_power))
			slot.remove_child(card)
			pass
		#x2 lp for 1 turn
		7:
			slot.add_child(card)
			card.target_scale = Vector2(shape.shape.size.x / card.size.x * 0.45, shape.shape.size.y / card.size.y * 0.65)
			await get_tree().create_timer(card.organize_time).timeout
			card.remove_turn = self.get_parent().get_parent().get_parent().turn + 1
			slot.get_child(2).life_point *= 2
			slot.get_child(2).max_life_point *= 2
			update_slot_life_point(slot.get_child(2), slot)
			pass
		#+100% attack power
		8:
			card.target_scale = Vector2(shape.shape.size.x / card.size.x * 0.45, shape.shape.size.y / card.size.y * 0.65)
			slot.add_child(card)
			await get_tree().create_timer(card.organize_time).timeout
			var monster = slot.get_child(2)
			print(str("Monster's current attack power: ", monster.attack_power))
			monster.attack_power += monster.attack_power
			print(str("Monster's after attack power: ", monster.attack_power))
			slot.remove_child(card)
			pass
		#x2 lp for 3 turns
		9:
			slot.add_child(card)
			card.target_scale = Vector2(shape.shape.size.x / card.size.x * 0.45, shape.shape.size.y / card.size.y * 0.65)
			await get_tree().create_timer(card.organize_time).timeout
			card.remove_turn = self.get_parent().get_parent().get_parent().turn + 3
			slot.get_child(2).life_point *= 2
			slot.get_child(2).max_life_point *= 2
			update_slot_life_point(slot.get_child(2), slot)
			pass
		#Stop enemy attack for 1 turn
		10:
			slot.add_child(card)
			await get_tree().create_timer(card.organize_time).timeout
			card.remove_turn = self.get_parent().get_parent().get_parent().turn + 1
			slot.remove_child(card)
			pass
		#Discard 2 cards to play a monster
		11:
			slot.add_child(card)
			await get_tree().create_timer(card.organize_time).timeout
			slot.remove_child(card)
			pass
		#Dispell all cards equip on an enemy card
		12:
			
			pass
		#Heal a monster for 200lp
		13:
			card.target_scale = Vector2(shape.shape.size.x / card.size.x * 0.45, shape.shape.size.y / card.size.y * 0.65)
			slot.add_child(card)
			slot.get_child(2).life_point = 10
			update_slot_life_point(slot.get_child(2),slot)
			await get_tree().create_timer(card.organize_time).timeout
			if slot.get_child(2).life_point + slot.get_child(2).life_point * 0.2 < slot.get_child(2).max_life_point:
				slot.get_child(2).life_point += slot.get_child(2).life_point * 0.2
			else:
				slot.get_child(2).life_point = slot.get_child(2).max_life_point
			update_slot_life_point(slot.get_child(2), slot)
			slot.remove_child(card)
			pass
		#Dispell all equip cards on all enemy monsters
		14:
			pass
		#Destroy all enemy monsters
		15:
			slot.add_child(card)
			var enemy_field = self.get_parent().get_parent().get_node("EnemyField")
			for i in range(6):
				var enemy_slot = enemy_field.get_child(i)
				if enemy_slot.get_child_count() >= 3:
					enemy_field.get_child(i + 6).visible = false
					enemy_slot.remove_child(enemy_slot.get_child(2))
			await get_tree().create_timer(card.organize_time).timeout
			slot.remove_child(card)
			pass
		#Light Ray
		16:
			for affinity in slot.get_child(2).affinity:
				if affinity == "light":
					return
			slot.add_child(card)
			slot.get_child(2).affinity.append("light")
			card.target_scale = Vector2(shape.shape.size.x / card.size.x * 0.45, shape.shape.size.y / card.size.y * 0.65)
			await get_tree().create_timer(card.organize_time).timeout
			card.remove_turn = self.get_parent().get_parent().get_parent().turn + 2
			pass
		#Dark Ray
		17:
			for affinity in slot.get_child(2).affinity:
				if affinity == "dark":
					return
			slot.add_child(card)
			slot.get_child(2).affinity.append("dark")
			card.target_scale = Vector2(shape.shape.size.x / card.size.x * 0.45, shape.shape.size.y / card.size.y * 0.65)
			await get_tree().create_timer(card.organize_time).timeout
			card.remove_turn = self.get_parent().get_parent().get_parent().turn + 2
			pass

		#Fire Ray
		18:
			for affinity in slot.get_child(2).affinity:
				if affinity == "fire":
					return
			slot.add_child(card)
			slot.get_child(2).affinity.append("fire")
			card.target_scale = Vector2(shape.shape.size.x / card.size.x * 0.45, shape.shape.size.y / card.size.y * 0.65)
			await get_tree().create_timer(card.organize_time).timeout
			card.remove_turn = self.get_parent().get_parent().get_parent().turn + 2
			pass
		#Water Ray
		19:
			for affinity in slot.get_child(2).affinity:
				if affinity == "water":
					return
			slot.add_child(card)
			slot.get_child(2).affinity.append("water")
			card.target_scale = Vector2(shape.shape.size.x / card.size.x * 0.45, shape.shape.size.y / card.size.y * 0.65)
			await get_tree().create_timer(card.organize_time).timeout
			card.remove_turn = self.get_parent().get_parent().get_parent().turn + 2
			pass
		#Wind Ray
		20:
			for affinity in slot.get_child(2).affinity:
				if affinity == "wind":
					return
			slot.add_child(card)
			slot.get_child(2).affinity.append("wind")
			card.target_scale = Vector2(shape.shape.size.x / card.size.x * 0.45, shape.shape.size.y / card.size.y * 0.65)
			await get_tree().create_timer(card.organize_time).timeout
			card.remove_turn = self.get_parent().get_parent().get_parent().turn + 2
			pass
		#Light Field
		21:
			slot.add_child(card)
			for i in range(6):
				var children = slot.get_parent().get_child(i)
				var exist_affinity:bool = false
				if children.get_child_count() < 3 || children.get_child(2).state['spell']:
					continue
				for affinity in children.get_child(2).affinity:
					if affinity == "light":
						exist_affinity = true
						break
				if not exist_affinity:
					children.get_child(2).affinity.append("light")
			await get_tree().create_timer(card.organize_time).timeout
			card.remove_turn = self.get_parent().get_parent().get_parent().turn + 2
			pass
		#Dark Field
		22:
			slot.add_child(card)
			for i in range(6):
				var children = slot.get_parent().get_child(i)
				var exist_affinity:bool = false
				if children.get_child_count() < 3 || children.get_child(2).state['spell']:
					continue
					
				for affinity in children.get_child(2).affinity:
					if affinity == "dar":
						exist_affinity = true
						break
				if not exist_affinity:
					children.get_child(2).affinity.append("dark")
			await get_tree().create_timer(card.organize_time).timeout
			card.remove_turn = self.get_parent().get_parent().get_parent().turn + 2
			pass
		#Fire Field
		23:
			slot.add_child(card)
			for i in range(6):
				var children = slot.get_parent().get_child(i)
				var exist_affinity:bool = false
				if children.get_child_count() < 3 || children.get_child(2).state['spell']:
					continue
				for affinity in children.get_child(2).affinity:
					if affinity == "fire":
						exist_affinity = true
						break
				if not exist_affinity:
					children.get_child(2).affinity.append("fire")
			await get_tree().create_timer(card.organize_time).timeout
			card.remove_turn = self.get_parent().get_parent().get_parent().turn + 2
			pass
		#Water Field
		24:
			slot.add_child(card)
			for i in range(6):
				var children = slot.get_parent().get_child(i)
				var exist_affinity:bool = false
				if children.get_child_count() < 3 || children.get_child(2).state['spell']:
					continue
				for affinity in children.get_child(2).affinity:
					if affinity == "water":
						exist_affinity = true
						break
				if not exist_affinity:
					children.get_child(2).affinity.append("water")
			await get_tree().create_timer(card.organize_time).timeout
			card.remove_turn = self.get_parent().get_parent().get_parent().turn + 2
			pass
		#Wind Field
		25:
			slot.add_child(card)
			for i in range(6):
				var children = slot.get_parent().get_child(i)
				var exist_affinity:bool = false
				if children.get_child_count() < 3 || children.get_child(2).state['spell']:
					continue
					
				for affinity in children.get_child(2).affinity:
					if affinity == "wind":
						exist_affinity = true
						break
				if not exist_affinity:
					children.get_child(2).affinity.append("wind")
			await get_tree().create_timer(card.organize_time).timeout
			card.remove_turn = self.get_parent().get_parent().get_parent().turn + 2
			pass
		

func remove_turn_spell_card(card: Object, slot: Object):
	var id = card.id
	match id:
		7:
			slot.get_child(2).life_point /= 2
			slot.get_child(2).max_life_point /= 2
			update_slot_life_point(slot.get_child(2), slot)
			slot.remove_child(card)
			pass
		9:
			slot.get_child(2).life_point /= 2
			slot.get_child(2).max_life_point /= 2
			update_slot_life_point(slot.get_child(2), slot)
			slot.remove_child(card)
			pass
		16:
			slot.get_child(2).affinity.remove_at(slot.get_child(2).affinity.find("light"))
			slot.remove_child(card)
			pass
		17:
			slot.get_child(2).affinity.remove_at(slot.get_child(2).affinity.find("dark"))
			slot.remove_child(card)
			pass
		18:
			slot.get_child(2).affinity.remove_at(slot.get_child(2).affinity.find("fire"))
			slot.remove_child(card)
			pass
		19:
			slot.get_child(2).affinity.remove_at(slot.get_child(2).affinity.find("water"))
			slot.remove_child(card)
			pass
		20:
			slot.get_child(2).affinity.remove_at(slot.get_child(2).affinity.find("wind"))
			slot.remove_child(card)
			pass
		21:
			for child in slot.get_parent().get_children():
				if child.get_child_count() >= 3:
					if child.get_child(2).state['monster']:
						child.get_child(2).affinity.remove_at(child.get_child(2).affinity.find("light"))
			slot.remove_child(card)
			pass
		22:
			for child in slot.get_parent().get_children():
				if child.get_child_count() >= 3:
					if child.get_child(2).state['monster']:
						child.get_child(2).affinity.remove_at(child.get_child(2).affinity.find("dark"))
			slot.remove_child(card)
			pass
		23:
			for child in slot.get_parent().get_children():
				if child.get_child_count() >= 3:
					if child.get_child(2).state['monster']:
						child.get_child(2).affinity.remove_at(child.get_child(2).affinity.find("fire"))
			slot.remove_child(card)
			pass
		24:
			for child in slot.get_parent().get_children():
				if child.get_child_count() >= 3:
					if child.get_child(2).state['monster']:
						child.get_child(2).affinity.remove_at(child.get_child(2).affinity.find("water"))
			slot.remove_child(card)
			pass
		25:
			for child in slot.get_parent().get_children():
				if child.get_child_count() >= 3:
					if child.get_child(2).state['monster']:
						child.get_child(2).affinity.remove_at(child.get_child(2).affinity.find("wind"))
			slot.remove_child(card)
			pass


func update_slot_life_point(card: Object, slot: Object):
	var id: int = slot.slot_id
	match id:
		1:
			$LifePoint1.max_value = card.max_life_point
			$LifePoint1.value = card.life_point
			$LifePoint1/Number.text = str("[center]", card.life_point, "[/center]")
		2:
			$LifePoint2.max_value = card.max_life_point
			$LifePoint2.value = card.life_point
			$LifePoint2/Number.text = str("[center]", card.life_point, "[/center]")
		3:
			$LifePoint3.max_value = card.max_life_point
			$LifePoint3.value = card.life_point			
			$LifePoint3/Number.text = str("[center]", card.life_point, "[/center]")
		4:
			$LifePoint4.max_value = card.max_life_point
			$LifePoint4.value = card.life_point			
			$LifePoint4/Number.text = str("[center]", card.life_point, "[/center]")
		5:
			$LifePoint5.max_value = card.max_life_point
			$LifePoint5.value = card.life_point
			$LifePoint5/Number.text = str("[center]", card.life_point, "[/center]")
		6:
			$LifePoint6.max_value = card.max_life_point
			$LifePoint6.value = card.life_point
			$LifePoint6/Number.text = str("[center]", card.life_point, "[/center]")

func initiate_slot_life_point(card: Object, slot:Object):
	var id = slot.slot_id
	match id:
		1:
			$LifePoint1.max_value = card.max_life_point
			$LifePoint1.value = card.life_point
			$LifePoint1/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint1/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint1/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint1.visible = true
		2:
			$LifePoint2.max_value = card.max_life_point
			$LifePoint2.value = card.life_point
			$LifePoint2/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint2/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint2/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint2.visible = true
		3:
			$LifePoint3.max_value = card.max_life_point
			$LifePoint3.value = card.life_point			
			$LifePoint3/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint3/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint3/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint3.visible = true
		4:
			$LifePoint4.max_value = card.max_life_point
			$LifePoint4.value = card.life_point
			$LifePoint4/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint4/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint4/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint4.visible = true
		5:
			$LifePoint5.max_value = card.max_life_point
			$LifePoint5.value = card.life_point
			$LifePoint5/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint5/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint5/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint5.visible = true
		6:
			$LifePoint6.max_value = card.max_life_point
			$LifePoint6.value = card.life_point
			$LifePoint6/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint6/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint6/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint6.visible = true
