extends Node2D

# Loading re-sources before scene is running
@onready var enemy_database = preload("res://Enemy/enemy_database.gd")
@onready var enemy_ability_database = preload("res://Enemy/ability/ability_database.gd")

@onready var json_enemy = enemy_database.new()
@onready var json_enemy_ability = enemy_ability_database.new()
@onready var view_port_size:Vector2 = get_viewport_rect().size

@onready var scale_factor: Vector2 = Vector2(6,3)
@onready var size: Vector2 = Vector2(get_viewport_rect().size)/ scale_factor

# Rune Variable 
var current_enemy_rune: int # Player Current Rune
var rune_gain_per_turn: int # Player Rune Gained Per Turn 
var rune_capacity: int  # Player Rune Capacity 
var ability_cost:Array

# Other variable
var turn: int = 0 
var life_point: int 
var name_player: String 

# Card variable
var max_cards_in_hand: int 

var image: String
var ability_slot: int 
var affinity: String

var chose_enemy: String = "Brynhildr"
var new_enemy

func chosen_enemy(enemy):
#	var position: Vector2 = Vector2(view_port_size.x * 1.16, view_port_size.y * 0.71)
	if enemy == "Thor":
		var enemy_1 = preload("res://Enemy/enemy_1/enemy_1.tscn")
		new_enemy = enemy_1.instantiate()
		$EnemyPlace.add_child(new_enemy)
#		new_enemy.position = position
	elif enemy == "Brynhildr":
		var enemy_2 = preload("res://Enemy/enemy_2/enemy_2.tscn")
		new_enemy = enemy_2.instantiate()
		$EnemyPlace.add_child(new_enemy)
#		new_enemy.position = position
	elif enemy == "Freyja":
		var enemy_3 = preload("res://Enemy/enemy_3/enemy_3.tscn")
		new_enemy = enemy_3.instantiate()
		$EnemyPlace.add_child(new_enemy)
#		new_enemy.position = position	

# Called when the node enters the scene tree for the first time.
func _ready():
	self.size = size
	#Scale Hero Size
	self.scale *= 0.8
	chosen_enemy(chose_enemy)
	
	self.position.x = self.position.x*1.5*(22)
	self.position.y = self.size.y*0.1
	
	# Position of Enemy Place
	$EnemyPlace.position = Vector2($EnemyPlace.position.x, self.size.y*0.9)
	$Ability.size = Vector2($Rune.size.x, view_port_size.y * 0.15)
#	$LifePoint.position = Vector2(view_port_size.x * 1.07, view_port_size.y * 0.88)
#	$Rune.position = Vector2(view_port_size.x * 1.07, view_port_size.y * 0.94)
	$Ability.position = Vector2($Rune.position.x, $Rune.position.y + 50)

	json_enemy_ability = json_enemy_ability.DATA.get('Ability')
	
	# Get Hero's Info From Hero Database
	json_enemy = json_enemy.DATA.get("Enemy")
#	if chose_hero == "Thor":
#		json_hero = json_hero[0]
#	elif chose_hero == "Brynhildr":
#		json_hero = json_hero[1]
#	elif chose_hero == "Freyja":
#		json_hero = json_hero[2]
	
	json_enemy = json_enemy[0]
	var new_enemy = json_enemy.get(json_enemy.keys()[0])
	ability_slot = new_enemy.get('abilities_slot')
	
	max_cards_in_hand = new_enemy.get('max_card')
	
	# Hero's LP
	life_point = new_enemy.get('life_point')
	
	# Hero's Rune
	current_enemy_rune = new_enemy.get('rune')
	rune_gain_per_turn = new_enemy.get('rune_gain_per_turn')
	rune_capacity = new_enemy.get('rune_capacity')
	
	print(current_enemy_rune)
	# Hero's UI
	$LifePoint.max_value = life_point
	$LifePoint.value = life_point
	$LifePoint/Number.text = str($LifePoint.value)
	
	$Rune.max_value = rune_capacity
	$Rune.value = current_enemy_rune
	$Rune/Number.text = str($Rune.value)
	
	
	var index: int = 0
	for child in $Ability.get_children():
		child.text = json_enemy_ability[index].get('name')
		child.disabled = true
		ability_cost.push_back(json_enemy_ability[index].get('rune'))
		child.set_modulate(Color(0, 1, 1, 1))
		var disabled_style: Object = StyleBoxFlat.new()
		disabled_style.set_border_width_all(2)
		disabled_style.set_corner_radius_all(10)
		disabled_style.bg_color = Color(0, 0, 0, 1)
		child.add_theme_stylebox_override("disabled", disabled_style)
		child.add_theme_color_override("font_disabled_color", Color(0.980392, 0.921569, 0.843137, 1))
		index += 1
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ability_check_index()

"Hero Take Damage"
func enemy_take_damage(damage: int):
	if damage < life_point:
		life_point = life_point - damage
		$LifePoint.value = life_point
		$LifePoint/Number.text = life_point
	elif damage >= life_point:
		enemy_death()

"Check Hero Death & Change Game Over Screen"
func enemy_death():
	if life_point == 0:
		game_over_screen()

"Game Over Screen"
func game_over_screen():
	pass

func ability_check_index():
	for i in $Ability.get_child_count():
		if ability_cost[i] <= current_enemy_rune:
			var target = $Ability.get_child(i)
			var normal_style: Object = StyleBoxFlat.new()
			normal_style.set_border_width_all(2)
			normal_style.set_corner_radius_all(10)
			normal_style.bg_color = Color(0, 1, 0, 1)
			target.add_theme_stylebox_override("normal", normal_style)
			
			var hover_style: Object = StyleBoxFlat.new()
			hover_style.set_border_width_all(2)
			hover_style.set_corner_radius_all(10)
			hover_style.bg_color = Color(0, 1, 1, 1)
			target.add_theme_stylebox_override("hover", hover_style)
			

			target.add_theme_color_override("font_color", Color(0,0,0,1))
			target.add_theme_color_override("font_hover_color", Color(0,0,0,1))
		else:
			var target = $Ability.get_child(i)
			var normal_style: Object = StyleBoxFlat.new()
			normal_style.set_border_width_all(2)
			normal_style.set_corner_radius_all(10)
			normal_style.bg_color = Color(1,0,1,1)
			target.add_theme_stylebox_override("normal", normal_style)
			
			var hover_style: Object = StyleBoxFlat.new()
			hover_style.set_border_width_all(2)
			hover_style.set_corner_radius_all(10)
			hover_style.bg_color = Color(0,0,0,1)
			target.add_theme_stylebox_override("hover", hover_style)

			target.add_theme_color_override("font_color", Color(1, 0.980392, 0.941176, 1))
			target.add_theme_color_override("font_hover_color", Color(1, 0.980392, 0.941176, 1))

"Enemy Artifact"
func enemy_artifact():
	pass


"Ability Animation"
func _on_ability_1_pressed():
	if chose_enemy== "Thor":
		$HeroPlace/Hero1/CharacterBody2D.animation = "Attack"
		await get_tree().create_timer(1).timeout
		$HeroPlace/Hero1/CharacterBody2D.animation = "Idle" 
	elif chose_enemy == "Brynhildr":
		$HeroPlace/Hero2/CharacterBody2D.animation = "Attack"
		await get_tree().create_timer(1).timeout
		$HeroPlace/Hero2/CharacterBody2D.animation = "Idle" 
	elif chose_enemy == "Freyja":
		$HeroPlace/Hero1/CharacterBody2D.animation = "Attack"
		await get_tree().create_timer(1).timeout
		$HeroPlace/Hero1/CharacterBody2D.animation = "Idle" 




func _on_ability_2_pressed():
	if chose_enemy == "Thor":
		$HeroPlace/Hero1/CharacterBody2D.animation = "Attack"
		await get_tree().create_timer(1).timeout
		$HeroPlace/Hero1/CharacterBody2D.animation = "Idle" 
	elif chose_enemy == "Brynhildr":
		$HeroPlace/Hero2/CharacterBody2D.animation = "Attack"
		await get_tree().create_timer(1).timeout
		$HeroPlace/Hero2/CharacterBody2D.animation = "Idle" 
	elif chose_enemy == "Freyja":
		$HeroPlace/Hero1/CharacterBody2D.animation = "Attack"
		await get_tree().create_timer(1).timeout
		$HeroPlace/Hero1/CharacterBody2D.animation = "Idle" 
		



func _on_ability_3_pressed():
	if chose_enemy == "Thor":
		$HeroPlace/Hero1/CharacterBody2D.animation = "Attack"
		await get_tree().create_timer(1).timeout
		$HeroPlace/Hero1/CharacterBody2D.animation = "Idle" 
	elif chose_enemy == "Brynhildr":
		$HeroPlace/Hero2/CharacterBody2D.animation = "Attack"
		await get_tree().create_timer(1).timeout
		$HeroPlace/Hero2/CharacterBody2D.animation = "Idle" 
	elif chose_enemy == "Freyja":
		$HeroPlace/Hero1/CharacterBody2D.animation = "Attack"
		await get_tree().create_timer(1).timeout
		$HeroPlace/Hero1/CharacterBody2D.animation = "Idle" 




func _on_ability_4_pressed():
	if chose_enemy == "Thor":
		$HeroPlace/Hero1/CharacterBody2D.animation = "Attack"
		await get_tree().create_timer(1).timeout
		$HeroPlace/Hero1/CharacterBody2D.animation = "Idle" 
	elif chose_enemy == "Brynhildr":
		$HeroPlace/Hero2/CharacterBody2D.animation = "Attack"
		await get_tree().create_timer(1).timeout
		$HeroPlace/Hero2/CharacterBody2D.animation = "Idle" 
	elif chose_enemy == "Freyja":
		$HeroPlace/Hero1/CharacterBody2D.animation = "Attack"
		await get_tree().create_timer(1).timeout
		$HeroPlace/Hero1/CharacterBody2D.animation = "Idle" 
