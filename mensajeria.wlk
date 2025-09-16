object laMensajeria {
    var mensajeros = []
    var paquetesPendientes = []
    var historialDePaquetesEnviados = []
    var facturacion = 0

    
    method contratar(unMensajero) {
        mensajeros.add(unMensajero)
    }

    method despedir(unMensajero) {
        mensajeros.remove(unMensajero)
    }

    method despedirATodos() {
        mensajeros.clear()
    }

    method esGrande() = mensajeros.size() > 2

    method puedeSerEntregadoPorElPrimerEmpleado(unPaquete) {
        if (mensajeros.isEmpty()) return false
        return unPaquete.puedeSerEntregadoPor(mensajeros.first())
    }

    method pesoDelUltimoMensajero() = mensajeros.last().peso()

  
    method puedeSerEntregado(unPaquete) {
        return mensajeros.any({ unMensajero | unPaquete.puedeSerEntregadoPor(unMensajero) })
    }

    method mensajerosCapacesDeEntregar(unPaquete) {
        return mensajeros.filter({ unMensajero | unPaquete.puedeSerEntregadoPor(unMensajero) })
    }

    method tieneSobrepeso() {
        const pesoTotal = mensajeros.sum({ unMensajero | unMensajero.peso() })
        return pesoTotal / mensajeros.size() > 500
    }

    method enviar(unPaquete) {
        const mensajeroElegido = self.mensajerosCapacesDeEntregar(unPaquete).first()
        if (mensajeroElegido.isNotNull()) {
            historialDePaquetesEnviados.add(unPaquete)
            facturacion += unPaquete.precio()
        } else {
            paquetesPendientes.add(unPaquete)
        }
    }

    method facturacion() = facturacion

    method enviarVarios(paquetes) {
        paquetes.forEach({ unPaquete | self.enviar(unPaquete) })
    }

    method enviarPendienteMasCaro() {
        const paqueteMasCaro = paquetesPendientes.max({ unPaquete | unPaquete.precio() })
        if (paqueteMasCaro.isNotNull() && self.puedeSerEntregado(paqueteMasCaro)) {
            self.enviar(paqueteMasCaro)
            paquetesPendientes.remove(paqueteMasCaro)
        }
    }

    
    method cantidadDeMensajeros() = mensajeros.size()
    method historialDePaquetesEnviados() = historialDePaquetesEnviados
    method paquetesPendientes() = paquetesPendientes
}


object paquetito {
    method esPago() = true
    method puedeSerEntregadoPor(unMensajero, unDestino) = true
    method precio() = 0
}

object paquetonViajero {
    var destinos = []
    var montoPagado = 0
    const precioPorDestino = 100

    method agregarDestino(unDestino) {
        destinos.add(unDestino)
    }
    method pagar(monto) {
        montoPagado += monto
    }
    method precio() = destinos.size() * self.precioPorDestino
    method esPago() = montoPagado >= self.precio()
    method puedeSerEntregadoPor(unMensajero, unDestino) {
        
        return destinos.all({ unDestino => unDestino.permitePaso(unMensajero) })
    }
}