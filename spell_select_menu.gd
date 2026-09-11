extends Control

@onready var p1_buttons: Array = [$VBoxContainer/Spell1, $VBoxContainer/Spell2, $VBoxContainer/Spell3, $VBoxContainer/Spell4, $VBoxContainer/Spell5]
@onready var p2_buttons: Array = [$VBoxContainer2/Spell1, $VBoxContainer2/Spell2, $VBoxContainer2/Spell3, $VBoxContainer2/Spell4, $VBoxContainer2/Spell5]
@onready var start_button: Button = $StartButton
@onready var spell_info_panel: PanelContainer = $SpellInfoPanel
@onready var spell_info_label: Label = $SpellInfoPanel/Label

var p1_index := 0
var p2_index := 0

var p1_selected := {} 
var p2_selected := {}

const REQUIRED_SPELLS := 3

func _ready() -> void:
	start_button.visible = false
	spell_info_panel.visible = false

	for b in p1_buttons + p2_buttons:
		b.focus_mode = Control.FOCUS_NONE  # on désactive le focus natif
		b.mouse_entered.connect(_show_info.bind(b))
		b.mouse_exited.connect(_hide_info)

	_refresh_highlights()

func _unhandled_input(event: InputEvent) -> void:
	# Joueur 1
	if event.is_action_pressed("p1_up"):
		p1_index = wrapi(p1_index - 1, 0, p1_buttons.size())
		_refresh_highlights()
	elif event.is_action_pressed("p1_down"):
		p1_index = wrapi(p1_index + 1, 0, p1_buttons.size())
		_refresh_highlights()
	elif event.is_action_pressed("p1_kick"):
		_toggle_selection(1, p1_index)

	# Joueur 2
	if event.is_action_pressed("p2_up"):
		p2_index = wrapi(p2_index - 1, 0, p2_buttons.size())
		_refresh_highlights()
	elif event.is_action_pressed("p2_down"):
		p2_index = wrapi(p2_index + 1, 0, p2_buttons.size())
		_refresh_highlights()
	elif event.is_action_pressed("p2_kick"):
		_toggle_selection(2, p2_index)

func _refresh_highlights() -> void:
	for i in p1_buttons.size():
		_set_highlight(p1_buttons[i], i == p1_index)
	for i in p2_buttons.size():
		_set_highlight(p2_buttons[i], i == p2_index)
	_show_info(p1_buttons[p1_index])  # ou gère 2 panneaux, un par joueur

func _set_highlight(button: Button, on: bool) -> void:
	if on:
		button.add_theme_color_override("font_color", Color.YELLOW)
	else:
		button.remove_theme_color_override("font_color")

func _toggle_selection(player: int, index: int) -> void:
	var dict = p1_selected if player == 1 else p2_selected
	var buttons = p1_buttons if player == 1 else p2_buttons

	if dict.has(index):
		dict.erase(index)
	elif dict.size() < REQUIRED_SPELLS:
		dict[index] = true

	#feedback de selection
	buttons[index].add_theme_color_override(
		"font_color",
		Color.GREEN if dict.has(index) else Color.WHITE
	)

	_check_ready_to_start()

func _check_ready_to_start() -> void:
	start_button.visible = p1_selected.size() == REQUIRED_SPELLS \
		and p2_selected.size() == REQUIRED_SPELLS

func _show_info(button: Button) -> void:
	spell_info_panel.visible = true
	spell_info_label.text = button.text  # remplacer par les infos du spell
	spell_info_panel.global_position = button.global_position + Vector2(button.size.x, 0)

func _hide_info() -> void:
	spell_info_panel.visible = false

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level.tscn")
	print("P1 spells: ", p1_selected.keys())
	print("P2 spells: ", p2_selected.keys())


func _on_start_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://level.tscn")
