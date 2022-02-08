extends MarginContainer

var level_token
var experience_label

func _ready():
	StateController.player_panel = self
	level_token = $VBoxContainer/LevelToken
	experience_label = $VBoxContainer/ExperienceLabel

func set_experience_text(var text):
	experience_label.bbcode_text = text
