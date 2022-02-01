extends MarginContainer

var levelToken
var experienceLabel

func _ready():
	StateController.player1Panel = self
	levelToken = $VBoxContainer/LevelToken
	experienceLabel = $VBoxContainer/ExperienceLabel

func _setExperienceText(var text):
	experienceLabel.bbcode_text = text
