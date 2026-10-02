# goys-failover-grupo10

Laboratorio grupal — Failover Routing: "la red que no se cae"
Materia: Gestión Operativa y Seguridad en Redes (GOYS) — UTN FR La Plata
Grupo 10 · Entrega final: 23/10/2026

## Integrantes y roles

| Integrante | Rol |
|---|---|
| Alvite Damian | R1 — Líder / Edge-WAN |
| Capre Rodrigo | R2 — Proveedores |
| Di Grappa Emiliano | R3 — Core |
| Moscuzza Vicente | R4 — Distribución |
| Elizalde Benjamin | R5 — Hosts / QA / Operación |

## Resumen

Red empresarial jerárquica de 5 capas (Internet, Edge, Core, Distribución, Acceso) sobre GNS3 con MikroTik CHR (RouterOS 7): 7 routers, 2 switches y 2 hosts. Redundancia de primer salto con VRRP (2 grupos, load-sharing), de IGP con OSPF área 0 con MD5 (incluido core–core) y de proveedor con eBGP multi-homing (TCP-MD5). Incluye hardening, firewall en el edge, backups, monitoreo y 5 drills de failover.

## Estructura

- `docs/memoria.md`: memoria del laboratorio
- `docs/diagramas/`: topología y diagramas
- `configs/`: `.rsc` finales por router
- `backups/`: `/export` por fecha
- `runbooks/`: un `.md` por drill
- `capturas/`: screenshots por drill
- `backlog.md`: estado de las tareas