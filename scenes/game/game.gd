extends Node2D

enum COLOR {
	GREEN, RED, YELLOW, BLUE
}

const INITIAL_SEQUENCE_SIZE = 2

@onready var animation = $AnimationPlayer
@onready var score = 0
@onready var game_sequence = []
@onready var player_sequence = []
@onready var buttons_enabled = false

func _ready():
	$GreenButton.button_down.connect(button_press.bind(COLOR.GREEN))
	$RedButton.button_down.connect(button_press.bind(COLOR.RED))
	$YellowButton.button_down.connect(button_press.bind(COLOR.YELLOW))
	$BlueButton.button_down.connect(button_press.bind(COLOR.BLUE))
	new_sequence()

func button_press(color):
	if buttons_enabled:
		player_sequence.push_back(color)
		if color == game_sequence[player_sequence.size()-1]: # If correct button
			# Play animation and sound
			animation.clear_queue()
			animation.play("RESET")
			match color:
				COLOR.GREEN:
					animation.queue("green")
				COLOR.RED:
					animation.queue("red")
				COLOR.YELLOW:
					animation.queue("yellow")
				COLOR.BLUE:
					animation.queue("blue")
			if player_sequence.size() == game_sequence.size(): # If sequence is complete
				score += 1
				update_sequence()
		else: # If wrong button
			Global.score = score
			get_tree().change_scene_to_file("res://scenes/game_over/game_over.tscn")

func new_sequence():
	for c in range(INITIAL_SEQUENCE_SIZE):
		game_sequence.push_back(randi() % 4)
	play_sequence()

func update_sequence():
	player_sequence = []
	game_sequence.push_back(randi() % 4)
	play_sequence()

func play_sequence():
	buttons_enabled = false
	# Wait for previous animation to end
	await get_tree().create_timer(1.0).timeout
	animation.clear_queue()
	animation.play("RESET")
	for c in game_sequence:
		match c:
			COLOR.GREEN:
				animation.queue("green")
			COLOR.RED:
				animation.queue("red")
			COLOR.YELLOW:
				animation.queue("yellow")
			COLOR.BLUE:
				animation.queue("blue")
	# Re-enable button only after animation is complete
	get_tree().create_timer(game_sequence.size()).timeout.connect(enable_buttons)

func enable_buttons():
	buttons_enabled = true
