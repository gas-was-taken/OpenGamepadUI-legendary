extends Library

@export var umudb_json = [] as Array

func _ready() -> void:
	super()
	logger = Log.get_logger("Legendary", Log.LEVEL.INFO)
	logger.info("Legendary Library loaded")

func init_umu_api() -> Array:
	var http_request = HTTPRequest.new()
	add_child(http_request)

	var request_completed = http_request.request_completed
	var error = http_request.request("https://umu.openwinecomponents.org/umu_api.php?store=egs")

	if error != OK:
		logger.error("Failed to make HTTP request to umu api")
		return []

	var result = await request_completed
	var response_code = result[1]
	var body = result[3]
	umudb_json = JSON.parse_string(body.get_string_from_utf8())
	http_request.queue_free()
	return umudb_json

func get_umu_id(codename: String) -> String:
	if umudb_json is Array:
		for game in umudb_json:
			if game.has("codename") and game["codename"] == codename:
				return game.get("umu_id", "umu-default")
	return "umu-default"

func get_library_launch_items() -> Array[LibraryLaunchItem]:
	await init_umu_api()

	var items := [] as Array[LibraryLaunchItem]
	var output_legendary_raw = []

	var success = OS.execute("legendary", ["list-installed", "--json"], output_legendary_raw)

	if success != OK:
		logger.error("Error executing legendary command")
		return items

	var parsed_legendary_list_installed = JSON.parse_string(output_legendary_raw[0])

	if typeof(parsed_legendary_list_installed) != TYPE_ARRAY:
		logger.error("Error parsing JSON response: not an Array")
		return items

	for entry in parsed_legendary_list_installed:
		if typeof(entry) != TYPE_DICTIONARY:
			logger.error("Unexpected data structure in entry")
			continue

		var item: LibraryLaunchItem = LibraryLaunchItem.new()

		if entry.has("title"):
			item.name = entry["title"]
		else:
			logger.error("Missing 'title' in entry")
			continue

		var lower_case_app_name = String(entry["app_name"]).to_lower()
		var item_wine_prefix = "/".join([OS.get_environment("HOME"), "Games/umu/umu-legendary-%s" % [lower_case_app_name]])
		item.command = "legendary"
		item.args = ["launch", "--wine-prefix", item_wine_prefix ,"--wine", "umu-run", "%s" % [entry["app_name"]]]
		item.tags = ["legendary", [entry["platform"]]]
		item.installed = true
		item.provider_app_id = entry["app_name"]
		var umu_game_id = get_umu_id(entry["app_name"])
		item.env = {"STORE": "egs", "GAMEID": umu_game_id}
		items.append(item)
		logger.info("Added item %s" % [item.name])
	
	return items
