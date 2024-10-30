extends Control


@onready var animator: AnimationPlayer = $"../AnimationPlayer"
@onready var selection: TextureRect = $TextureRect/Control/Upper/Selection/TextureRect
var page:String = "daily"
var selectionpositions:Dictionary = {1:10,2:62,3:115,4:168}
signal changed_page(page:String)
func _ready() -> void:
	selection.positionselection(selectionpositions[2])
func _on_overview_pressed() -> void:
	if page != "overview":
		selection.positionselection(selectionpositions[1])
		animator.play("Overview")
		page = "overview"
		changed_page.emit(page)

func _on_daily_pressed() -> void:
	if page != "daily":
		selection.positionselection(selectionpositions[2])
		animator.play("Daily")
		page = "daily"
		changed_page.emit(page)
