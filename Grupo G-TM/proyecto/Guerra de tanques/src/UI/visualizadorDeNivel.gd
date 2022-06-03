extends Panel


var mapasDisponibles = []
var cargar = ""
puppet var nivelIdx = 0


func listar_archivos(path):
	var archivos = []
	var directorios = Directory.new()
	if not directorios.open(path) == OK:
		print("error at openning")
	directorios.list_dir_begin()
	while true:
		var archivo = directorios.get_next()
		if archivo == "":
			break
		elif not archivo.begins_with("."):
			archivos.append(archivo)

	directorios.list_dir_end()

	return archivos

func obtener_imagen_del_nivel(levelName):
	return load("res://src/mundo/niveles/imagenesNiveles/" + levelName + ".PNG")


func _ready():
	for level in listar_archivos("res://src/mundo/niveles/nivelesDisponibles/"):
		var splitted = (level as String).split(".")
		mapasDisponibles.append({"path" : "res://src/mundo/niveles/nivelesDisponibles/"+level, "name" : splitted[0], "playerNb" : int( splitted[1] ),
		 "gamemode" : splitted[2], "imgRes" : obtener_imagen_del_nivel(splitted[0])})
	actualizar_vista_de_nivel()

remote func actualizar_vista_de_nivel():
	$NombreNivel.text = mapasDisponibles[nivelIdx].name
	$ImagenMapa.texture = mapasDisponibles[nivelIdx].imgRes
	$modoJuego.text = mapasDisponibles[nivelIdx].gamemode
	$label.text = str(mapasDisponibles[nivelIdx].playerNb)
	cargar = mapasDisponibles[nivelIdx].path


func _on_Next_pressed():
	nivelIdx = (nivelIdx + 1)%len(mapasDisponibles)
	actualizar_vista_de_nivel()
	rset("nivelIdx",nivelIdx)
	rpc("actualizar_vista_de_nivel")


func _on_Previous_pressed():
	nivelIdx = (nivelIdx - 1)%len(mapasDisponibles)
	actualizar_vista_de_nivel()
	rset("nivelIdx",nivelIdx)
	rpc("actualizar_vista_de_nivel")


func actualizar_nuevo_jugador(id):
	rset_id(id, "nivelIdx", nivelIdx)
	rpc_id(id, "actualizar_vista_de_nivel")
