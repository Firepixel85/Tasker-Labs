extends Control

@onready var task_management: VBoxContainer = $SmoothScrollContainer/VBoxContainer/TaskManagement
@onready var time_management: VBoxContainer = $"SmoothScrollContainer/VBoxContainer/Time Management"
@onready var qol: VBoxContainer = $SmoothScrollContainer/VBoxContainer/QOL
@onready var misc: VBoxContainer = $SmoothScrollContainer/VBoxContainer/Misc

@onready var categories := {
	"task_management" = task_management,
	"time_management" = time_management,
	"qol" = qol,
	"misc" = misc
}

func setup():
	for category in categories.keys():
		var list = StoreManager.get_plugins_for_category(category)
		if list.size() == 0:
			pass
			#categories[category].hide()
		else:
			for plugin in list:
				categories[category].add_plugin(plugin)
