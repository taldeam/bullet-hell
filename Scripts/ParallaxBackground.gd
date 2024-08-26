extends ParallaxBackground

# Velocidad de desplazamiento del fondo
var scroll_speed = 40

# Llamado cuando el nodo entra en el árbol de la escena por primera vez.
func _ready():
	# Configura el movimiento automático
	scroll_offset = Vector2(0, 0)
	# Reemplaza con el cuerpo de la función si necesitas inicializar algo

# Llamado cada cuadro. 'delta' es el tiempo transcurrido desde el cuadro anterior.
func _process(delta):
	scroll_offset.x += scroll_speed * delta
