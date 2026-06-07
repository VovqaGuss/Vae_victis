extends CharacterBody2D

# Привет тому кто смотрит мой говно-код >:3
# Тебе тут искать нечего!

@export var max_speed : float
@export var friction : float
@export var acceleration : float

@export var health :float
@export var damage : float

@onready var animations = $AnimationPlayer
@onready var sprite = $Sprite2D

enum STATE {
	IDLE,
	RUN
}

var current_state : STATE

func change_state(to : STATE):
	match to :
		STATE.IDLE:
			current_state = STATE.IDLE
		STATE.RUN:
			current_state = STATE.RUN


func _process(delta: float) -> void:
	anim(delta)


func _physics_process(delta: float) -> void:
	if current_state == STATE.RUN:run(delta)
	if current_state == STATE.IDLE:idle(delta)


func _input(event: InputEvent) -> void:
	if Input.get_vector("a", "d", "w", "s"):
		change_state(STATE.RUN)
	else:
		change_state(STATE.IDLE)


func run(delta):
	var dir = Input.get_vector("a", "d", "w", "s")
	var target_velocity : Vector2 = dir.normalized() * max_speed
	velocity.x = move_toward(velocity.x, target_velocity.x, acceleration * max_speed * delta)
	velocity.y = move_toward(velocity.y, target_velocity.y, acceleration * max_speed * delta)
	move_and_slide()


func take_damage(amount : int):
	if health > 0:
		health -= amount
		Eventbus.player_take_damage.emit()
	else:
		die()


func idle(delta):
	velocity.x = move_toward(velocity.x, 0.0, friction * max_speed * delta)
	velocity.y = move_toward(velocity.y, 0.0, friction * max_speed * delta)
	move_and_slide()


func heal(amount):
	if health >= 3:
		health += amount


func anim(delta):
	if velocity:
		animations.speed_scale = move_toward(animations.speed_scale , 1.5, delta)
	else:
		animations.speed_scale = 1
	if position < get_global_mouse_position():
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	match current_state:
		STATE.IDLE:animations.play("idle")
		STATE.RUN:animations.play("run")


func die():
	print("player died!")
