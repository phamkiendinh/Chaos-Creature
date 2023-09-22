extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_values_and_animate(value:String, start_pos:Vector2) :
	$TitleCardContainer/Label.text = value
	$AnimationPlayer.play("Phase Start")
	
	return $AnimationPlayer.get_animation("Phase Start").length
	var tween = get_parent().get_tree().create_tween()
	var end_pos = Vector2(randf_range(-100,100),-100) + start_pos
	var tween_length = $AnimationPlayer.get_animation("Phase Start").length

	tween.tween_property($LabelContainer,"position",end_pos,tween_length).from(start_pos)
