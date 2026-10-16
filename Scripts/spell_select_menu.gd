
extends Control

# Sorts disponibles
@onready var p1_spell_buttons: Array = [$"Cadre J1/J1 VBoxContainer/Spell1", $"Cadre J1/J1 VBoxContainer/Spell2", $"Cadre J1/J1 VBoxContainer/Spell3", $"Cadre J1/J1 VBoxContainer/Spell4", $"Cadre J1/J1 VBoxContainer/Spell5"]
@onready var p2_spell_buttons: Array = [$"Cadre J2/J2 VBoxContainer/Spell1", $"Cadre J2/J2 VBoxContainer/Spell2", $"Cadre J2/J2 VBoxContainer/Spell3", $"Cadre J2/J2 VBoxContainer/Spell4", $"Cadre J2/J2 VBoxContainer/Spell5"]

# Slots (3 par joueur)
@onready var p1_slot_buttons: Array = [$"Cadre J1/J1 VBoxContainerSlots/Slot1", $"Cadre J1/J1 VBoxContainerSlots/Slot2", $"Cadre J1/J1 VBoxContainerSlots/Slot3"]
@onready var p2_slot_buttons: Array = [$"Cadre J2/J2 VBoxContainerSlots/Slot1", $"Cadre J2/J2 VBoxContainerSlots/Slot2", $"Cadre J2/J2 VBoxContainerSlots/Slot3"]

# Conteneurs
@onready var p1_spelllist_container: Control = $"Cadre J1/J1 VBoxContainer"
@onready var p2_spelllist_container: Control = $"Cadre J2/J2 VBoxContainer"
@onready var p1_slotlist_container: Control = $"Cadre J1/J1 VBoxContainerSlots"
@onready var p2_slotlist_container: Control = $"Cadre J2/J2 VBoxContainerSlots"

@onready var start_button: Button = $StartButton
@onready var main_menu_button: Button = $MainMenuButton
@onready var start_training_button: Button = $StartTraining

@onready var p1_spell_info_panel: PanelContainer = $"SpellInfo J1"
@onready var p1_spell_info_label: RichTextLabel = $"SpellInfo J1/J1 SpellInfoBox/J1 SpellDesc"
@onready var p1_spell_icon: TextureRect = $"SpellInfo J1/J1 SpellInfoBox/J1 SpellIcon"

@onready var p2_spell_info_panel: PanelContainer = $SpellInfoPanel2
@onready var p2_spell_info_label: RichTextLabel = $"SpellInfoPanel2/J2 SpellInfoBox/J2 SpellDesc"
@onready var p2_spell_icon: TextureRect = $"SpellInfoPanel2/J2 SpellInfoBox/J2 SpellIcon"

@onready var p1_spell_info_texture: TextureRect = $"Texture SpellInfo J1"
@onready var p2_spell_info_texture: TextureRect = $"Texture SpellInfo J2"

@export var p1_spell_data: Array[SpellData] = []
@export var p2_spell_data: Array[SpellData] = []

const REQUIRED_SPELLS := 3
const NUM_SPELLS := 5

enum Mode { SLOTS, PICKING, START, TRAINING, MENU }

var p1_mode: int = Mode.SLOTS
var p2_mode: int = Mode.SLOTS

var p1_slot_index := 0
var p2_slot_index := 0

var p1_pick_index := 0
var p2_pick_index := 0

var p1_editing_slot := -1
var p2_editing_slot := -1

var p1_slots := [-1, -1, -1]
var p2_slots := [-1, -1, -1]


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Jukebox.play_music()
	Jukebox.set_bass_boost(0.0)

	start_button.disabled = true
	start_training_button.disabled = true

	var style := StyleBoxFlat.new()
	style.bg_color = Color("0e2037ff")
	start_button.add_theme_stylebox_override("normal", style)

	p1_spell_info_panel.visible = false
	p2_spell_info_panel.visible = false
	p1_spell_info_texture.visible = false
	p2_spell_info_texture.visible = false

	for i in p1_spell_buttons.size():
		p1_spell_buttons[i].text = p1_spell_data[i].display_name
	for i in p2_spell_buttons.size():
		p2_spell_buttons[i].text = p2_spell_data[i].display_name

	for b in p1_spell_buttons + p2_spell_buttons + p1_slot_buttons + p2_slot_buttons + [start_button, start_training_button, main_menu_button]:
		b.focus_mode = Control.FOCUS_NONE

	p1_spelllist_container.visible = false
	p2_spelllist_container.visible = false

	_refresh_slot_labels(1)
	_refresh_slot_labels(2)
	_refresh_highlights()


func _unhandled_input(event: InputEvent) -> void:
	_handle_player_input(1, event)
	_handle_player_input(2, event)


func _handle_player_input(player: int, event: InputEvent) -> void:
	var up_action := "p%d_jump" % player
	var down_action := "p%d_down" % player
	var kick_action := "p1_heavy" if player == 1 else "p2_light"
	var left_action := "p1_left" if player == 1 else "p2_left"
	var right_action := "p1_right" if player == 1 else "p2_right"

	if event.is_action_pressed(up_action):
		_move(player, -1)
	elif event.is_action_pressed(down_action):
		_move(player, 1)
	elif player == 1 and event.is_action_pressed(left_action):
		_move_horizontal(-1)
	elif player == 1 and event.is_action_pressed(right_action):
		_move_horizontal(1)
	elif event.is_action_pressed(kick_action):
		_confirm(player)


func _move_horizontal(dir: int) -> void:
	if p1_mode == Mode.START and dir == 1 and not start_training_button.disabled:
		p1_mode = Mode.TRAINING
	elif p1_mode == Mode.TRAINING and dir == -1:
		p1_mode = Mode.START

	_refresh_highlights()


func _move(player: int, dir: int) -> void:
	var mode: int = p1_mode if player == 1 else p2_mode

	match mode:
		Mode.SLOTS:
			if player == 1:
				if dir == 1 and p1_slot_index == REQUIRED_SPELLS - 1 and not start_button.disabled:
					p1_mode = Mode.START
				elif dir == -1 and p1_slot_index == 0:
					p1_mode = Mode.MENU
				else:
					p1_slot_index = wrapi(p1_slot_index + dir, 0, REQUIRED_SPELLS)
			else:
				p2_slot_index = wrapi(p2_slot_index + dir, 0, REQUIRED_SPELLS)

		Mode.PICKING:
			var available := _get_available_indices(player)
			if available.is_empty():
				return
			if player == 1:
				p1_pick_index = wrapi(p1_pick_index + dir, 0, available.size())
			else:
				p2_pick_index = wrapi(p2_pick_index + dir, 0, available.size())

		Mode.START:
			if player == 1 and dir == -1:
				p1_mode = Mode.SLOTS
				p1_slot_index = REQUIRED_SPELLS - 1

		Mode.TRAINING:
			if player == 1 and dir == -1:
				p1_mode = Mode.SLOTS
				p1_slot_index = REQUIRED_SPELLS - 1

		Mode.MENU:
			if player == 1 and dir == 1:
				p1_mode = Mode.SLOTS
				p1_slot_index = 0

	_refresh_highlights()


func _confirm(player: int) -> void:
	var mode: int = p1_mode if player == 1 else p2_mode

	match mode:
		Mode.SLOTS:
			_enter_picking(player)
		Mode.PICKING:
			_assign_spell(player)
		Mode.START:
			if player == 1 and not start_button.disabled:
				_on_start_button_pressed()
		Mode.TRAINING:
			if player == 1 and not start_training_button.disabled:
				_on_start_training_pressed()
		Mode.MENU:
			if player == 1:
				_on_main_menu_button_pressed()

	_refresh_highlights()


func _enter_picking(player: int) -> void:
	if player == 1:
		p1_editing_slot = p1_slot_index
	else:
		p2_editing_slot = p2_slot_index

	var available := _get_available_indices(player)
	if available.is_empty():
		return

	if player == 1:
		p1_mode = Mode.PICKING
		p1_pick_index = 0
		p1_spelllist_container.visible = true
		p1_slotlist_container.visible = false
	else:
		p2_mode = Mode.PICKING
		p2_pick_index = 0
		p2_spelllist_container.visible = true
		p2_slotlist_container.visible = false

	_refresh_spell_list_visibility(player)
	_refresh_highlights()


func _assign_spell(player: int) -> void:
	var available := _get_available_indices(player)
	if available.is_empty():
		return

	var pick_index: int = p1_pick_index if player == 1 else p2_pick_index
	var spell_index: int = available[pick_index]
	var slot: int = p1_editing_slot if player == 1 else p2_editing_slot

	if player == 1:
		p1_slots[slot] = spell_index
		p1_mode = Mode.SLOTS
		p1_spelllist_container.visible = false
		p1_slotlist_container.visible = true
	else:
		p2_slots[slot] = spell_index
		p2_mode = Mode.SLOTS
		p2_spelllist_container.visible = false
		p2_slotlist_container.visible = true

	_refresh_slot_labels(player)
	_check_ready_to_start()
	_refresh_highlights()


func _get_available_indices(player: int) -> Array:
	var slots: Array = p1_slots if player == 1 else p2_slots
	var editing_slot: int = p1_editing_slot if player == 1 else p2_editing_slot
	var result: Array = []

	for i in range(NUM_SPELLS):
		var owner_slot: int = slots.find(i)
		if owner_slot == -1 or owner_slot == editing_slot:
			result.append(i)

	return result


func _refresh_spell_list_visibility(player: int) -> void:
	var buttons: Array = p1_spell_buttons if player == 1 else p2_spell_buttons
	var available := _get_available_indices(player)

	for i in buttons.size():
		buttons[i].visible = i in available


func _refresh_slot_labels(player: int) -> void:
	var slots: Array = p1_slots if player == 1 else p2_slots
	var slot_buttons: Array = p1_slot_buttons if player == 1 else p2_slot_buttons
	var spell_data: Array = p1_spell_data if player == 1 else p2_spell_data

	for i in slot_buttons.size():
		if slots[i] == -1:
			slot_buttons[i].text = "Slot %d - Vide" % (i + 1)
		else:
			slot_buttons[i].text = spell_data[slots[i]].display_name


func _refresh_highlights() -> void:
	for b in p1_spell_buttons + p2_spell_buttons + p1_slot_buttons + p2_slot_buttons:
		b.remove_theme_color_override("font_color")
		b.remove_theme_stylebox_override("normal")

	for b in [start_button, start_training_button, main_menu_button]:
		b.remove_theme_color_override("font_color")
		b.remove_theme_stylebox_override("normal")

	p1_spell_info_panel.visible = false
	p2_spell_info_panel.visible = false
	p1_spell_info_texture.visible = false
	p2_spell_info_texture.visible = false

	_highlight_player(1)
	_highlight_player(2)


func _highlight_player(player: int) -> void:
	var mode: int = p1_mode if player == 1 else p2_mode

	match mode:
		Mode.SLOTS:
			var slot_buttons: Array = p1_slot_buttons if player == 1 else p2_slot_buttons
			var slot_index: int = p1_slot_index if player == 1 else p2_slot_index
			_set_highlight(slot_buttons[slot_index], true)

		Mode.PICKING:
			var buttons: Array = p1_spell_buttons if player == 1 else p2_spell_buttons
			var available := _get_available_indices(player)
			var pick_index: int = p1_pick_index if player == 1 else p2_pick_index
			if pick_index < available.size():
				var real_index: int = available[pick_index]
				_set_highlight(buttons[real_index], true)
				_show_spell_info(player, real_index)

		Mode.START:
			_set_highlight(start_button, true)

		Mode.TRAINING:
			_set_highlight(start_training_button, true)

		Mode.MENU:
			_set_highlight(main_menu_button, true)


func _set_highlight(button: Button, on: bool) -> void:
	if on:
		button.add_theme_color_override("font_color", Color("#f2f200"))
		var style = button.get_theme_stylebox("normal").duplicate()
		style.border_color = Color("#f2f200")
		button.add_theme_stylebox_override("normal", style)
	else:
		button.remove_theme_stylebox_override("normal")
		button.remove_theme_color_override("font_color")


func _check_ready_to_start() -> void:
	var p1_done: bool = not (-1 in p1_slots)
	var p2_done: bool = not (-1 in p2_slots)
	var can_start: bool = p1_done and p2_done

	start_button.disabled = not can_start
	start_training_button.disabled = not can_start


func _show_spell_info(player: int, spell_index: int) -> void:
	var panel: PanelContainer = p1_spell_info_panel if player == 1 else p2_spell_info_panel
	var texture: TextureRect = p1_spell_info_texture if player == 1 else p2_spell_info_texture
	var label: RichTextLabel = p1_spell_info_label if player == 1 else p2_spell_info_label
	var icon: TextureRect = p1_spell_icon if player == 1 else p2_spell_icon
	var spell_data: Array = p1_spell_data if player == 1 else p2_spell_data
	var spell: SpellData = spell_data[spell_index]

	panel.visible = true
	texture.visible = true
	icon.texture = spell.icon
	label.text = "[b]%s[/b]\n%s\n[b]Coût[/b] : %d\n[b]Dégâts[/b] : %.0f" % [
		spell.display_name.to_upper(),
		spell.description,
		spell.required_combo,
		spell.damage
	]


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_start_button_pressed() -> void:
	var p1_chosen: Array[SpellData] = []
	var p2_chosen: Array[SpellData] = []

	for i in p1_slots:
		p1_chosen.append(p1_spell_data[i])
	for i in p2_slots:
		p2_chosen.append(p2_spell_data[i])

	DataManager.distribute_spells(p1_chosen, p2_chosen)
	get_tree().change_scene_to_file("res://Scenes/level.tscn")


func _on_music_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/music_menu.tscn")


func _on_start_training_pressed() -> void:
	var p1_chosen: Array[SpellData] = []
	var p2_chosen: Array[SpellData] = []

	for i in p1_slots:
		p1_chosen.append(p1_spell_data[i])
	for i in p2_slots:
		p2_chosen.append(p2_spell_data[i])

	DataManager.distribute_spells(p1_chosen, p2_chosen)
	get_tree().change_scene_to_file("res://Scenes/training_level.tscn")
