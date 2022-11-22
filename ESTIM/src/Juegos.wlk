//PLATAFORMA ESTIM
object estim {
	
	const juegos=[]
	
	method agregarJuego(juego){juegos.add(juego)}
	
	method juegoMasCaro()= juegos.max{j=>j.precio()}
	
	method precioJuegoMasCaro()=self.juegoMasCaro().precio()
											    
	method juegosQueSuperan3Cuartos()=juegos.filter
		{j=> j.precio() > (self.precioJuegoMasCaro()*0.75)}
		
	method descuentoEspecialx(cant)=self.juegosQueSuperan3Cuartos().map
	{j=> j.descuentoEspecial(cant)	 }
	
	method juegosDePais(pais)=
	juegos.filter{j=>j.pais()==pais}

	method precioTotalDeJuegosDe(pais){return self.juegosDePais(pais).sum{j=>j.precio()}}
		
	method cantidadDeJuegosDe(pais)=self.juegosDePais(pais).size()

	method promedioPrecioParaMenoresEn(pais){ return
	(self.precioTotalDeJuegosDe(pais) / self.cantidadDeJuegosDe(pais)).truncate(0) }
	
	
	}

//JUEGOS
class Juego {
	const property criticas=[]
	const property precio
	const property contieneViolencia
	const property contieneLenguajeInapropiado
	const property contieneTematicaDeAdulto
	var property pagaPorCritica
	var property pais
	
	method descuentoDirecto(descuento)=(descuento*precio)/100
	
	method descuentoFijo(descuento)=(precio/2).max(precio-descuento)
	
	method gratis()=precio-precio
	
	method aplicarDescuentoEspecial(descuento)= precio-self.descuentoDirecto(descuento).truncate(0)
		
	method descuentoEspecial(descuento)=
	if (descuento >= 100) {self.error("No es posible bajar el precio a mas del 100%")}
	 else {self.aplicarDescuentoEspecial(descuento)}
	
	method recibirCritica(critico)= criticas.add(critico)

	method criticasQueSonPositivas()= criticas.filter{c => c.votoPositivo()}
	
	method cantidadDeCriticasPositivas() = self.criticasQueSonPositivas().size() 
	
	method superaElUmbralDePositivas(cantidad)= self.criticasQueSonPositivas() > cantidad
	
	method tieneCriticosLiterarios() = criticas.any{c => c.texto().size() > 100}

	method esJuegoGalardonado() = criticas.all{c => c.votoPositivo()}

}

class JuegoRetro inherits Juego{
	var descuentoPorMalosGraficos
	override method descuentoDirecto(descuento)=(super(descuento)) - descuentoPorMalosGraficos  
}

//PAISES

class Pais {
	
var violenciaEsAptaMenores
var tematicaAdultoEsAptoMenores
var lenguajeInapropiadoEsAptoMenores
var equivalenteADolar 

method precioEnEstePais(juego)=juego.precio() * equivalenteADolar


method esJuegoAptoMenores(juego)=
	( juego.contieneViolencia()==violenciaEsAptaMenores 	and
	juego.contieneTematicaDeAdulto()==tematicaAdultoEsAptoMenores and
	juego.contieneLenguajeInapropiado()==lenguajeInapropiadoEsAptoMenores)
	
}

///REVIEWS 

class CriticoUsuario{

var property votoPositivo
method texto()= if (votoPositivo) "Sí" else  "No"

}

class CriticoPago inherits CriticoUsuario  {

override method votoPositivo(juego)=juego.pagaPorCritica()
 
method recibirPagoDe(juego){juego.pagaPorCritica(true)}

override method texto()=if(votoPositivo)

			["Buenisimo","Espectacular","Genial","Excelente",
				"Me encantó", "Uno de los mejores"	].anyOne()
				
 else 
 
 			["No me gustó","Puede mejorar","Pésimo","Terrible",
 				"Me parece absurdo", "Muy malo"		].anyOne()
 											
}


class CriticoRevista inherits CriticoPago {
	
const revista = []
	
method agregarARevista(miembro){revista.add(miembro)}
 
method sacarMiembroDeRevista(miembro){revista.remove(miembro)}
 
override method votoPositivo()=
 self.cantidadCriticasPositivas() > self.cantidadCriticasNegativas() 	
 
override method texto() = self.textosTotal()
 
method textosTotal()=revista.filter{c=> c.texto()}
 
method cantidadCriticasPositivas()= self.criticasPositivasRevista().size()
 
method cantidadCriticasNegativas()=self.criticasNegativasRevista().size()
	
method criticasPositivasRevista()=revista.filter{c => c.votoPositivo()}
 
method criticasNegativasRevista()=revista.filter{c => !c.votoPositivo()}
	
}	
	
