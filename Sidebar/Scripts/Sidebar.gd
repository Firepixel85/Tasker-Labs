extends Control


@onready var animator: AnimationPlayer = $"../AnimationPlayer"
@onready var selection: TextureRect = $TextureRect/Control/Upper/Selection/TextureRect
@onready var overview: TextureRect = $TextureRect/Control/Upper/VBoxContainer/Overview/TextureRect
@onready var daily: TextureRect = $TextureRect/Control/Upper/VBoxContainer/Daily/TextureRect

var page:String = "daily"
var selectionpositions:Dictionary = {1:10,2:62,3:115,4:168}
signal changed_page(page:String)
func _ready() -> void:
	selection.positionselection(selectionpositions[2])
	daily.modulate = Color(1, 1, 1)
	overview.modulate = Color(0.576, 0.576, 0.576)
func _on_overview_pressed() -> void:
	if page != "overview":
		overview.modulate = Color(1, 1, 1)
		daily.modulate = Color(0.576, 0.576, 0.576)
		selection.positionselection(selectionpositions[1])
		animator.play("Overview")
		page = "overview"
		changed_page.emit(page)

func _on_daily_pressed() -> void:
	if page != "daily":
		daily.modulate = Color(1, 1, 1)
		overview.modulate = Color(0.576, 0.576, 0.576)
		selection.positionselection(selectionpositions[2])
		animator.play("Daily")
		page = "daily"
		changed_page.emit(page)
