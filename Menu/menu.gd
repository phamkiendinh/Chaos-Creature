extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Container.position.x = get_viewport_rect().size.x * 0.35
	$Container.position.y = get_viewport_rect().size.y * 0.2
	$Container.size.x = get_viewport_rect().size.x * 0.3
	$Container.size.y = get_viewport_rect().size.y * 0.6

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		pass


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Loading/loading.tscn")


func _on_continue_pressed():
	#get_tree().change_scene_to_file("res://Loading/loading.tscn")
	pass

func _on_deck_pressed():
	get_tree().change_scene_to_file("res://Deck/deck_management.tscn")

func _on_artifact_pressed():
	get_tree().change_scene_to_file("res://Player/HeroManagement/hero_management.tscn")

func _on_quit_pressed():
	get_tree().quit()


