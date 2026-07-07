extends Node

var _client: Control
const ID = "core.command_bar"


func add_command(
	command_name: String,
	id: String,
	icon_path: String,
	action: Callable,
	params: Array = [],
	keywords = []
):
	if _client == null:
		(
			Debug
			. warn(
				(
					"Process: "
					+ Main.get_process_name(id)
					+ " attempted to add a command while the client was not ready, command discarded. Command Name: "
					+ command_name
				),
				ID
			)
		)
		return ERR_BUSY
	return _client.add_command(command_name, id, icon_path, action, params, keywords)


func remove_command(path: String):
	var id = path.split("/")[0]
	if _client == null:
		(
			Debug
			. warn(
				(
					"Process: "
					+ Main.get_process_name(id)
					+ " attempted to remove a command while the client was not ready, action discarded. Command Path: "
					+ path
				),
				ID
			)
		)
		return ERR_BUSY
	return _client.remove_command(path)


func hide_command(path: String):
	var id = path.split("/")[0]
	if _client == null:
		(
			Debug
			. warn(
				(
					"Process: "
					+ Main.get_process_name(id)
					+ " attempted to hide a command while the client was not ready, action discarded. Command Path: "
					+ path
				),
				ID
			)
		)
		return ERR_BUSY
	return _client.hide_command(path)


func show_command(path: String):
	var id = path.split("/")[0]
	if _client == null:
		(
			Debug
			. warn(
				(
					"Process: "
					+ Main.get_process_name(id)
					+ " attempted to show a command while the client was not ready, action discarded. Command Path: "
					+ path
				),
				ID
			)
		)
		return ERR_BUSY
	return _client.show_command(path)


func load_commands():
	if _client == null:
		(
			Debug
			. error(
				"Couldn't load commands because the client is not ready commands will not be loaded for this session",
				ID
			)
		)
		return ERR_BUSY
	return _client.load_commands()


func link_action(action: Callable, path: String):
	if _client == null:
		(
			Debug
			. warn(
				(
					"Process: "
					+ Main.get_process_name(path.split("/")[0])
					+ " attempted to link an action to a command while the client was not ready, action discarded. Command Path: "
					+ path
				),
				ID
			)
		)
		return ERR_BUSY
	return _client.link_action(action, path)


func command_has_action(path: String):
	if _client == null:
		(
			Debug
			. warn(
				(
					"Process: "
					+ Main.get_process_name(path.split("/")[0])
					+ " attempted to check if a command has an action while the client was not ready, action discarded. Command Path: "
					+ path
				),
				ID
			)
		)
		return ERR_BUSY
	return _client.command_has_action(path)


func command_exists(path: String):
	if _client == null:
		(
			Debug
			. warn(
				(
					"Process: "
					+ Main.get_process_name(path.split("/")[0])
					+ " attempted to check if a command exists while the client was not ready, action discarded. Command Path: "
					+ path
				),
				ID
			)
		)
		return ERR_BUSY
	return _client.command_exists(path)
