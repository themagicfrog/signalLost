extends Node2D

var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D

func _ready() -> void:
	visible_on_screen_notifier_2d = get_node_or_null("VisibleOnScreenNotifier2D")
	
	if visible_on_screen_notifier_2d:
		visible_on_screen_notifier_2d.screen_entered.connect(_on_screen_entered)
		visible_on_screen_notifier_2d.screen_exited.connect(_on_screen_exited)
		visible = false

func _on_screen_entered() -> void:
	show()
	set_process(true)
	set_physics_process(true)

func _on_screen_exited() -> void:
	hide()
	set_process(false)
	set_physics_process(false)
