extends CharacterBody2D

@onready var bullet_scene : PackedScene= preload("res://escenas/bullet.tscn")
@onready var joystick_right : VirtualJoystick = $"../../UI2/Virtual joystick right"
@onready var sprite : Sprite2D = $Sprite2D
@onready var collisionShape : CollisionShape2D = $CollisionShape2D
@onready var shoot_timer : Timer = $ShootTimer

var attack_speed : float
var parentPosition : Vector2
var move_vector := Vector2.ZERO
var last_angle = 0
var sprite_angle_correction = 1.6

@export var radius := 20  # Distancia desde el nodo padre, en este caso 20px
@export var number_of_positions := 8  # Número de posiciones en el círculo

func _ready() -> void:
	shoot_timer.wait_time = attack_speed
	shoot_timer.start()
	self.position = parentPosition

func _physics_process(_delta: float) -> void:
	if joystick_right and joystick_right.is_pressed:
		var joystick_angle = joystick_right.output.angle() + sprite_angle_correction # esto ajusta el sprite
		sprite.rotation = joystick_angle
		last_angle = joystick_angle

func _state_shoot1():
	var bullet_instance = bullet_scene.instantiate()
	
	bullet_instance.isNaveAliada = true
	bullet_instance.collisionScale = 0.65
	bullet_instance.spriteScale = 0.25
	var shoot_direction = Vector2.RIGHT.rotated(joystick_right.output.angle())
	# Configurar la posición local de la bala (puede que necesites ajustar esto)
	bullet_instance.parentPosition = self.global_position
	# Configurar la dirección de la bala antes de agregarla a la escena
	bullet_instance.set_direction(shoot_direction)
	# Agregar la bala a la escena
	get_tree().current_scene.add_child(bullet_instance)
	
func _on_timer_timeout() -> void:
	if joystick_right and joystick_right.is_pressed:
		print(shoot_timer.wait_time)
		_state_shoot1()
