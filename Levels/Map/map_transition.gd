extends CanvasLayer

func change_scene() -> void:
	$AnimationPlayer.play('dissolve')
	await get_node("AnimationPlayer").animation_finished
	$AnimationPlayer.play_backwards('dissolve')

