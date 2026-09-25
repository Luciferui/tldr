extends Control

#Sorts disponibles
@onready var p1_spell_buttons: Array = [$VBoxContainer/Spell1, $VBoxContainer/Spell2, $VBoxContainer/Spell3, $VBoxContainer/Spell4, $VBoxContainer/Spell5]
@onready var p2_spell_buttons: Array = [$VBoxContainer2/Spell1, $VBoxContainer2/Spell2, $VBoxContainer2/Spell3, $VBoxContainer2/Spell4, $VBoxContainer2/Spell5]

#Slots (3 par joueur)
@onready var p1_slot_buttons: Array = [$VBoxContainerSlots/Slot1, $VBoxContainerSlots/Slot2, $VBoxContainerSlots/Slot3]
@onready var p2_slot_buttons: Array = [$VBoxContainerSlots2/Slot1, $VBoxContainerSlots2/Slot2, $VBoxContainerSlots2/Slot3]

#Conteneurs pour basculer entre vue "slots" et vue "liste des sorts"
@onready var p1_spelllist_container: Control = $VBoxContainer
@onready var p2_spelllist_container: Control = $VBoxContainer2
@onready var p1_slotlist_container: Control = $VBoxContainerSlots
@onready var p2_slotlist_container: Control = $VBoxContainerSlots2

@onready var start_button: Button = $StartButton
@onready var main_menu_button: Button = $MainMenuButton
@onready var p1_spell_info_panel: PanelContainer = $SpellInfoPanel1
@onready var p1_spell_info_label: Label = $SpellInfoPanel1/Label
@onready var p2_spell_info_panel: PanelContainer = $SpellInfoPanel2
@onready var p2_spell_info_label: Label = $SpellInfoPanel2/Label

# Descriptions des sorts, dans le même ordre que les boutons Spell1..Spell5
# (indices 0 à 4, partagés par les deux joueurs)
const SPELL_DESCRIPTIONS := [
	"Description du sort 1 à compléter.",
	"Description du sort 2 à compléter.",
	"Description du sort 3 à compléter.",
	"Description du sort 4 à compléter.",
	"Description du sort 5 à compléter.",
]

const REQUIRED_SPELLS := 3
const NUM_SPELLS := 5

enum Mode { SLOTS, PICKING, START, MENU }

var p1_mode: int = Mode.SLOTS
var p2_mode: int = Mode.SLOTS

var p1_slot_index := 0   # slot en surbrillance en mode SLOTS
var p2_slot_index := 0

var p1_pick_index := 0   # index dans la liste des sorts DISPONIBLES en mode PICKING
var p2_pick_index := 0

var p1_editing_slot := -1  # quel slot est en train d'être rempli
var p2_editing_slot := -1

var p1_slots := [-1, -1, -1]  # index de sort (0 à 4) assigné à chaque slot, -1 = vide
var p2_slots := [-1, -1, -1]

var p1_spell_names: Array = []
var p2_spell_names: Array = []


func _ready() -> void:
	start_button.visible = false
	p1_spell_info_panel.visible = false
	p2_spell_info_panel.visible = false

	for b in p1_spell_buttons:
		p1_spell_names.append(b.text)
	for b in p2_spell_buttons:
		p2_spell_names.append(b.text)

	for b in p1_spell_buttons + p2_spell_buttons + p1_slot_buttons + p2_slot_buttons + [start_button, main_menu_button]:
		b.focus_mode = Control.FOCUS_NONE

	# Au départ on voit les slots (vides), pas la liste des sorts
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

	if event.is_action_pressed(up_action):
		_move(player, -1)
	elif event.is_action_pressed(down_action):
		_move(player, 1)
	elif event.is_action_pressed(kick_action):
		_confirm(player)


func _move(player: int, dir: int) -> void:
	var mode: int = p1_mode if player == 1 else p2_mode

	match mode:
		Mode.SLOTS:
			if player == 1:
				# En descendant depuis le dernier slot, si Start est visible -> on va sur Start
				if dir == 1 and p1_slot_index == REQUIRED_SPELLS - 1 and start_button.visible:
					p1_mode = Mode.START
				# En remontant depuis le premier slot -> on va sur Return to Menu
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
			# Seul p1 peut être en mode START ; remonter revient au dernier slot
			if player == 1 and dir == -1:
				p1_mode = Mode.SLOTS
				p1_slot_index = REQUIRED_SPELLS - 1

		Mode.MENU:
			# Seul p1 peut être en mode MENU ; descendre revient au premier slot
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
			if player == 1 and start_button.visible:
				_on_start_button_pressed()
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
		return  # ne devrait pas arriver (5 sorts pour 3 slots)

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


func _get_available_indices(player: int) -> Array:
	var slots: Array = p1_slots if player == 1 else p2_slots
	var editing_slot: int = p1_editing_slot if player == 1 else p2_editing_slot
	var result: Array = []
	for i in range(NUM_SPELLS):
		var owner_slot: int = slots.find(i)
		# disponible si personne ne l'a, ou si c'est justement le slot qu'on est en train d'éditer
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
	var names: Array = p1_spell_names if player == 1 else p2_spell_names

	for i in slot_buttons.size():
		if slots[i] == -1:
			slot_buttons[i].text = "Slot %d - Vide" % (i + 1)
		else:
			slot_buttons[i].text = names[slots[i]]


func _refresh_highlights() -> void:
	for b in p1_spell_buttons + p2_spell_buttons + p1_slot_buttons + p2_slot_buttons:
		b.remove_theme_color_override("font_color")
	start_button.remove_theme_color_override("font_color")
	main_menu_button.remove_theme_color_override("font_color")

	p1_spell_info_panel.visible = false
	p2_spell_info_panel.visible = false

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

		Mode.MENU:
			_set_highlight(main_menu_button, true)


func _set_highlight(button: Button, on: bool) -> void:
	if on:
		button.add_theme_color_override("font_color", "f2f200")
	else:
		button.remove_theme_color_override("font_color")


func _check_ready_to_start() -> void:
	var p1_done: bool = not (-1 in p1_slots)
	var p2_done: bool = not (-1 in p2_slots)
	start_button.visible = p1_done and p2_done


func _show_spell_info(player: int, spell_index: int) -> void:
	var panel: PanelContainer = p1_spell_info_panel if player == 1 else p2_spell_info_panel
	var label: Label = p1_spell_info_label if player == 1 else p2_spell_info_label
	var names: Array = p1_spell_names if player == 1 else p2_spell_names

	panel.visible = true
	label.text = "%s\n%s" % [names[spell_index], SPELL_DESCRIPTIONS[spell_index]]


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_start_button_pressed() -> void:
	DataDistributor.distribute_spells(p1_slots, p2_slots)
	get_tree().change_scene_to_file("res://Scenes/level.tscn")
