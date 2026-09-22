extends Control

@onready var desktopIcon = $DesktopIcon
@onready var desktop_manager = $Desktop_manger

func _ready():
	#var test_file_data = load("res://Asset/Testing/new_resource.tres")
	#desktopIcon.setup(test_file_data)
	desktopIcon.icon_double_clicked.connect(desktop_manager._on_icon_open)
func _being_moved():
	pass
