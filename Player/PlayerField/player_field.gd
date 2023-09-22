extends Node2D

@onready var monster_deck = Global.monster_deck
@onready var spell_deck = Global.spell_deck

@onready var _MONSTER_ = preload("res://Card/Monster/monster_base.tscn")
@onready var _SPELL_ = preload("res://Card/Spell/spell_base.tscn")

@onready var view_port_size: Vector2 = Vector2(get_viewport_rect().size)
@onready var centre_card_oval: Vector2 = view_port_size * Vector2(0.58, 1.25)
@onready var horizontal_radian: float = view_port_size.x * 0.41
@onready var vertical_radian: float = view_port_size.y * 0.1

var number_cards_in_hand: int = -1
var angle: float = 0
var card_spread: float = 0.2
var oval_angle_vector: Vector2 = Vector2()
var card_index: int = 0
const max_cards_on_hand: int = 8
var card_spreading: bool = false

#Load Hero Information here later
var max_hero_rune
var hero_rune
var rune_gain_per_turn
var life_point
var max_life_point
var time = 0

"""
	Test Variables
"""
var card_size = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var temp_card: Object = _MONSTER_.instantiate()
	card_size = temp_card.size

	max_hero_rune = $Hero.rune_capacity
	hero_rune = $Hero.current_hero_rune
	rune_gain_per_turn = $Hero.rune_gain_per_turn
	life_point = $Hero.life_point
	max_life_point = life_point
	$Deck.position = Vector2(view_port_size.x * 0.1, view_port_size.y * 0.8)
	$Deck.scale *= temp_card.size * 0.5 / $Deck.texture.get_size()
	
	#PopUp
	$Window.position = view_port_size / 8
	$Window.size.x = view_port_size.x / 1.3
	$Window.size.y = view_port_size.y / 1.3
	
	var resource = Image.load_from_file('res://Assets/Icons/close.png')
	resource.resize(100,100)
	var closeIcon = ImageTexture.create_from_image(resource)
	$Window.add_theme_icon_override('close', closeIcon)

	$Window/Panel.size = $Window.size
	
	$Window/Panel/Container.size = $Window.size * 0.8
	$Window/Panel/Container.position.x += $Window.size.x * 0.1
	$Window/Panel/Container.position.y += $Window.size.y * 0.1
	$Window/Panel/Container/Image.size = $Window/Panel/Container.size * 0.4
	$Window/Panel/Container/Container.size =  $Window/Panel/Container.size * 0.5
	
	$Window/Panel/Container/Image.size.x = $Window/Panel/Container.size.x * 0.4
	$Window/Panel/Container/Container.size.x =  $Window/Panel/Container.size.x * 0.5
	
	$Window/Panel/Container/Container/Name.size = $Window/Panel/Container/Container.size 
	$Window/Panel/Container/Container/Name/Element.size = $Window/Panel/Container/Container/Name.size * 0.3
	$Window/Panel/Container/Container/Name/Text.size = $Window/Panel/Container/Container/Name.size * 0.3
	
	
	$Window/Panel/Container/Container/Attack.size = $Window/Panel/Container/Container.size 
	$Window/Panel/Container/Container/Attack/Element.size = $Window/Panel/Container/Container/Attack.size * 0.3
	$Window/Panel/Container/Container/Attack/Text.size = $Window/Panel/Container/Container/Attack.size * 0.3
	
#	$Window/Panel/Container/Container/AttackType.size = $Window/Panel/Container/Container.size 
#	$Window/Panel/Container/Container/AttackType/Element.size = $Window/Panel/Container/Container/AttackType.size * 0.3
#	$Window/Panel/Container/Container/AttackType/Text.size = $Window/Panel/Container/Container/AttackType.size * 0.3
	
	
	$Window/Panel/Container/Container/Ability.size = $Window/Panel/Container/Container.size 
	$Window/Panel/Container/Container/Ability/Element.size = $Window/Panel/Container/Container/Ability.size * 0.3
	$Window/Panel/Container/Container/Ability/Text.size = $Window/Panel/Container/Container/Ability.size * 0.3
	
	$Window/Panel/Container/Container/Description.size = $Window/Panel/Container/Container.size 
	$Window/Panel/Container/Container/Description/Element.size = $Window/Panel/Container/Container/Description.size * 0.3
	$Window/Panel/Container/Container/Description/Text.size = $Window/Panel/Container/Container/Description.size * 0.3
	
	$Window.hide()
	#draw_card()
	#draw_card()
	#draw_card()
	#draw_card()
	#draw_card()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Hero Rune Update
	$Hero.current_hero_rune = hero_rune
	$Hero/Rune.value = hero_rune 
	$Hero/Rune/Number.text = str($Hero/Rune.value, "/", max_hero_rune)
	#Hero Life Point Update
	$Hero/LifePoint.value = life_point 
	$Hero/LifePoint/Number.text = str($Hero/LifePoint.value, "/", max_life_point)
	pass

func draw_card():
	var monster_random: int = randi_range(0, monster_deck.size() - 1)
	var monster_card = monster_deck[monster_random]
	
	var spell_random: int = randi_range(0, spell_deck.size() - 1)
	var spell_card = spell_deck[spell_random]
	
	var random: int = randi_range(0 ,1000)
	var template = null
	var new_card = null

	if 0 <= random and random <= 690:
		new_card = _MONSTER_.instantiate()
		template = monster_card
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
	else:
		new_card = _SPELL_.instantiate()
		template = spell_card
		new_card.id = template.get('id')
		new_card.image  = template.get('image')
		new_card.text  = template.get('text')
		new_card.rune  = template.get('rune')
		new_card.spell_name = template.get('name')
		new_card.type = template.get('type')
		new_card.turn = template.get('turn')

	get_rune_image(new_card)
	# Variable Declare
	
	new_card.position = $Deck.position - Vector2(new_card.size.x, new_card.size.y/2)

	new_card.start_position = new_card.position
	new_card.rotation = $Deck.rotation
	new_card.scale *= 0.5
	card_index = 0
	$Hand.add_child(new_card)
	new_card.hand = $Hand
	#new_card.top_level = true
	number_cards_in_hand += 1
	organize_hand()
	
func organize_hand():
	for card in $Hand.get_children(): # reorganise hand
		card.size = card_size
		angle = PI/2 + card_spread * (float(number_cards_in_hand)/2 - card_index)
		oval_angle_vector = Vector2(horizontal_radian * cos(angle), - vertical_radian * sin(angle))
		card.target_position = centre_card_oval + oval_angle_vector - card.size
		card.hand_position = card.target_position
		card.start_rotation = card.rotation
		card.target_rotation = (PI/2 - angle) / 4
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
	#$Deck/TextureButton.emit_signal("pressed")

func get_rune_image(new_card):
	match new_card.rune:
		1:
			var resource = str('res://Assets/CardBorders/rune_1.png')
			var image = Image.load_from_file(resource)
			var texture = ImageTexture.create_from_image(image)
			new_card.rune_image = texture
			pass
		2:
			var resource = str('res://Assets/CardBorders/rune_2.png')
			var image = Image.load_from_file(resource)
			var texture = ImageTexture.create_from_image(image)
			new_card.rune_image = texture
			pass
		3:
			var resource = str('res://Assets/CardBorders/rune_3.png')
			var image = Image.load_from_file(resource)
			var texture = ImageTexture.create_from_image(image)
			new_card.rune_image = texture
			pass
		4:
			var resource = str('res://Assets/CardBorders/rune_4.png')
			var image = Image.load_from_file(resource)
			var texture = ImageTexture.create_from_image(image)
			new_card.rune_image = texture
			pass
		5:
			var resource = str('res://Assets/CardBorders/rune_5.png')
			var image = Image.load_from_file(resource)
			var texture = ImageTexture.create_from_image(image)
			new_card.rune_image = texture
			pass
		6:
			var resource = str('res://Assets/CardBorders/rune_6.png')
			var image = Image.load_from_file(resource)
			var texture = ImageTexture.create_from_image(image)
			new_card.rune_image = texture
			pass
		7:
			var resource = str('res://Assets/CardBorders/rune_7.png')
			var image = Image.load_from_file(resource)
			var texture = ImageTexture.create_from_image(image)
			new_card.rune_image = texture
			pass
		8:
			var resource = str('res://Assets/CardBorders/rune_8.png')
			var image = Image.load_from_file(resource)
			var texture = ImageTexture.create_from_image(image)
			new_card.rune_image = texture
			pass
		9:
			var resource = str('res://Assets/CardBorders/rune_9.png')
			var image = Image.load_from_file(resource)
			var texture = ImageTexture.create_from_image(image)
			new_card.rune_image = texture
			pass
		10:
			var resource = str('res://Assets/CardBorders/rune_10.png')
			var image = Image.load_from_file(resource)
			var texture = ImageTexture.create_from_image(image)
			new_card.rune_image = texture
			pass

func _on_window_close_requested():
	$Window.hide()
	pass
