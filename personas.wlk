class Persona {

    var sueldo 
    //var efectivo 
    var formasDePago = []
    var formaFavorita
    var cosas = []

    method adquirir(cosa) {
        cosas.add(cosa)
    }

    method comprar(cosa) {
    if(formaFavorita.condicionParaComprar(cosa))
    self.adquirir(cosa)
    else 
    self.error("No se puede adquirir :(")
    }

}

const teclado = new Cosa

class Cosa{

    var nombre
    
    var precio 
}
class CuentaBancaria {

    var saldoDeCuenta

    var titulares = []
}

class TarjetaCredito {

    var limite 

    var tasaDeInteres

    var cantCuotas 
}


