package cl.duoc.caso02.facturacion.service;

import java.util.List;
import java.util.Optional;
import org.springframework.stereotype.Service;
import cl.duoc.caso02.facturacion.model.Factura;
import cl.duoc.caso02.facturacion.repository.FacturaRepository;

@Service
public class FacturaService {

    private final FacturaRepository repository;

    public FacturaService(FacturaRepository repository) {
        this.repository = repository;
    }

    public List<Factura> findAll() {
        return repository.findAll();
    }

    public Optional<Factura> findById(Long id) {
        return repository.findById(id);
    }

    public Factura create(Factura recurso) {
        return repository.save(recurso);
    }

    public Optional<Factura> update(Long id, Factura datos) {
        return repository.findById(id).map(existente -> {
            existente.setNombre(datos.getNombre());
            existente.setPlan(datos.getPlan());
            existente.setMonto(datos.getMonto());
            return repository.save(existente);
        });
    }

    public boolean delete(Long id) {
        return repository.findById(id).map(existente -> {
            repository.delete(existente);
            return true;
        }).orElse(false);
    }
}
