extends MarginContainer
# Loading re-sources before scene is running
@onready var spell_database = preload("res://Card/Spell/spell_database.gd")
@onready var json = spell_database.new()

var image:String
var text:String
var spell_name:String
var rune:int
var type:String
var id:int
var turn:int
var rune_image

#Declare card's font size
var scaling_ratio: int = 1; #allow 1 -> 3 only to maintain font-size
var font_size: int = 16;
var active_effect: Array = []
var hand:Object = null
#Get a random card in database for testing
#@onready var new_card = my_monster_database.DATA[randi() % my_monster_database.DATA.size()]

##Scale Ratio for PC or similar devices
@onready var scale_factor: Vector2 = Vector2(6,3) / scaling_ratio #Ideally size is width/height = 0.5


# Declare card size, Ideally 10/4 portion
@onready var spell_size: Vector2 = Vector2(get_viewport_rect().size) / scale_factor #Scaling by viewport's size automatically

#Zoom In Scaler
var normal_size: Vector2 = self.scale * 0.5
var zoom_in_size: Vector2 = self.scale * 0.75
var in_mouse_size: Vector2 = self.scale * 0.2
var time: float = 0
var draw_time: float = 0.8
var zoom_in_time: float = 0.5
var zoom_out_time: float = 0.5
var in_mouse_time: float = 0.01
var organize_time: float = 0.5
"""
	Draw Card Logic
"""

var start_position: Vector2 = Vector2()
var target_position: Vector2 = Vector2()
var hand_position: Vector2 = Vector2()
var start_rotation: float = 0
var target_rotation: float = 0
var in_hand_rotation: float = 0
var start_scale = 0
var target_scale = 0
"""
	Card Logic
"""
@onready var state: Dictionary = {
	"spell": true,
	"monster": false,
	"start": true,
	"set_up": true,
	"on_hand": false,
	"zoom_in": false,
	"in_mouse": false,
	"organize": false,
	"spreading": false,
	"in_slot": false,
	"in_battle": false,
	"discard" : false,
	"hero": true,
	"ally": true
}

var card_index: int = 0
var remove_turn: int = -1
# Called when the node enters the scene tree for the first time.
func _ready():
	#Read JSON file and create a new card randomly
	#json = json.DATA.get('Spell')
	#var new_card = json[randi() % json.size()] 
	# Variable Declare
	
	#id = new_card.get('id')
	#image  = new_card.get('image')
	#text  = new_card.get('text')
	#rune  = new_card.get('rune')
	#spell_name = new_card.get('name')
	#type = new_card.get('type')
	#turn = new_card.get('turn')

	# Update size for MonsterBase
	self.size = spell_size
	# Scale Border 
	$BorderImage.scale *= self.size * 1.5 / $BorderImage.texture.get_size()
	$Focus.scale = $BorderImage.texture.get_size() * 1.5 / $Focus.size
	$Rune.scale.x *= self.size.x * 0.205 / $Rune.texture.get_size().x
	$Rune.scale.y *= self.size.y * 0.175 / $Rune.texture.get_size().y
	$Rune.position = Vector2(self.size.x * 0.89, self.size.y * 0.09)
	$Background.scale *= self.size / $Background.size
	$Background.color = Color('WHITE')
	$CardBack.scale *= self.size * 1.05 / $CardBack.texture.get_size()
	$Spell.scale *= self.size / $Spell/SpellArea.shape.size
	# Layout has same size as card base since it's vertical box container
	
	$Rune.set_texture(rune_image)
	$Layout.size = self.size * 0.9
	
	#Ideally, keep same width for containers, but height will vary
	var portion_size_x: float = $Layout.size.x / 12
	var portion_size_y: float = $Layout.size.y / 12
	
	#Top Bar Scaling
	$Layout/TopGap.set_custom_minimum_size(Vector2(portion_size_x * 12, portion_size_y))
	
	# Apply Rich Text For Name	
	$Layout/NameContainer.set_custom_minimum_size(Vector2(portion_size_x * 12, portion_size_y))
	
	if spell_name.length() <= 3:
		$Layout/NameContainer/LeftGap.set_custom_minimum_size(Vector2(portion_size_x * 6, portion_size_y))
	elif spell_name.length() > 3 and spell_name.length() <= 5:
		$Layout/NameContainer/LeftGap.set_custom_minimum_size(Vector2(portion_size_x * 5.7, portion_size_y))
	elif spell_name.length() > 5 and spell_name.length() < 7:
		$Layout/NameContainer/LeftGap.set_custom_minimum_size(Vector2(portion_size_x * 5.5, portion_size_y))	
	else: 
		$Layout/NameContainer/LeftGap.set_custom_minimum_size(Vector2(portion_size_x * 4.8, portion_size_y))
		
	$Layout/NameContainer/Name.push_bold()
	$Layout/NameContainer/Name.push_color(Color('BLACK'))
	$Layout/NameContainer/Name.push_font_size(font_size)
	$Layout/NameContainer/Name.append_text(str(spell_name))
	$Layout/NameContainer/Name.pop()
	
	#Image Container
	var image_container_size: Vector2 = Vector2(portion_size_x * 11, portion_size_y * 6)
	$Layout/ImageContainer.set_custom_minimum_size(image_container_size)
	$Layout/ImageContainer/LeftGap.set_custom_minimum_size(Vector2(portion_size_x, portion_size_y * 6))
	$Layout/ImageContainer/Container/Image.texture = load(str('res://Assets/Spells/', image))
	$Layout/ImageContainer/Container/Image.scale *= image_container_size / $Layout/ImageContainer/Container/Image.texture.get_size()
	
	#Description Container Scale
	var description_size: Vector2 = Vector2(portion_size_x * 12, portion_size_y * 5)
	$Layout/Description.set_custom_minimum_size(description_size)
	$Layout/Description/LeftGap.set_custom_minimum_size(Vector2(portion_size_x * 2, portion_size_y * 5))
	$Layout/Description/RightGap.set_custom_minimum_size(Vector2(portion_size_x, portion_size_y * 5))
	$Layout/Description/Content.set_custom_minimum_size(Vector2(portion_size_x * 10, portion_size_y * 5))
	
	
	# Apply Rich Text For Description	
	$Layout/Description/Content/Label.push_bold()
	$Layout/Description/Content/Label.push_color(Color('BLACK'))
	$Layout/Description/Content/Label.push_font_size(font_size)
	$Layout/Description/Content/Label.append_text(text)
	$Layout/Description/Content/Label.pop()
	
	self.set_pivot_offset(self.size / 2)


func _physics_process(delta):
	#Organize Cards
	if self.state['organize'] and not self.state['in_slot'] and not self.state['zoom_in']:
		if self.state['set_up']:
			set_up()
		if time <= 1:
			self.position = self.start_position.lerp(self.target_position, time)
			self.rotation = self.start_rotation * (1 - time) + self.target_rotation * time
			time += delta/float(organize_time)
			if self.state['spreading']:
				self.state['spreading'] = false
				var current_card_number = hand.get_child_count() - 1
				if self.card_index - 1 >= 0:
					var current_index = self.card_index
					while current_index - 1 >= 0:
						var left_card = hand.get_child(current_index - 1)
						reset_zoom_card_spread(left_card, 'CARD_LEFT')
						current_index -= 1
				if self.card_index + 1 <= current_card_number:
					var current_index = self.card_index
					while current_index + 1 <= current_card_number:
						var right_card = hand.get_child(current_index + 1)
						reset_zoom_card_spread(right_card, 'CARD_RIGHT')
						current_index += 1
		else:
			self.position = self.target_position
			self.rotation = self.target_rotation
			self.state['organize'] = false
			self.state['on_hand'] = true
			time = 0
	
	# Hover Card
	if self.state['zoom_in'] and not self.state['in_slot'] and self.state['hero']:
		if self.target_position == self.hand_position:
			self.target_position.y = get_viewport_rect().size.y - (self.size.y * 1.2 * zoom_in_size.y)
		if state['set_up']:
			set_up()
		if time <= 1:
			self.position = self.start_position.lerp(self.target_position, time)
			self.rotation = self.start_rotation * (1 - time) + self.target_rotation * time
			self.scale = self.scale * (1 - time) + self.zoom_in_size * time
			time += delta/float(zoom_in_time)
			if self.state['spreading'] == false:
				self.state['spreading'] = true
			if time <= delta/float(zoom_in_time) * 3:
				var current_card_number = hand.get_child_count() - 1
				if self.card_index - 1 >= 0:
					var current_index = self.card_index
					while current_index - 1 >= 0:
						var left_card = hand.get_child(current_index - 1)
						zoom_card_spread(left_card, 'left')
						current_index -= 1
						
				if self.card_index + 1 <= current_card_number:
					var current_index = self.card_index
					while current_index + 1  <= current_card_number:
						var right_card = hand.get_child(current_index + 1)
						zoom_card_spread(right_card, 'right')
						current_index += 1

		else:
			self.scale = self.zoom_in_size
			self.position = self.target_position
	else:
		if time <= 1:
			self.scale = self.scale * (1 - time) + self.normal_size * time
			time += delta/float(zoom_out_time)
		else:
			self.scale = self.normal_size

	#Card is on hand
	if self.state['on_hand']:
		pass

	#Draw Card
	if self.state['start']:
		if self.state['set_up']:
			set_up()
		if self.state['hero']:
			if time <= 1:
				self.position = self.start_position.lerp(self.target_position, time)
				self.rotation = self.start_rotation * (1 - time) + self.target_rotation * time
				self.scale.x = normal_size.x * abs(2 * time - 1)
				if self.get_node('CardBack').visible:
					if time >= 0.9:
						$CardBack.visible = false
				time += delta/float(draw_time)
			else:
				self.position = self.target_position
				self.rotation = self.target_rotation
				self.scale = normal_size
				time = 0
				self.state['start'] = false
				self.state['on_hand'] = true
		elif not self.state['hero']:
			if time <= 1:
				self.position = self.start_position.lerp(self.target_position, time)
				self.rotation = self.start_rotation * (1 - time) + self.target_rotation * time
				self.scale.x = normal_size.x * abs(2 * time - 1)
				time += delta/float(draw_time)
			else:
				self.position = self.target_position
				self.rotation = self.target_rotation
				self.scale = normal_size
				time = 0
				self.state['start'] = false
				self.state['on_hand'] = true
				$CardBack.visible = true
				#$CardBack.scale = normal_size * 1.05
		else:
			pass
			
	#Picking Up Cards
	if self.state['in_mouse'] and not self.state['in_slot'] and self.state['hero']:
		#Picking up cards
		if self.state['set_up']:
			set_up()
		if time <= 1: # Always be 1 
			self.position = get_global_mouse_position() - self.size / 2
			self.scale = self.scale * (1 - time) + self.in_mouse_size * time
			self.rotation = self.start_rotation * (1 - time) + self.target_rotation * time
			time += delta/float(in_mouse_time)
		else:
			#Put the mouse to the card center when picking up the card
			self.position = get_global_mouse_position() - self.size / 2
			self.scale = self.in_mouse_size
			self.rotation = self.target_rotation
			


	#Move Card to Slot
	if self.state['in_slot']:
		if self.state['set_up']:
			set_up()
		if time <= 1:
			self.position = self.start_position.lerp(self.target_position, time)
			self.rotation = self.start_rotation * (1 - time) + self.target_rotation * time
			self.scale = self.start_scale * (1 - time) + self.target_scale * time
			time += delta/float(organize_time)
		else:
			self.rotation = self.target_rotation
			self.scale = self.target_scale
			self.position = self.target_position
			time = 0
			self.state['in_slot'] = false
			self.state['in_battle'] = true
	
	if self.state['in_battle']:
		self.rotation = self.target_rotation
		self.scale = self.target_scale
		self.position = self.target_position
		

func zoom_card_spread(card, direction):
	if card.state['in_slot'] || card.state['in_battle']:
		pass
	else:
		var spread_factor = 0.3
		if direction == 'left':
			card.target_position = card.hand_position - spread_factor * Vector2(self.size.x, 0)
		elif direction == 'right':
			card.target_position = card.hand_position + spread_factor * Vector2(self.size.x, 0)
		card.state['set_up'] = true
		card.state['organize'] = true

func reset_zoom_card_spread(card, pos):
	card.target_position = card.hand_position
	card.state['set_up'] = true
	card.state['organize'] = true

func set_up():
	self.start_position = self.position
	self.start_rotation = self.rotation
	time = 0
	self.state['set_up'] = false


"""
	mouse enter => zoom in activated => zoom in size and move vertically => spread two adjacent cards
"""
func _on_focus_mouse_entered():
	if not self.state["ally"]:
		return
		
	if (self.state['on_hand'] || self.state['organize']) and not self.state['in_slot'] and not self.state['in_battle']:
		state['set_up'] = true
		self.target_position.y = get_viewport_rect().size.y - (self.size.y * 1.2 * zoom_in_size.y)
		self.start_rotation = self.rotation
		self.target_rotation = 0
		state['zoom_in'] = true
		state['on_hand'] = true

	if self.state['hero'] and (self.state['in_battle'] || self.state['in_slot']) and not self.state['on_hand'] and not self.state['zoom_in'] and not self.state['in_mouse']:
		self.state['view_description'] = true
		
"""
	mouse exit => organize in activated => zoom out size and move vertically => organize two adjacent cards
"""
func _on_focus_mouse_exited():
	self.state['view_description'] = false

	if self.state['zoom_in'] and not self.state['in_mouse']:
		self.target_position = self.hand_position 
		self.start_rotation = self.rotation
		self.target_rotation = self.in_hand_rotation
		state['set_up'] = true
		state['zoom_in'] = false
		state['in_mouse'] = false
		state['organize'] = true
		

func _input(event):
	#Discard State
	if Input.is_action_just_pressed("left_click") and not self.state['in_battle'] and not self.state['in_slot'] and not self.state['start'] and self.state['zoom_in'] and self.get_parent().get_parent().get_parent().discard:
		self.state['discard'] = true
			
	if Input.is_action_just_pressed("left_click") and self.state['zoom_in'] and self.state['on_hand'] and not self.state['in_slot'] and not self.state['in_battle']:
		state['zoom_in'] = false
		state['in_mouse'] = true
		state['on_hand'] = false
		state['set_up'] = true

	if Input.is_action_just_released("left_click") and not self.state['organize'] and not self.state['zoom_in'] and not self.state['start'] and not self.state['on_hand']:
		state['in_mouse'] = false
		state['zoom_in'] = false
		state['set_up'] = false
		if not self.state['in_slot'] and not self.state['in_battle']:
			self.target_rotation = self.in_hand_rotation
			self.target_position = self.hand_position
			self.state['organize'] = true
			self.start_position = get_global_mouse_position() - self.size / 2
			self.time = 0
			
	if Input.is_action_just_released("right_click"):
		if not self.state['in_slot'] and not self.state['in_battle'] and self.state['in_mouse']:
			self.state['in_mouse'] = false
			self.state['zoom_in'] = false
			self.state['set_up'] = false
			self.target_rotation = self.in_hand_rotation
			self.target_position = self.hand_position
			self.start_position = get_global_mouse_position() - self.size / 2
			self.time = 0
			self.state['organize'] = true







func _on_focus_pressed():
	if self.state['in_battle'] == false and self.state['in_slot'] == false:
		return
		
	if not self.state['ally']:
		var field = self.get_parent().get_parent().get_parent().get_node("PlayerField")
		var window = field.get_node('Window')
		window.get_node('Panel/Container/Image').texture_normal = load(str('res://Assets/Units/', self.image))
		window.get_node('Panel/Container/Container/Name/Text').text = self.mon_name
		window.get_node('Panel/Container/Container/Attack/Text').text = str(self.attack_power)
		window.get_node('Panel/Container/Container/Rune/Text').text = str(self.rune)
		window.get_node('Panel/Container/Container/Description/Text').text = self.text
		window.show()
		field.current_card = self
	else:
		var field = self.get_parent().get_parent().get_parent()
		var window = field.get_node('Window')
		window.get_node('Panel/Container/Image').texture_normal = load(str('res://Assets/Units/', self.image))
		window.get_node('Panel/Container/Container/Name/Text').text = self.mon_name
		window.get_node('Panel/Container/Container/Attack/Text').text = str(self.attack_power)
		window.get_node('Panel/Container/Container/Rune/Text').text = str(self.rune)
		window.get_node('Panel/Container/Container/Description/Text').text = self.text
		window.show()
		field.current_card = self
