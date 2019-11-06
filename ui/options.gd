extends Node

const SAVE_PATH = "res://config.cfg"

onready var _config_file = File.new()
var _settings = {
	key_highlight = key_highlight
	}

onready var key_highlight = 0

func _ready():
	load_settings()


func save_settings():
	_settings.key_highlight = key_highlight
	_config_file.open(SAVE_PATH, File.WRITE)
	_config_file.store_line(to_json(_settings))
	_config_file.close()

func load_settings():
	if _config_file.file_exists(SAVE_PATH):
		_config_file.open(SAVE_PATH, File.READ)
		_settings = parse_json(_config_file.get_line())
		key_highlight = _settings.key_highlight
#	var error = _config_file.load(SAVE_PATH)
#	if error != OK:
#		print("Error loading the setings. Error code: %s" % error)
#		return []
#	values = []
#	for section in _settings.keys():
#		for key in _settings[section].keys():
#			var val = _settings[section][key]
#			values.append(_config_file.get_value(section, key, val))
#			print(values)





