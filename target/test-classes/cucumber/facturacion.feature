# language: es
Característica: Servicio Facturación (microservicio facturacion del caso caso02)
  Los escenarios validan el contrato REST del microservicio alineado a sus endpoints.

  Escenario: el listado del recurso responde 200
    Dado el servicio "Facturación" está disponible
    Cuando consulto el listado de "facturas"
    Entonces el listado responde con código 200

  Escenario: ciclo de vida completo del recurso
    Dado un nuevo "factura" con nombre "hola-cucumber"
    Cuando consulto el "factura" recién creado
    Entonces el recurso tiene nombre "hola-cucumber" y código 200
    Cuando actualizo el "factura" con nombre "cucumber-actualizado"
    Entonces el recurso queda con nombre "cucumber-actualizado" y código 200
    Cuando elimino el "factura"
    Entonces la eliminación responde con código 204
    Y al consultar el "factura" eliminado responde 404
