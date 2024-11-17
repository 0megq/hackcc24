extends ProgressBar


var current_timer: Timer


func _process(_delta: float) -> void:
	if current_timer != null and current_timer.is_node_ready():
		value = current_timer.time_left
	
