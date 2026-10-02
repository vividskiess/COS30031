extends PanelContainer


@onready var title_label = $Vbox/Hbox/Title
@onready var messages = $Vbox/Message
@onready var close = $Vbox/Hbox/Close
@onready var timer = $Timer

func _ready() -> void:
	close.pressed.connect(queue_free)
	timer.timeout.connect(queue_free)
	
func setup(title: String, message: String, duration:float = 6.0) -> void:
	title_label.text = title
	messages.text = message
	reset_size()
	timer.wait_time = duration
	timer.start()
