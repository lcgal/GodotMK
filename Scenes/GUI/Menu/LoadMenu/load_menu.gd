extends Control

func _ready():
	var itens = Configs.get_saved_files()
	for item in itens:
		var load_item = SceneInitializer.initialize_load_item(item)
		$LoadItens.add_child(load_item)
