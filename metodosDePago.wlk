import personas.*

class TarjetaCredito inherits Tarjeta {

    var cantCuotas 
    var interes
    var titular

    method valorCuota(cosa) {
        return (cosa.precio()*interes) / cantCuotas
    }

    method precioNoSuperaMaximo(cosa) = cosa.precio() <= monto

    override method condicionParaComprar(cosa) = self.precioNoSuperaMaximo(cosa) 

    override method consecuenciaDeFormaDePago(cosa) {
        self.almacenarDeudas(cosa)
    }

    method almacenarDeudas(cosa) {
        cantCuotas.times(titular.deudas().add(self.valorCuota(cosa)))       
    }

}

class Tarjeta {
    
    var monto

    method monto() = monto

    method condicionParaComprar(cosa)

    method consecuenciaDeFormaDePago(cosa)
}

class TarjetaDelSony inherits TarjetaCredito {


    method tenerUnPrecioCuervo(cosa) = cosa.precio() > 6082014 

    method hechoEnBoedo(cosa) = cosa.lugarDeFabricacion() == "Boedo"
    
    override method condicionParaComprar(cosa) = 
    self.tenerUnPrecioCuervo(cosa) && self.hechoEnBoedo(cosa)

    override method valorCuota(cosa) {
        return (cosa.precio()*interes + 1908) / cantCuotas
    }

    override method almacenarDeudas(cosa) {
        cantCuotas.times(titular.deudas().add(self.valorCuota(cosa)))       
    }
}

class TarjetaDebito inherits Tarjeta  {

    var titulares

    method titulares() = titulares

    method noSuperaMonto(cosa) = cosa.precio() <= monto 

    override method condicionParaComprar(cosa) =
    self.noSuperaMonto(cosa)

    override method consecuenciaDeFormaDePago(cosa) {
        monto = monto - cosa.precio()
    }
}

class Efectivo { 
    
    var persona
    
    method condicionParaComprar(cosa) = 
    persona.efectivo() >= cosa.precio()

    method consecuenciaDeFormaDePago(cosa) {
        persona.efectivo( persona.efectivo() - cosa.precio()) 
    }

    method sumarEfectivo(cantidad) {
        persona.efectivo(persona.efectivo() + cantidad) 
    }
}