extends NinePatchRect

##############
#### STOP #### Here begin private function that should never be called by your code
##############

var id:int
var manager:RGSectionView


func _ready() -> void:
	if manager == null:
		return
	manager.section_added.connect(_update)
	manager.section_selected.connect(_median_update)
	manager.section_removed.connect(_update)
	ready.emit()

func _update():
	if manager.get_selected() == id:
		create_tween().tween_property(self,"custom_minimum_size",Vector2(48,12),0.2*int(!RoseGarden.Accessibility.get_disable_animations())).set_trans(Tween.TRANS_SINE)
		modulate = Color(1,1,1)
	else:
		create_tween().tween_property(self,"custom_minimum_size",Vector2(12,12),0.2*int(!RoseGarden.Accessibility.get_disable_animations())).set_trans(Tween.TRANS_SINE)
		modulate = Color(0.67,0.67,0.67)

@warning_ignore("unused_parameter")
func _median_update(new_selection): #The section_selected signal has a property attachted thta is not used by _update, this just removes the need for that property
	_update()
