extends Plugin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	logger = Log.get_logger("Legendary", Log.LEVEL.DEBUG)
	
	var library: Library = load(plugin_base + "/core/library_legendary.tscn").instantiate()
	add_child(library)
