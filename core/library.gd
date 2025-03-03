extends Library


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	logger = Log.get_logger("Legendary", Log.LEVEL.INFO)
	logger.info("Legendary Library loaded")

func get_library_launch_items() -> Array[LibraryLaunchItem]:
	var items := [] as Array[LibraryLaunchItem]
	var output_legendary = []
	OS.execute("legendary", ["list-installed"], output_legendary)
	var split_legendary = output_legendary[0].split('\n')
	var valid_output_legendary = false
	for line in split_legendary:
		if line == "Installed games:":
			valid_output_legendary = true
		elif valid_output_legendary == true and line.begins_with(" *"):
			var item_legendary_regex = RegEx.new()
			item_legendary_regex.compile(r" * ([^*]+) \(App name: (.+) \| Version: (.+) \| Platform: (.+) \| (.+)\)")
			var item_result = item_legendary_regex.search(line)
			if item_result:
				var item_name = item_result.get_string(1)  # Group 1: Item name
				var app_name = item_result.get_string(2)   # Group 2: App name
				var version = item_result.get_string(3)    # Group 3: Version
				var platform = item_result.get_string(4)   # Group 4: Platform
				var installed_size = item_result.get_string(5) # Group 5: Description

				var item: LibraryLaunchItem = LibraryLaunchItem.new()
				item.name = item_name
				item.command = "legendary"
				item.args = ["launch", "--offline", "--wine", "umu-run", "%s" % [app_name]]
				item.tags = ["legendary", platform]
				item.installed = true
				items.append(item)
			else:
				print("No match found.")
	return items
