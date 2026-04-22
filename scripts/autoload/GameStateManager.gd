## GameStateManager.gd
## Autoload singleton — owns all state transitions and scene-path configuration.
## Nothing outside this file should call set_state() directly.
extends Node

#Scene paths
const SCENE_MAIN_MENU	:= "res://scenes/user_interface/main_menu.tscn"
const SCENE_OPTIONS		:= "res://scenes/user_interface/options.tscn"
const SCENE_LOAD		:= "res://scenes/user_interface/load_menu.tscn"
const SCENE_PAUSE_MENU	:= "res://scenes/user_interface/pause_menu.tscn"
const SCENE_DIALOGUE	:= "res://scenes/user_interface/dialogue_box.tscn"
const SCENE_CONTROLS	:= "res://scenes/user_interface/controls.tscn"
const SCENE_SOUND		:= "res://scenes/user_interface/sound.tscn"
const SCENE_VIDEO		:= "res://scenes/user_interface/video.tscn"


#Level paths
const LEVEL_1			:= "res://scenes/level_1.tscn"

#States
enum GameState {
	GAMEPLAY,
	PAUSED,
	DIALOGUE,
	TRANSITION,
	MENU,
	CUTSCENE,
}

var current_state: GameState = -1

signal state_changed(new_state: GameState)

#UI Requests
signal menu_scene_requested(scene_path: String)

#LevelContainer Requests
signal level_load_requested(level_path: String)
signal level_unload_requested

signal level_loaded

#Camera Requests
signal cinematic_move_requested(destination: Vector2, duration: float)

func _ready() -> void:
	level_loaded.connect(_on_level_loaded)

###Public API

#UI
func start_game(level_path: String) -> void:
	set_state(GameState.TRANSITION)
	level_load_requested.emit(level_path)

func go_to_main_menu() -> void:
	set_state(GameState.MENU)

func open_options_menu() -> void:
	menu_scene_requested.emit(SCENE_OPTIONS)

#Pause/Resume
func pause_game() -> void:
	if current_state != GameState.GAMEPLAY:
		return
	set_state(GameState.PAUSED)

func resume_game() -> void:
	if current_state != GameState.PAUSED:
		return
	set_state(GameState.GAMEPLAY)

#Dialogue
func start_dialogue() -> void:
	set_state(GameState.DIALOGUE)

func end_dialogue() -> void:
	set_state(GameState.GAMEPLAY)

#Cutscene
func start_cutscene() -> void:
	set_state(GameState.CUTSCENE)

func end_cutscene() -> void:
	set_state(GameState.GAMEPLAY)

#Save, load and quit
func save_and_exit_to_menu() -> void:
	set_state(GameState.TRANSITION)
	level_unload_requested.emit()
	set_state(GameState.MENU)

func quit_game() -> void:
	get_tree().quit()


func set_state(new_state: GameState) -> void:
	if new_state == current_state:
		return
	_exit_state(current_state)
	current_state = new_state
	_enter_state(current_state)
	state_changed.emit(current_state)

func _enter_state(state: GameState) -> void:
	match state:
		GameState.GAMEPLAY:
			get_tree().paused = false
		GameState.PAUSED:
			get_tree().paused = true
		GameState.DIALOGUE:
			get_tree().paused = true
		GameState.TRANSITION:
			get_tree().paused = true
		GameState.MENU:
			get_tree().paused = false

func _exit_state(_state: GameState) -> void:
	#TODO: Write state teardown logic
	pass

#LevelContainer feedback
func _on_level_loaded() -> void:
	set_state(GameState.GAMEPLAY)

#Global input
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		match current_state:
			GameState.GAMEPLAY:
				pause_game()
			GameState.PAUSED:
				resume_game()
