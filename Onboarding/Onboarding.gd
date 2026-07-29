extends Control
@onready var slide_container: HBoxContainer = $HBoxContainer
@onready var next: RGButton = $HBoxContainer/CenterContainer/RGContainer/VBoxContainer/MarginContainer2/HBoxContainer/Next
@onready var back: RGButton = $HBoxContainer/CenterContainer/RGContainer/VBoxContainer/MarginContainer2/HBoxContainer/Back
@onready var tou_next: RGButton = $HBoxContainer/TOU/RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Next
@onready var slide_scroll: ScrollContainer = $HBoxContainer/CenterContainer/RGContainer/VBoxContainer/MarginContainer/SlideScroll
@onready var section_view: RGSectionView = $HBoxContainer/CenterContainer/RGContainer/VBoxContainer/MarginContainer2/HBoxContainer/VBoxContainer/RGSectionView
@onready var bar1: HBoxContainer = $HBoxContainer/CenterContainer/RGContainer/VBoxContainer/MarginContainer2/HBoxContainer
@onready var bar2: HBoxContainer = $HBoxContainer/CenterContainer/RGContainer/VBoxContainer/MarginContainer2/HBoxContainer2
@onready var launch: RGButton = $HBoxContainer/CenterContainer/RGContainer/VBoxContainer/MarginContainer2/HBoxContainer2/HBoxContainer/Launch

var slide:int = 0

signal next_slide_selected
signal prev_slide_selected
func _ready() -> void:
	slide_scroll.scroll_horizontal = 0.0
	get_tree().root.size_changed.connect(_resize_slides)
	next.set_color("Tasker")
	launch.set_color("Tasker")

func _resize_slides():
	for child in slide_container.get_children():
		child.custom_minimum_size = size
	if slide >= 1:
		slide_container.position.x = -size.x
	else:
		slide_container.position.x = 0

func next_slide():
	RoseGarden.clear_tooltips()
	var tween = create_tween()
	slide += 1
	if slide == 6:
		bar1.hide()
		bar2.show()
		bar1.get_parent().add_theme_constant_override("margin_left",16)
	if slide == 7:
		Main.change_view("mainview")
		Data.save_to("onboarding_complete",true,"Core/UpdateData")
		Data.save_file("Core/UpdateData")
		return
	if slide != 1:
		section_view.select_next()
		back.show()
	else:
		back.hide()
	if slide-1 == 0:
		tween.tween_property(slide_container,"position:x",-size.x,0.2*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	else:
		tween.tween_property(slide_scroll,"scroll_horizontal",(slide-1)*slide_scroll.size.x,0.2*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	next_slide_selected.emit()

func prev_slide():
	RoseGarden.clear_tooltips()
	var tween = create_tween()
	if slide == 6:
		bar1.show()
		bar2.hide()
		bar1.get_parent().add_theme_constant_override("margin_left",24)
	if slide == 1:
		return
	slide -= 1
	if slide != 1:
		back.show()
	else:
		back.hide()
	tween.tween_property(slide_scroll,"scroll_horizontal",(slide-1)*slide_scroll.size.x,0.2*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	enable_next()
	section_view.select_prev()
	prev_slide_selected.emit()

func _process(_delta: float) -> void:
	if !visible:
		return
	if Input.is_action_just_pressed("ui_confirm") or Input.is_action_just_pressed("ui_next"):
		if slide == 0:
			tou_next.press()
		else:
			next.press()
	if Input.is_action_just_pressed("ui_prev"):
		prev_slide()

func disable_next():
	next.disabled = true

func enable_next():
	next.disabled = false

func _on_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)
