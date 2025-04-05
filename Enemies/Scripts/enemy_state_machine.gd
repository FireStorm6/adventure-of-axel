class_name EnemyStateMachine
extends Node

var states : Array[EnemyState] = []
var prev_state : EnemyState
var current_state : EnemyState

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta):
	var new_state = current_state.Process(delta)
	change_state(new_state)

func _physics_process(delta):
	var new_state = current_state.Physics(delta)
	change_state(new_state)

func initialize(_enemy: Enemy) -> void:
	# Clear existing states
	states = []
	
	# Get all children and filter for EnemyState nodes
	for child in get_children():
		if child is EnemyState:
			states.append(child)
	
	# Alternative one-liner using filter():
	# states = get_children().filter(func(child): return child is EnemyState)
	
	# Initialize each state
	for state in states:
		state.enemy = _enemy
		state.state_machine = self
		state.init()
	
	# Start the first state if available
	if states.size() > 0:
		change_state(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT

func change_state(new_state: EnemyState) -> void:
	# Always allow Destroy state to interrupt
	if new_state is EnemyStateDestroy:
		_force_change_state(new_state)
		return
		
	# Block if already in Destroy state
	if current_state is EnemyStateDestroy:
		return
		
	# Normal transition logic
	if new_state && new_state != current_state:
		if current_state:
			current_state.Exit()
		prev_state = current_state
		current_state = new_state
		current_state.Enter()

func _force_change_state(new_state: EnemyState):
	print("FORCING state change to %s" % new_state.name)
	if current_state:
		current_state.Exit()
	current_state = new_state
	current_state.Enter()
