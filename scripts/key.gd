extends Area2D

@export var value: bool = true

signal key_obtained(amount: bool)

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	key_obtained.emit(true)
	queue_free()
