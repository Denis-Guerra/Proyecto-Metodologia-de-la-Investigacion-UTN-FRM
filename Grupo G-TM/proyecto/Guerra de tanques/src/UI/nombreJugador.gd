extends LineEdit



func _ready():
	$HTTPRequest.request("https://www.generateur-de-pseudo.fr/")



func _respuesta_http_completada(result, response_code, headers, cuerpo):
	var para_buscar_en : String = cuerpo.get_string_from_utf8()
	var posiblePosicionInicial = para_buscar_en.find("pseudo-list")

	print(posiblePosicionInicial)
	para_buscar_en = para_buscar_en.right(posiblePosicionInicial)
	
	var FinalizarBusqueda = para_buscar_en.find("</")
	
	print(FinalizarBusqueda)
	para_buscar_en = para_buscar_en.left(FinalizarBusqueda)
	para_buscar_en = para_buscar_en.right(para_buscar_en.find("<p>") + 3)
	if len(para_buscar_en) > 0:
		text = para_buscar_en
	



	


func _on_Unirse_mouse_entered():
	pass # Replace with function body.
