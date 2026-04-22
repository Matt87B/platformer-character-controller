extends Control

@onready var _menus: Control      = $Menus
@onready var _hud: Control        = $HUD
@onready var _scene_stack: Node2D = $SceneStack

func _ready() -> void:
	_scene_stack.initialize(_menus)

	GameStateManager.state_changed.connect(_on_state_changed)
	GameStateManager.menu_scene_requested.connect(_on_menu_scene_requested)

#Menu
func push_menu(scene_path: String) -> void:
	var scene: Node = _scene_stack.push(scene_path)
	_connect_menu_signals(scene)

func pop_menu() -> void:
	_scene_stack.pop()

func clear_menus() -> void:
	_scene_stack.clear()

#HUD
func show_hud() -> void:
	if _hud:
		_hud.visible = true

func hide_hud() -> void:
	if _hud:
		_hud.visible = false

#Signals
func _connect_menu_signals(menu: Node) -> void:
	if menu == null:
		return
	if menu.has_signal("navigate_to"):
		menu.navigate_to.connect(_on_navigate_to)
	if menu.has_signal("go_back"):
		menu.go_back.connect(_on_go_back)

func _on_navigate_to(path: String) -> void:
	push_menu(path)

func _on_go_back() -> void:
	pop_menu()

##Reacts to state changes from the GSM
func _on_state_changed(state: GameStateManager.GameState) -> void:
	match state:
		GameStateManager.GameState.GAMEPLAY:
			clear_menus()
			show_hud()
		GameStateManager.GameState.PAUSED:
			hide_hud()
			push_menu(GameStateManager.SCENE_PAUSE_MENU)
		GameStateManager.GameState.DIALOGUE:
			push_menu(GameStateManager.SCENE_DIALOGUE)
		GameStateManager.GameState.TRANSITION:
			clear_menus()
			hide_hud()
		GameStateManager.GameState.MENU:
			clear_menus()
			hide_hud()
			push_menu(GameStateManager.SCENE_MAIN_MENU)

##Called when the GSM wants a menu pushed without a state change
func _on_menu_scene_requested(scene_path: String) -> void:
	push_menu(scene_path)
