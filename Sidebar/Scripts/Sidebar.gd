extends Control


@onready var animator: AnimationPlayer = $"../AnimationPlayer"
@onready var selection: TextureRect = $TextureRect/Control/Upper/Selection/TextureRect
@onready var overview: TextureRect = $TextureRect/Control/Upper/VBoxContainer/Overview/TextureRect
@onready var daily: TextureRect = $TextureRect/Control/Upper/VBoxContainer/Daily/TextureRect
@onready var settings: Control = $"../Settings"

var page:String = "daily"
var selectionpositions:Dictionary = {1:10,2:62,3:115,4:168}
signal changed_page(page:String)
func _ready() -> void:
	selection.positionselection(selectionpositions[2])
	daily.modulate = Color(1, 1, 1)
	overview.modulate = Color(0.576, 0.576, 0.576)

func _process(delta: float) -> void:
	if rtv.settings["sidebar_selection"] == 1:
		daily.modulate = Color(1, 1, 1)
		overview.modulate = Color(1, 1, 1)
	else:
		if page == "overview":
			overview.modulate = Color(1, 1, 1)
			daily.modulate = Color(0.576, 0.576, 0.576)
		else:
			daily.modulate = Color(1, 1, 1)
			overview.modulate = Color(0.576, 0.576, 0.576)

		
func _on_overview_pressed() -> void:
	if page != "overview" and (rtv.settings["sidebar_selection"] == 0 or 2):
		overview.modulate = Color(1, 1, 1)
		daily.modulate = Color(0.576, 0.576, 0.576)
		selection.positionselection(selectionpositions[1])
		animator.play("Overview")
		page = "overview"
		changed_page.emit(page)
	elif page != "overview":
		selection.positionselection(selectionpositions[1])
		animator.play("Overview")
		page = "overview"
		changed_page.emit(page)

func _on_daily_pressed() -> void:
	if page != "daily" and (rtv.settings["sidebar_selection"] == 0 or 2):
		daily.modulate = Color(1, 1, 1)
		overview.modulate = Color(0.576, 0.576, 0.576)
		selection.positionselection(selectionpositions[2])
		animator.play("Daily")
		page = "daily"
		changed_page.emit(page)
	elif page != "daily":
		selection.positionselection(selectionpositions[2])
		animator.play("Daily")
		page = "daily"
		changed_page.emit(page)


func _on_settings_pressed() -> void:
	if rtv.iscreating == false and rtv.isediting == false and rtv.issetting == false:
		settings.enter()
