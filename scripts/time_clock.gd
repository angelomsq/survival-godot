extends Label

func _ready() -> void:
	PlayerManager.time_start = Time.get_unix_time_from_system()
	PlayerManager.time_now = Time.get_unix_time_from_system()

func _process(delta: float) -> void:
	PlayerManager.time_now = Time.get_unix_time_from_system()
	text = PlayerManager.get_time_localized()
