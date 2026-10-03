extends Button


func setup(level: LevelData) -> void:
	%Name.text = level.account_name
	%Role.text = level.role
	%AvatarFrame.self_modulate = level.avatar_tint
