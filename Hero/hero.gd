extends Node2D

# Loading re-sources before scene is running
@onready var hero_database = preload("res://Hero/hero_database.gd")
@onready var hero_ability_database = preload("res://Hero/ability/ability_database.gd")

@onready var json_hero = hero_database.new()
@onready var json_hero_ability = hero_ability_database.new()

@onready var view_port_size:Vector2 = get_viewport_rect().size

@onready var scale_factor: Vector2 = Vector2(6,3)
@onready var size: Vector2 = Vector2(get_viewport_rect().size)/ scale_factor

# Rune Variable 
var current_hero_rune: int # Player Current Rune
var rune_available: int   # Player Available Rune
var rune_used_check = true # If Player Used Rune
var rune_gain_per_turn: int # Player Rune Gained Per Turn 
var rune_capacity: int  # Player Rune Capacity 
var rune_used: int
var ability_cost:Array

# Other variable
var turn: int = 0 
var life_point: int 
var life_point_capacity: int 
var name_player: String 

# Card variable
var max_cards_in_hand: int 

var image: String
var ability_slot: int 
var affinity: String

var check_ability_2_press:int = 0

var chose_hero: String = GlobalVariables.chosen_hero
var artifact:Array = ['Artifact 1', 'Artifact 2']

func chosen_hero(hero):
	var new_hero
	if hero == "Thor":
		var hero_1 = preload("res://Hero/hero_1/hero_1.tscn")
		new_hero = hero_1.instantiate()
		$HeroPlace.add_child(new_hero)
	elif hero == "Brynhildr":
		var hero_2 = preload("res://Hero/hero_2/hero_2.tscn")
		new_hero = hero_2.instantiate()
		$HeroPlace.add_child(new_hero)
	elif hero == "Freyja":
		var hero_3 = preload("res://Hero/hero_3/hero_3.tscn")
		new_hero = hero_3.instantiate()
		$HeroPlace.add_child(new_hero)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.size = size
	#Scale Hero Size
	self.scale *= 0.8
	
#	chose_hero = "Thor"
	
	chosen_hero(chose_hero)
	# Position
	self.position.x = self.position.x*1.5
	self.position.y = self.size.y*0.1
	
	# Position of Hero Place
	$HeroPlace.position = Vector2($HeroPlace.position.x, self.size.y*0.9)
	$Ability.size = Vector2($Rune.size.x, view_port_size.y * 0.15)
	$Ability.position = Vector2($Rune.position.x, $Rune.position.y + 50)

	json_hero_ability = json_hero_ability.DATA.get('Ability')
	
	# Get Hero's Info From Hero Database
	json_hero = json_hero.DATA.get("Hero")
	if chose_hero == "Thor":
		json_hero = json_hero[0]
	elif chose_hero == "Brynhildr":
		json_hero = json_hero[1]
	elif chose_hero == "Freyja":
		json_hero = json_hero[2]
	
#	json_hero = json_hero[0]
	var new_hero = json_hero.get(json_hero.keys()[0])
	
	ability_slot = new_hero.get('abilities_slot')
	
	max_cards_in_hand = new_hero.get('max_card')
	
	# Hero's LP
	life_point = new_hero.get('life_point')
	life_point_capacity = new_hero.get('life_point')
	print('life_point: new_hero.get(life_point):', life_point)
#	print(real_life_point)
	Global.hero_lp = life_point
	print('life_point: Global.hero_lp:', life_point)
#	Global.hero_lp = life_point
	
	# Hero's Rune
	current_hero_rune = new_hero.get('rune')
	rune_gain_per_turn = new_hero.get('rune_gain_per_turn')
	rune_capacity = new_hero.get('rune_capacity')
	rune_available = current_hero_rune
	
	# Hero's UI
	$LifePoint.max_value = life_point
	$LifePoint.value = life_point
	$LifePoint/Number.text = str($LifePoint.value)
	
	$Rune.max_value = rune_capacity
	$Rune.value = current_hero_rune
	$Rune/Number.text = str($Rune.value)
	
	
	var index: int = 0
	for child in $Ability.get_children():
		child.text = json_hero_ability[index].get('name')
		ability_cost.push_back(json_hero_ability[index].get('rune'))
		child.set_modulate(Color(0, 1, 1, 1))
		index += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	ability_check_index()
	if(self.get_parent().life_point == 1):
		$Ability/Ability2.disabled = true
	else:
		$Ability/Ability2.disabled = false
	if(check_ability_2_press > 0 && self.get_parent().life_point == 1):
		$Ability/Ability2.disabled = true
	
func _process(delta):
	#Update Life Point
	life_point = Global.hero_lp
#	$LifePoint.max_value = life_point
#	$LifePoint.value = life_point
#	$LifePoint/Number.text = str($LifePoint.value)
	
"Hero Take Damage"
func hero_take_damage(damage: int):
	if damage < life_point:
		life_point = life_point - damage
		$LifePoint.value = life_point
		$LifePoint/Number.text = str(life_point)
	elif damage >= life_point:
		hero_death()

"Check Hero Death & Change Game Over Screen"
func hero_death():
	if life_point == 0:
		game_over_screen()

"Game Over Screen"
func game_over_screen():
	pass

func ability_check_index():
	for i in $Ability.get_child_count():
		if ability_cost[i] <= current_hero_rune:
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

"Hero Artifact"
func hero_artifact():
	pass


func apple_of_idunn_ability():
	var rune_cost = 2
#	current_hero_rune = current_hero_rune - rune_cost
	var out_going_heal = int(life_point_capacity * 0.2)
	if(self.get_parent().hero_rune < rune_cost):
		return false
	else:
		self.get_parent().hero_rune -= rune_cost
		self.get_parent().life_point += out_going_heal
		return true

"Ability Animation"
func _on_ability_1_pressed():
	if(apple_of_idunn_ability() == true):
		if chose_hero == "Thor":
			$HeroPlace/Hero1/CharacterBody2D.animation = "Attack"
			await get_tree().create_timer(1).timeout
			$HeroPlace/Hero1/CharacterBody2D.animation = "Idle" 
		elif chose_hero == "Brynhildr":
			$HeroPlace/Hero2/CharacterBody2D.animation = "Attack"
			await get_tree().create_timer(1).timeout
			$HeroPlace/Hero2/CharacterBody2D.animation = "Idle" 
		elif chose_hero == "Freyja":
			$HeroPlace/Hero1/CharacterBody2D.animation = "Attack"
			await get_tree().create_timer(1).timeout
			$HeroPlace/Hero1/CharacterBody2D.animation = "Idle" 
	else:
		pass


func sacrifice_of_god_ability():
	if(self.get_parent().life_point > 1):
		self.get_parent().life_point -= int(self.get_parent().life_point * 0.998)
		self.get_parent().hero_rune = rune_capacity
		return true
	else:
		return false


func _on_ability_2_pressed():
	if(check_ability_2_press == 0):
		check_ability_2_press += 1
		if(sacrifice_of_god_ability()== true):
			if chose_hero == "Thor":
				$HeroPlace/Hero1/CharacterBody2D.animation = "Attack"
				await get_tree().create_timer(1).timeout
				$HeroPlace/Hero1/CharacterBody2D.animation = "Idle" 
			elif chose_hero == "Brynhildr":
				$HeroPlace/Hero2/CharacterBody2D.animation = "Attack"
				await get_tree().create_timer(1).timeout
				$HeroPlace/Hero2/CharacterBody2D.animation = "Idle" 
			elif chose_hero == "Freyja":
				$HeroPlace/Hero1/CharacterBody2D.animation = "Attack"
				await get_tree().create_timer(1).timeout
				$HeroPlace/Hero1/CharacterBody2D.animation = "Idle" 
		else:
			pass
	else:
		pass



func _on_ability_3_pressed():
	self.get_parent().life_point -= 199
	if chose_hero == "Thor":
		$HeroPlace/Hero1/CharacterBody2D.animation = "Attack"
		await get_tree().create_timer(1).timeout
		$HeroPlace/Hero1/CharacterBody2D.animation = "Idle" 
	elif chose_hero == "Brynhildr":
		$HeroPlace/Hero2/CharacterBody2D.animation = "Attack"
		await get_tree().create_timer(1).timeout
		$HeroPlace/Hero2/CharacterBody2D.animation = "Idle" 
	elif chose_hero == "Freyja":
		$HeroPlace/Hero1/CharacterBody2D.animation = "Attack"
		await get_tree().create_timer(1).timeout
		$HeroPlace/Hero1/CharacterBody2D.animation = "Idle" 




func _on_ability_4_pressed():
	if chose_hero == "Thor":
		$HeroPlace/Hero1/CharacterBody2D.animation = "Attack"
		await get_tree().create_timer(1).timeout
		$HeroPlace/Hero1/CharacterBody2D.animation = "Idle" 
	elif chose_hero == "Brynhildr":
		$HeroPlace/Hero2/CharacterBody2D.animation = "Attack"
		await get_tree().create_timer(1).timeout
		$HeroPlace/Hero2/CharacterBody2D.animation = "Idle" 
	elif chose_hero == "Freyja":
		$HeroPlace/Hero1/CharacterBody2D.animation = "Attack"
		await get_tree().create_timer(1).timeout
		$HeroPlace/Hero1/CharacterBody2D.animation = "Idle" 
