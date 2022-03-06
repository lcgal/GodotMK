extends Control

var level_token
var experience_label

func _ready():
	StateController.player_panel = self
	level_token = $LevelToken
	experience_label = $ExperienceLabel

func set_experience_text(var text):
	experience_label.bbcode_text = text
