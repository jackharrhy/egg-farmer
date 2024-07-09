extends Control

@onready var open_hand = $HandsContainer/Hands/Open
@onready var closed_hand = $HandsContainer/Hands/Closed

func _ready():
	hide_hands()

func show_open_hand():
	open_hand.visible = true
	closed_hand.visible = false

func show_closed_hand():
	open_hand.visible = false
	closed_hand.visible = true

func hide_hands():
	open_hand.visible = false
	closed_hand.visible = false
