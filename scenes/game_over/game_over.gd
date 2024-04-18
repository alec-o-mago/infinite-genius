extends Control


func _ready():
	$ScoreLabel.text = "Score:\n"+str(Global.score)
	$TryAgainButton.button_down.connect(try_again)

func try_again():
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
