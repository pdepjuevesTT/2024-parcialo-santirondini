
class Trabajo {

    var salario 

    var empleados = []

    method salario() = salario
    
    method esMenorAlAnterior(nuevoSalario) =
    nuevoSalario < salario
    
    method cambiarSalario(nuevoSalario) {
        if(not self.esMenorAlAnterior(nuevoSalario))
        salario = nuevoSalario
        else
        self.error("No se puede bajar el salario")
    }

    method elQueMasCosasTiene() {
        return empleados.max { empleado => empleado.cantidadDeCosas()}
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
    var efectivo

    method formasDePago() = formasDePago 

    method efectivo() = efectivo

    method cantidadDeCosas() {
        return cosas.size()
    }
    method deudas() = deudas

    method nombre() = nombre

    method cambiarFormaPreferida(nuevoMetodo) {
        if(formasDePago.contains(nuevoMetodo))
        formaFavorita = nuevoMetodo
        else 
        self.error("La forma de pago que quieres poner como favorita no esta entre tus formas de pago")
    }

    method esTitular(tarjetaDebito) =
    tarjetaDebito.titulares().contains(nombre)

    method adquirir(cosa) {
        cosas.add(cosa)
    }

    method compraExitosa(cosa,formaDePago) {
    self.adquirir(cosa)
    formaDePago.restar(cosa)    
    }

    method usoDeSueldo(){
        self.cobrarSueldo()
        deudas.removeAllSuchThat{ deuda =>
        self.pagarDeuda(deuda) 
        }
    }

    method comprar(cosa) {
    if(formaFavorita.condicionParaComprar(cosa)) 
    self.compraExitosa(cosa,formaFavorita)
    else 
    self.error("No se puede adquirir :(")
    }

    method puedePagarDeuda(deuda) = sueldo > deuda

    method pagarDeuda(deuda) {
        if(self.puedePagarDeuda(deuda))
        sueldo =  sueldo - deuda 
    }

    method noTieneDeudas() = deudas.size() == 0

    method transcurreMes() {
        self.usoDeSueldo() 
        if(self.noTieneDeudas())
        efectivo = efectivo + sueldo 
    }

    method cobrarSueldo() {
        sueldo =+ trabajo.sueldo()
    }

    method deudasTotales() {
        return deudas.sum()
    }
}

/*

      method transcurreMes() {
        self.cobrarSueldo()
        deudas.removeAllSuchThat{ deuda =>
        self.pagarDeuda(deuda) 
        }
        if(self.noTieneDeudas())
        efectivo = efectivo + sueldo 
    }

*/

class PagadorCompulsivo inherits Persona {

    method pagarConEfectivo(deuda) {
        if(self.efectivo() > deuda){ 
        efectivo = efectivo - deuda 
    }
    }

    override method transcurreMes() {
        self.usoDeSueldo()
        if(not self.noTieneDeudas()) {
        deudas.removeAllSuchThat{ deuda =>
        self.pagarConEfectivo(deuda) 
        }} 
        if(not self.noTieneDeudas())
        self.error("Quedaron deudas sin pagar")        
    }
}

class CompradorCompulsivo inherits Persona {

    method nuevaFormaDePago(cosa) {
        return self.formasDePago().find{forma => forma.condicionParaComprar(cosa)}
    }

    method existeOtraForma(cosa) =
    self.formasDePago().any{ forma => forma.condicionParaComprar(cosa)}

    method pagoConOtrosMetodos(cosa) {
        if (self.existeOtraForma(cosa)) {
            self.compraExitosa(cosa,self.nuevaFormaDePago(cosa))
        } else {
            self.error("No se puede adquirir por ningun metodo :(")
        }
    }

    override method comprar(cosa) {
        if (formaFavorita.condicionParaComprar(cosa))
            self.compraExitosa(cosa, formaFavorita) 
        else
        self.pagoConOtrosMetodos(cosa)
    }
}

class Cosa {

    var precio

    var nombre 

    var lugarDeFabricacion

    method lugarDeFabricacion() = lugarDeFabricacion

    method precio() = precio
}

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