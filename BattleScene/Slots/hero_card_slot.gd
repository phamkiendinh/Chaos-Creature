extends Node2D

@onready var view_port_size: Vector2 = get_viewport().size
@onready var left_margin: float = view_port_size.x * 0.15 #20% from 0
@onready var top_margin: float  = view_port_size.y * 0.3 #30% from 0
@onready var slot_components: int = 3
@onready var ability_index: int = -1
@onready var ability_slot_index: int = -1
@onready var field:String = "ally"

@onready var slot_size: Vector2 = Vector2(view_port_size.x / 11, view_port_size.y / 8)
@onready var ability_slot_size: Vector2 = Vector2(view_port_size.x / 25, view_port_size.y / 15)
@onready var vertical_gap_between_slots: float = slot_size.y * 0.85
@onready var horizontal_margin_between_slot_and_ability: float = slot_size.x
@onready var horizontal_gap_between_slots: float = slot_size.x * 1.3

@onready var slot_index:int = -1
@onready var current_area:Object = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Ability.visible = false
	
	#Scaling All Slots

	$Slot1.scale *= slot_size / $Slot1/Shape.shape.size
	$Slot2.scale *= slot_size / $Slot2/Shape.shape.size
	$Slot3.scale *= slot_size / $Slot3/Shape.shape.size
	$Slot4.scale *= slot_size / $Slot4/Shape.shape.size
	$Slot5.scale *= slot_size / $Slot5/Shape.shape.size
	$Slot6.scale *= slot_size / $Slot6/Shape.shape.size
	
	$Slot1.slot_id = 1
	$Slot2.slot_id = 2
	$Slot3.slot_id = 3
	$Slot4.slot_id = 4
	$Slot5.slot_id = 5
	$Slot6.slot_id = 6
	
	$AbilitySlot1.scale *= ability_slot_size / $AbilitySlot1/Shape.shape.size
	$AbilitySlot2.scale *= ability_slot_size / $AbilitySlot2/Shape.shape.size
	$AbilitySlot3.scale *= ability_slot_size / $AbilitySlot3/Shape.shape.size
	$AbilitySlot4.scale *= ability_slot_size / $AbilitySlot4/Shape.shape.size
	$AbilitySlot5.scale *= ability_slot_size / $AbilitySlot5/Shape.shape.size
	$AbilitySlot6.scale *= ability_slot_size / $AbilitySlot6/Shape.shape.size
	
	$AbilitySlot1.ability_slot_id = 1
	$AbilitySlot2.ability_slot_id = 2
	$AbilitySlot3.ability_slot_id = 3
	$AbilitySlot4.ability_slot_id = 4
	$AbilitySlot5.ability_slot_id = 5
	$AbilitySlot6.ability_slot_id = 6
	
	
	"""
		Slot Positioning:
			1	2
			3	4
			5	6
	"""
	$Slot1.position += Vector2(left_margin,top_margin)
	
	
	$Slot2.position += Vector2(left_margin + horizontal_gap_between_slots * 1.2,top_margin)


	$Slot3.position += Vector2(left_margin, top_margin + vertical_gap_between_slots * 2)

	
	$Slot4.position += Vector2(left_margin + horizontal_gap_between_slots * 1.2,top_margin + vertical_gap_between_slots * 2)
	
	
	$Slot5.position += Vector2(left_margin,top_margin + vertical_gap_between_slots * 4)
	

	$Slot6.position += Vector2(left_margin + horizontal_gap_between_slots * 1.2,top_margin + vertical_gap_between_slots * 4)
	
	"""
		Ability Slot Position
	"""
	$AbilitySlot1.position += Vector2(left_margin + horizontal_margin_between_slot_and_ability, top_margin * 0.6)
	
	
	$AbilitySlot2.position += Vector2(left_margin + horizontal_gap_between_slots * 1.2 + horizontal_margin_between_slot_and_ability,top_margin * 0.6)


	$AbilitySlot3.position += Vector2(left_margin + horizontal_margin_between_slot_and_ability, top_margin * 1.3)

	
	$AbilitySlot4.position += Vector2(left_margin + horizontal_gap_between_slots * 1.2 + horizontal_margin_between_slot_and_ability,top_margin * 1.3)
	
	
	$AbilitySlot5.position += Vector2(left_margin + horizontal_margin_between_slot_and_ability,top_margin * 2.05)
	

	$AbilitySlot6.position += Vector2(left_margin + horizontal_gap_between_slots * 1.2 + horizontal_margin_between_slot_and_ability,top_margin * 2.05)
	
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

func _input(event):
	if Input.is_action_just_pressed("left_click"):
		pass
		
	if Input.is_action_just_released("left_click"):
		if slot_index != -1 and current_area != null:
			match slot_index:
				1:
					call_deferred('update_card', current_area, $Slot1, $Slot1/Image, $Slot1/Shape)
				2:
					call_deferred('update_card', current_area, $Slot2, $Slot2/Image, $Slot2/Shape)
				3:
					call_deferred('update_card', current_area, $Slot3, $Slot3/Image, $Slot3/Shape)
				4:
					call_deferred('update_card', current_area, $Slot4, $Slot4/Image, $Slot4/Shape)
				5:
					call_deferred('update_card', current_area, $Slot5, $Slot5/Image, $Slot5/Shape)
				6:
					call_deferred('update_card', current_area, $Slot6, $Slot6/Image, $Slot6/Shape)


	if Input.is_action_just_released("right_click") and ability_index != -1:
		match ability_index:
			1:
				var slot = $Slot1
				var ability_slot = $AbilitySlot1
				if slot.get_child_count() < 3:
					return
				else:
					var card = slot.get_child(2)
					update_ability_popup(card, slot, ability_slot)
			2:
				var slot = $Slot2
				var ability_slot = $AbilitySlot2
				if slot.get_child_count() < 3:
					return
				else:
					var card = slot.get_child(2)
					update_ability_popup(card, slot, ability_slot)
			3:
				var slot = $Slot3
				var ability_slot = $AbilitySlot3
				if slot.get_child_count() < 3:
					return
				else:
					var card = slot.get_child(2)
					update_ability_popup(card, slot, ability_slot)
			4:
				var slot = $Slot4
				var ability_slot = $AbilitySlot4
				if slot.get_child_count() < 3:
					return
				else:
					var card = slot.get_child(2)
					update_ability_popup(card, slot, ability_slot)
			5:
				var slot = $Slot5
				var ability_slot = $AbilitySlot5
				if slot.get_child_count() < 3:
					return
				else:
					var card = slot.get_child(2)
					update_ability_popup(card, slot, ability_slot)
			6:
				var slot = $Slot6
				var ability_slot = $AbilitySlot6
				if slot.get_child_count() < 3:
					return
				else:
					var card = slot.get_child(2)
					update_ability_popup(card, slot, ability_slot)

func _physics_process(delta):
	for i in range(6):
		var slot = self.get_child(i)
		if slot.get_child_count() < slot_components:
			continue
		else:
			if slot.get_child(slot_components - 1).state['spell'] and slot.get_child(slot_components - 1).type == "Utility":
				var card = slot.get_child(slot_components - 1)
				if card.remove_turn == card.get_parent().get_parent().get_parent().get_parent().turn:
					remove_turn_spell_card(card, slot)
				else:
					print(str(card.name, " has ", card.remove_turn - card.get_parent().get_parent().get_parent().get_parent().turn, " turns left"))
			else:
				for j in range(slot_components, slot.get_child_count()):
					if slot.get_child(j) == null:
						break
					var card = slot.get_child(j)
					if card.state['spell']:
						if card.remove_turn > 0:
							if card.remove_turn == card.get_parent().get_parent().get_parent().get_parent().turn:
								remove_turn_spell_card(card, slot)
							else:
								print(str(card.name, " has ", card.remove_turn - card.get_parent().get_parent().get_parent().get_parent().turn, " turns left"))

func update_card(area: Object, slot: Object, image, shape: Object):
	var path = get_node('../Hand')
	for i in range(path.get_child_count()):
		if path.get_child(i) == area.get_parent():
			if path.get_child(i) == null:
				break
			var card = path.get_child(i)
			if not card.state['in_mouse']:
				if card.state['organize'] || card.state['zoom_in'] || card.state['spreading'] || card.state['start'] || card.state['in_hand']:
					return
			if slot.get_child_count() >= 3 && not card.state['spell']:
				return
			#Only allow player to play spells on empty slot if not an equipment card
			if slot.get_child_count() >=3 && card.type != "Equip":
				return
			if self.get_parent().hero_rune - card.rune < 0:
				return
			if card.state['spell']:
				if card.type == "Equip" and slot.get_child_count() <= 2:
					return
					
			#card.get_node('$Layout/ImageContainer').set_custom_minimum_size(card.get_node('$Layout/ImageContainer').get_custom_minimum_size().x, card.get_node('$Layout/ImageContainer').get_custom_minimum_size().y + card.get_node('Layout/Description/Content/Label').get_custom_minimum_size().y)
			#card.get_node('$Layout/ImageContainer/LeftGap').set_custom_minimum_size(card.get_node('$Layout/ImageContainer').get_custom_minimum_size())
			#card.get_node('$Layout/ImageContainer/Container/Image').scale *= card.get_node('$Layout/ImageContainer').get_custom_minimum_size() / card.get_node('$Layout/ImageContainer/Container/Image').texture.get_size()
			card.get_node('Layout/Description').queue_free()
			path.remove_child(card)
			get_node('../../PlayerField').remove_card_from_hand(card.card_index)
			card.start_position = get_global_mouse_position() - card.size / 2
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
			if card.state['monster']:
				initiate_slot_life_point(card,slot)
			self.get_parent().hero_rune -= card.rune
			if card.state['spell']:
				if card.type == "Equip" && card.turn >= 1:
					card.target_position.x += card.size.x * 0.4
					card.target_position.y += card.size.y * 0.7
				play_spell_card(card, slot, image, shape)
			else:
				slot.add_child(card)
			break

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
			card.remove_turn = self.get_parent().get_parent().turn + 1
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
			card.remove_turn = self.get_parent().get_parent().turn + 3
			slot.get_child(2).life_point *= 2
			slot.get_child(2).max_life_point *= 2
			update_slot_life_point(slot.get_child(2), slot)
			pass
		#Stop enemy attack for 1 turn
		10:
			slot.add_child(card)
			await get_tree().create_timer(card.organize_time).timeout
			card.remove_turn = self.get_parent().get_parent().turn + 1
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
			card.remove_turn = self.get_parent().get_parent().turn + 2
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
			card.remove_turn = self.get_parent().get_parent().turn + 2
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
			card.remove_turn = self.get_parent().get_parent().turn + 2
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
			card.remove_turn = self.get_parent().get_parent().turn + 2
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
			card.remove_turn = self.get_parent().get_parent().turn + 2
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
			card.remove_turn = self.get_parent().get_parent().turn + 2
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
					if affinity == "dark":
						exist_affinity = true
						break
				if not exist_affinity:
					children.get_child(2).affinity.append("dark")
			await get_tree().create_timer(card.organize_time).timeout
			card.remove_turn = self.get_parent().get_parent().turn + 2
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
			card.remove_turn = self.get_parent().get_parent().turn + 2
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
			card.remove_turn = self.get_parent().get_parent().turn + 2
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
			card.remove_turn = self.get_parent().get_parent().turn + 2
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
	var id = slot.slot_id
	match id:
		1:
			$LifePoint1.max_value = card.max_life_point
			$LifePoint1.value = card.life_point
			$LifePoint1/Number.text =str("[center]", card.life_point, "[/center]")
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

func initiate_slot_life_point(card: Object,slot: Object):
	var id = slot.slot_id
	match id:
		1:
			$LifePoint1.max_value = card.max_life_point
			$LifePoint1.value = card.life_point
			$LifePoint1/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint1.visible = true
		2:
			$LifePoint2.max_value = card.max_life_point
			$LifePoint2.value = card.life_point
			$LifePoint2/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint2.visible = true
		3:
			$LifePoint3.max_value = card.max_life_point
			$LifePoint3.value = card.life_point			
			$LifePoint3/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint3.visible = true
		4:
			$LifePoint4.max_value = card.max_life_point
			$LifePoint4.value = card.life_point			
			$LifePoint4/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint4.visible = true
		5:
			$LifePoint5.max_value = card.max_life_point
			$LifePoint5.value = card.life_point
			$LifePoint5/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint5.visible = true
		6:
			$LifePoint6.max_value = card.max_life_point
			$LifePoint6.value = card.life_point
			$LifePoint6/Number.text = str("[center]", card.life_point, "[/center]")
			$LifePoint6.visible = true

func update_ability_popup(card: Object, slot: Object, ability_slot: Object):
	$Ability.clear()
	var mouse_position: Vector2 = get_global_mouse_position()
	for ability in card.ability:
		$Ability.add_item(ability)
	$Ability.popup(Rect2(mouse_position.x, mouse_position.y, $Ability.size.x, 0))
	return
	

func _on_slot_1_area_entered(area: Object):
	self.slot_index = 1
	current_area = area

func _on_slot_2_area_entered(area: Object):
	self.slot_index = 2
	current_area = area

func _on_slot_3_area_entered(area: Object):
	self.slot_index = 3	
	current_area = area

func _on_slot_4_area_entered(area: Object):
	self.slot_index = 4
	current_area = area

func _on_slot_5_area_entered(area: Object):
	self.slot_index = 5
	current_area = area
	
func _on_slot_6_area_entered(area: Object):
	self.slot_index = 6
	current_area = area

func _on_ability_slot_1_mouse_entered():
	self.ability_index = 1


func _on_ability_slot_1_mouse_exited():
	self.ability_index = -1


func _on_ability_slot_2_mouse_entered():
	self.ability_index = 2


func _on_ability_slot_2_mouse_exited():
	self.ability_index = -1


func _on_ability_slot_3_mouse_entered():
	self.ability_index = 3


func _on_ability_slot_3_mouse_exited():
	self.ability_index = -1


func _on_ability_slot_4_mouse_entered():
	self.ability_index = 4


func _on_ability_slot_4_mouse_exited():
	self.ability_index = -1


func _on_ability_slot_5_mouse_entered():
	self.ability_index = 5


func _on_ability_slot_5_mouse_exited():
	self.ability_index = -1


func _on_ability_slot_6_mouse_entered():
	self.ability_index = 6

func _on_ability_slot_6_mouse_exited():
	self.ability_index = -1


func _on_ability_index_pressed(index: int):
	self.ability_slot_index = ability_index
	var slot: Object
	var ability_slot: Object
	var card: Object
	var ability: String
	var font_size = 16
	match ability_slot_index:
		1:
			slot = $Slot1
			ability_slot = $AbilitySlot1
			if slot.get_child_count() < 3:
				return
			else:
				card = slot.get_child(2)
				ability = card.ability[index]
				card.active_ability = ability
		2:
			slot = $Slot2
			ability_slot = $AbilitySlot2
			if slot.get_child_count() < 3:
				return
			else:
				card = slot.get_child(2)
				ability = card.ability[index]
				card.active_ability = ability
		3:
			slot = $Slot3
			ability_slot = $AbilitySlot3
			if slot.get_child_count() < 3:
				return
			else:
				card = slot.get_child(2)
				ability = card.ability[index]
				card.active_ability = ability
		4:
			slot = $Slot4
			ability_slot = $AbilitySlot4
			if slot.get_child_count() < 3:
				return
			else:
				card = slot.get_child(2)
				ability = card.ability[index]
				card.active_ability = ability
		5:
			slot = $Slot5
			ability_slot = $AbilitySlot5
			if slot.get_child_count() < 3:
				return
			else:
				card = slot.get_child(2)
				ability = card.ability[index]
				card.active_ability = ability
		6:
			slot = $Slot6
			ability_slot = $AbilitySlot6
			if slot.get_child_count() < 3:
				return
			else:
				card = slot.get_child(2)
				ability = card.ability[index]
				card.active_ability = ability

	var image = ability_slot.get_child(1)
	var element
	image.set_texture(element)
	if ability_slot.scaled == false:
		image.scale *= ability_slot.get_child(0).shape.size / image.texture.get_size()
		ability_slot.scaled = true


func _on_slot_1_area_exited(area):
	slot_index = -1
	current_area = null

func _on_slot_2_area_exited(area):
	slot_index = -1
	current_area = null

func _on_slot_3_area_exited(area):
	slot_index = -1
	current_area = null

func _on_slot_4_area_exited(area):
	slot_index = -1
	current_area = null


func _on_slot_5_area_exited(area):
	slot_index = -1
	current_area = null

func _on_slot_6_area_exited(area):
	slot_index = -1
	current_area = null
