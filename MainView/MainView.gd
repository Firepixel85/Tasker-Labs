extends Control

func _ready():
	if Main.developerMode:
		PluginManager.load_plugin("com.rosepen.console")
