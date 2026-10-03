extends Control

signal signed_in


func _on_sign_in_pressed() -> void:
	signed_in.emit()


func _on_power_pressed() -> void:
	get_tree().quit()
