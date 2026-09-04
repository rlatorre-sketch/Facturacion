package cl.duoc.caso02.facturacion;

import org.junit.jupiter.api.Test;
import cl.duoc.caso02.facturacion.config.OpenApiConfig;

import static org.assertj.core.api.Assertions.assertThat;

class OpenApiConfigTest {

    @Test
    void beanOpenApiGenerado() {
        assertThat(new OpenApiConfig().customOpenAPI()).isNotNull();
    }
}
