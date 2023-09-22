extends Node2D

const battle_scene = preload("res://BattleScene/battle_scene.tscn")
#const test_scene = preload("res://MainMenu/FirstScene.tscn")

#Hero Database
@onready var hero_database = preload("res://Hero/hero_database.gd")
@onready var json = hero_database.new()

@onready var view_port_size = get_viewport().size

@onready var left_margin = view_port_size.x * 0.2 #20% from 0
@onready var top_margin = view_port_size.y * 0.5 #30% from 0

#var chosen_hero_scene: String 

@onready var scale_factor: Vector2 = Vector2(6,3)
@onready var size: Vector2 = Vector2(get_viewport_rect().size)/ scale_factor

@onready var hero_base = preload("res://Hero/hero.tscn")
@onready var hero_1 = preload("res://Hero/hero_1/hero_1.tscn")
@onready var hero_2 = preload("res://Hero/hero_2/hero_2.tscn")
@onready var hero_3 = preload("res://Hero/hero_3/hero_3.tscn")

var id:int
var hero_name:String
var life_point:int
var rune_start:int
var rune_capacity:int

var new_hero
var json_hero
var path_string:String = '$' 

# Called when the node enters the scene tree for the first time.
func _ready():
	json = json.DATA.get('Hero')

	for n in json.size():
		json_hero = json[n]
		new_hero = json_hero.get(json_hero.keys()[0])
		#Get variable
		id = new_hero.get('id')
		hero_name = new_hero.get('name')
		life_point = new_hero.get('life_point')
		rune_start = new_hero.get('rune')
		rune_capacity = new_hero.get('rune_capacity')
		path_string="$Board_1/HeroSlot1/HeartNumber"
		if(id == 1):
			$Board_1/HeroSlot1/HeartNumber.text = str(life_point)
			$Board_1/HeroSlot1/RuneNumber.text = 'Start: ' + str(rune_start) + '\nMax: ' + str(rune_capacity)
		if(id == 2):
			$Board_2/HeroSlot2/HeartNumber.text = str(life_point)
			$Board_2/HeroSlot2/RuneNumber.text = 'Start: ' + str(rune_start) + '\nMax: ' + str(rune_capacity)
		if(id == 3):
			$Board_3/HeroSlot3/HeartNumber.text = str(life_point)
			$Board_3/HeroSlot3/RuneNumber.text = 'Start: ' + str(rune_start) + '\nMax: ' + str(rune_capacity)
	
	$Background.texture = load("res://Assets/Backgrounds/yggdrasil/yggdrasil.png")
	
	#Hero 1
	var new_hero_1 = hero_1.instantiate()
	$Board_1.position += Vector2(left_margin*0.2,top_margin*0.5)
	$Board_1/HeroSlot1.add_child(new_hero_1)
	$Board_1/HeroSlot1.position += Vector2($Board_1.position.x*3,$Board_1.position.y*0.2)
	
	$Board_1/HeroSlot1/Button1.position += Vector2($Board_1.position.x*0.3,$Board_1.position.y*2)
	$Board_1/HeroSlot1/Button1.scale = Vector2(0.35, 0.25)
	
	$Board_1/HeroSlot1/Button1/RichTextLabel.position = Vector2($Board_1/HeroSlot1/Button1.size.x/5, $Board_1/HeroSlot1/Button1.size.y/3)
	$Board_1/HeroSlot1/Button1/RichTextLabel.scale = Vector2(4, 3)
	
	$Board_1/HeroSlot1/Heart.scale *= self.size*0.1 / $Board_1/HeroSlot1/Heart.texture.get_size()
	$Board_1/HeroSlot1/Heart.position = Vector2($Board_1/HeroSlot1/Heart.position.x, self.size.y*0.7)
	
	$Board_1/HeroSlot1/HeartNumber.scale *= self.size*0.2 / ($Board_1/HeroSlot1/HeartNumber.get_size())
	$Board_1/HeroSlot1/HeartNumber.position = Vector2($Board_1/HeroSlot1.position.x*0.2, self.size.y*0.7)
	
	$Board_1/HeroSlot1/Rune.scale *= self.size*0.1 / $Board_1/HeroSlot1/Rune.texture.get_size()
	$Board_1/HeroSlot1/Rune.position = Vector2($Board_1/HeroSlot1/Rune.position.x, self.size.y*0.9)
	
	$Board_1/HeroSlot1/RuneNumber.scale *= self.size*0.3 / ($Board_1/HeroSlot1/RuneNumber.get_size())
	$Board_1/HeroSlot1/RuneNumber.position = Vector2($Board_1/HeroSlot1.position.x*0.2, self.size.y*0.9)
	
	#Hero 2
	var new_hero_2 = hero_2.instantiate()
	$Board_2.position += Vector2(left_margin*0.2*8,top_margin*0.5)
	$Board_2/HeroSlot2.add_child(new_hero_2)
	$Board_2/HeroSlot2.position += Vector2($Board_1.position.x*3,$Board_1.position.y*0.2)
	
	$Board_2/HeroSlot2/Button2.position += Vector2($Board_1.position.x*0.3,$Board_1.position.y*2)
	$Board_2/HeroSlot2/Button2.scale = Vector2(0.35, 0.25)
	
	$Board_2/HeroSlot2/Button2/RichTextLabel.position = Vector2($Board_1/HeroSlot1/Button1.size.x/5, $Board_1/HeroSlot1/Button1.size.y/3)
	$Board_2/HeroSlot2/Button2/RichTextLabel.scale = Vector2(4, 3)
	
	$Board_2/HeroSlot2/Heart.scale *= self.size*0.1 / $Board_2/HeroSlot2/Heart.texture.get_size()
	$Board_2/HeroSlot2/Heart.position = Vector2($Board_2/HeroSlot2/Heart.position.x, self.size.y*0.7)
	
	$Board_2/HeroSlot2/HeartNumber.scale *= self.size*0.2 / ($Board_2/HeroSlot2/HeartNumber.get_size())
	$Board_2/HeroSlot2/HeartNumber.position = Vector2($Board_2/HeroSlot2.position.x*0.2, self.size.y*0.68)

	$Board_2/HeroSlot2/Rune.scale *= self.size*0.1 / $Board_2/HeroSlot2/Rune.texture.get_size()
	$Board_2/HeroSlot2/Rune.position = Vector2($Board_2/HeroSlot2/Rune.position.x, self.size.y*0.9)

	$Board_2/HeroSlot2/RuneNumber.scale *= self.size*0.3 / $Board_2/HeroSlot2/RuneNumber.get_size()
	$Board_2/HeroSlot2/RuneNumber.position = Vector2($Board_2/HeroSlot2.position.x*0.2, self.size.y*0.88)
	
	#Hero 3 
	var new_hero_3 = hero_3.instantiate()
	$Board_3.position += Vector2(left_margin*0.2*15,top_margin*0.5)
	$Board_3/HeroSlot3.add_child(new_hero_3)
	$Board_3/HeroSlot3.position += Vector2($Board_1.position.x*3,$Board_1.position.y*0.2)
	
	$Board_3/HeroSlot3/Button3.position += Vector2($Board_1.position.x*0.3,$Board_1.position.y*2)
	$Board_3/HeroSlot3/Button3.scale = Vector2(0.35, 0.25)
	
	$Board_3/HeroSlot3/Button3/RichTextLabel.position = Vector2($Board_1/HeroSlot1/Button1.size.x/5, $Board_1/HeroSlot1/Button1.size.y/3)
	$Board_3/HeroSlot3/Button3/RichTextLabel.scale = Vector2(4, 3)
	
	self.size = size
	$Board_3/HeroSlot3/Heart.scale *= self.size*0.1 / $Board_3/HeroSlot3/Heart.texture.get_size()
	$Board_3/HeroSlot3/Heart.position = Vector2($Board_3/HeroSlot3/Heart.position.x, self.size.y*0.7)

	$Board_3/HeroSlot3/HeartNumber.scale *= self.size*0.2 / ($Board_3/HeroSlot3/HeartNumber.get_size())
	$Board_3/HeroSlot3/HeartNumber.position = Vector2($Board_3/HeroSlot3.position.x*0.2, self.size.y*0.68)

	$Board_3/HeroSlot3/Rune.scale *= self.size*0.1 / $Board_3/HeroSlot3/Rune.texture.get_size()
	$Board_3/HeroSlot3/Rune.position = Vector2($Board_3/HeroSlot3/Rune.position.x, self.size.y*0.9)

	$Board_3/HeroSlot3/RuneNumber.scale *= self.size*0.3 / $Board_3/HeroSlot3/RuneNumber.get_size()
	$Board_3/HeroSlot3/RuneNumber.position = Vector2($Board_3/HeroSlot3.position.x*0.2, self.size.y*0.88)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_1_pressed():
	GlobalVariables.chosen_hero = "Thor"
	get_tree().change_scene_to_file("res://BattleScene/battle_scene.tscn")

func _on_button_2_pressed():
	GlobalVariables.chosen_hero = "Brynhildr"
	get_tree().change_scene_to_file("res://BattleScene/battle_scene.tscn")

func _on_button_3_pressed():
	GlobalVariables.chosen_hero = "Freyja"
	get_tree().change_scene_to_file("res://BattleScene/battle_scene.tscn")
