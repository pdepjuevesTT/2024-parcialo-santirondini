
//las cuotas se pagan con el sueldo, si no, se van al efectivo 

/*
const cosa = new Cosa(precio = 100,nombre = "Libro")
const tarjetaDebito = new TarjetaDebito(monto = 200,titulares = [santino])
const santino = new Persona(formaFavorita = tarjetaDebito, efectivo = 50)
*/
class Persona {

    var formasDePago = [] 
    var formaFavorita 
    var cosas = []
    var deudas = []
    var efectivo

    method cambiarFormaPreferida(nuevoMetodo) {
        if(formasDePago.contains(nuevoMetodo))
        formaFavorita = nuevoMetodo
    }

    method efectivo() = efectivo

    method esTitular(tarjetaDebito) =
    tarjetaDebito.titulares().contains(self)


    method adquirir(cosa) {
        cosas.add(cosa)Persona
    }

    method comprar(cosa) {
    if(formaFavorita.condicionParaComprar(cosa,self))
    self.adquirir(cosa)
    else 
    self.error("No se puede adquirir :(")
    }
}

class Cosa {

    var precio

    var nombre 

    method precio() = precio
}

class TarjetaCredito {

    var cantCuotas 
    var maximo 
    var interes

    method valorCuota(cosa) {
        return (cosa.precio()*interes) / cantCuotas
    }

    method precioNoSuperaMaximo(cosa) = cosa.precio() < maximo

    method condicionParaComprar(cosa,persona) = self.precioNoSuperaMaximo(cosa)
}

class TarjetaDebito {

    var monto

    var titulares  

    method titulares() = titulares

    method noSuperaMonto(cosa) = cosa.precio() < monto 

    method condicionParaComprar(cosa,persona) =
    persona.esTitular(self) && self.noSuperaMonto(cosa)
}

class Efectivo {

    method condicionParaComprar(cosa,persona) = 
    persona.efectivo() > cosa.precio()
}