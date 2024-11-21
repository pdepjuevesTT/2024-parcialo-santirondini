
//las cuotas se pagan con el sueldo, si no, se van al efectivo 

/*
const cosa = new Cosa(precio = 100,nombre = "Libro")
const tarjetaDebito = new TarjetaDebito(monto = 200,titulares = ["santino"])
const santino = new Persona(nombre = "santino" , formaFavorita = tarjetaDebito)
*/


class Trabajo {

    var salario 

    method salario() = salario
    
    method esMenorAlAnterior(nuevoSalario) =
    nuevoSalario < salario
    
    method cambiarSalario(nuevoSalario) {
        if(not self.esMenorAlAnterior(nuevoSalario))
        salario = nuevoSalario
        else
        self.error("No se puede bajar el salario")
    }
}
class Persona {

    var nombre
    var formasDePago = [] 
    var formaFavorita 
    var cosas = []
    var deudas = []
    var trabajo
    var sueldo

    method deudas() = deudas

    method nombre() = nombre

    method cambiarFormaPreferida(nuevoMetodo) {
        if(formasDePago.contains(nuevoMetodo))
        formaFavorita = nuevoMetodo
        else 
        self.error("La forma de pago que quieres poner como favoritam no esta entre tus formas de pago")
    }

    method esTitular(tarjetaDebito) =
    tarjetaDebito.titulares().contains(nombre)

    method adquirir(cosa) {
        cosas.add(cosa)
    }

    method comprar(cosa) {
    if(formaFavorita.condicionParaComprar(cosa)) {
    self.adquirir(cosa)
    formaFavorita.consecuencia(cosa,self)
    formaFavorita.restar(cosa)    
    }
    else 
    self.error("No se puede adquirir :(")
    }

    method puedePagarDeuda(monto,deuda) = monto > deuda

    method pagarDeudas() {

    }

    method transcurreMes() {
        const sueldo = self.cobrarSueldo()
        deudas.forEach 


    }

    method cobrarSueldo() {
        return trabajo.sueldo()
    }
}

class Cosa {

    var precio

    var nombre 

    method precio() = precio
}

class TarjetaCredito inherits FormaDePago {

    var cantCuotas 
    var interes

    method valorCuota(cosa) {
        return (cosa.precio()*interes) / cantCuotas
    }

    method precioNoSuperaMaximo(cosa) = cosa.precio() <= monto

    override method condicionParaComprar(cosa) = self.precioNoSuperaMaximo(cosa) 

    override method consecuencia(cosa,persona) {
        self.almacenarDeudas(cosa, persona)
    }

    method almacenarDeudas(cosa,persona) {
        cantCuotas.times(persona.deudas().add(self.valorCuota(cosa)))       
    }

}

class FormaDePago {
    
    var monto

    method monto() = monto

    method condicionParaComprar(cosa)

    method restar(cosa)

    method consecuencia(cosa,persona)
}

class TarjetaDebito inherits FormaDePago  {

    var titulares

    method titulares() = titulares

    method noSuperaMonto(cosa) = cosa.precio() <= monto 

    override method condicionParaComprar(cosa) =
    self.noSuperaMonto(cosa)

    override method restar(cosa) {
        monto = monto - cosa.precio()
    }
}

class Efectivo inherits FormaDePago { 

    override method condicionParaComprar(cosa) = 
    monto >= cosa.precio()

    override method restar(cosa) {
        monto = monto - cosa.precio()
    }
}