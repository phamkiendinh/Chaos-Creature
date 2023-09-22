extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
			update_slot_life_point(slot.get_child(2),slot, slot.get_parent().get_child(slot.id + 6))
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
						update_slot_life_point(monster, hero_slot, hero_slot.get_parent().get_child(hero_slot.id + 6))
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
			update_slot_life_point(slot.get_child(2), slot, slot.get_parent().get_child(slot.id + 6))
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
			update_slot_life_point(slot.get_child(2), slot, slot.get_parent().get_child(slot.id + 6))
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
			update_slot_life_point(slot.get_child(2),slot,  slot.get_parent().get_child(slot.id + 6))
			await get_tree().create_timer(card.organize_time).timeout
			if slot.get_child(2).life_point + slot.get_child(2).life_point * 0.2 < slot.get_child(2).max_life_point:
				slot.get_child(2).life_point += slot.get_child(2).life_point * 0.2
			else:
				slot.get_child(2).life_point = slot.get_child(2).max_life_point
			update_slot_life_point(slot.get_child(2), slot, slot.get_parent().get_child(slot.id + 6))
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
					if affinity == "dar":
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
			update_slot_life_point(slot.get_child(2), slot, slot.get_parent().get_child(slot.id + 6))
			slot.remove_child(card)
			pass
		9:
			slot.get_child(2).life_point /= 2
			slot.get_child(2).max_life_point /= 2
			update_slot_life_point(slot.get_child(2), slot, slot.get_parent().get_child(slot.id + 6))
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


func update_slot_life_point(card: Object, slot: Object, target):
	target.max_value = card.max_life_point
	target.value = card.life_point
	target.get_node('Number').text = str(card.life_point)

func initiate_slot_life_point(card: Object,slot: Object, target):
	target.max_value = card.max_life_point
	target.value = card.life_point
	target.get_node('Number').text = str(card.life_point)
	target.visible = true
