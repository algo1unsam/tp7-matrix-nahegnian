object morfeo {
    const pesoBase = 90
    var transporte = camion

    method peso() {
        return self.pesoBase + self.transporte.peso()
    }
    method transporte() = transporte
    method transporte(nuevoTransporte) {
        transporte = nuevoTransporte
    }
}

object camion {
    var acoplados = 1
    const pesoPorAcoplado = 500

    method peso() = self.acoplados * self.pesoPorAcoplado
    method acoplados(cantidad) {
        acoplados = cantidad
    }
}

object monopatin {
    method peso() = 1
}

object puente {
    const limitePeso = 1000

    method dejarPasar(unMensajero) {
        return unMensajero.peso() <= self.limitePeso
    }
}

object paquete {
    var estaPago = false
    var destino
    
    method pagar() {
        estaPago = true
    }
    method estaPago() = estaPago
    method destino(unDestino) {
        destino = unDestino
    }
    method puedeSerEntregadoPor(unMensajero) {
        return self.estaPago() and destino.dejarPasar(unMensajero)
    }
}