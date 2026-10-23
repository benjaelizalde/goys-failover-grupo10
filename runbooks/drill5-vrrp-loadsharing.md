# Drill 5: Load-sharing VRRP (Ambos DIST activos)

## 1. Detección / Objetivo
- **Objetivo:** Verificar la operación en modo Active-Active (Load-sharing) de la capa de Distribución, evitando nodos ociosos y distribuyendo el plano de reenvío por segmento de red.
- **Herramienta de verificación:**
  - Inspección de estados VRRP con `/interface vrrp print` en DIST-1 y DIST-2.
  - Ejecución de `traceroute 198.51.100.1` desde PC-USER y desde SRV para validar el primer salto.
  - Monitoreo de contadores en interfaces físicas con `/interface print stats where name~"ether"`.

## 2. Configuración y Comportamiento Observado
- **Topología de grupos VRRP:**
  - VRID 10 (USERS): DIST-1 opera como Running Master (`RM`, prio 200); DIST-2 opera como Backup (`B`, prio 100).
  - VRID 20 (SERVERS): DIST-2 opera como Running Master (`RM`, prio 200); DIST-1 opera como Backup (`B`, prio 100).
- **Rutas de primer salto medidas:**
  - `PC-USER` envía su tráfico por el gateway virtual `192.168.10.1`, resolviendo el salto 1 por la IP física de DIST-1 (`192.168.10.2`).
  - `SRV` envía su tráfico por el gateway virtual `192.168.20.1`, resolviendo el salto 1 por la IP física de DIST-2 (`192.168.20.3`).
- **Tráfico concurrente:** Ambos routers registraron incremento simultáneo en sus interfaces de acceso LAN (más de 1.000 paquetes procesados en ether3 de DIST-1 y ether4 de DIST-2).

## 3. Recuperación / Estado Operativo
- El esquema no requiere convergencia post-falla; opera de manera permanente en balanceo activo-activo mientras ambos nodos de distribución permanezcan saludables.

## 4. Tiempo medido
- **Latencia media en salto 1:** 0.99 ms a 2.68 ms en PC-USER; 1.19 ms a 2.85 ms en SRV.
- **Pérdida de paquetes:** 0% packet loss bajo tráfico concurrente.

## 5. Post-mortem
- **¿Por qué funcionó?:** El uso de dos VRIDs independientes con prioridades invertidas sobre el mismo medio físico permite dividir el dominio de broadcast y asignar gateways por defecto independientes según la VLAN/subred, aprovechando el 100% del ancho de banda disponible hacia el Core.
- **Lección aprendida:** El diseño de primer salto debe evitar el esquema Active-Standby clásico en capas de agregación; el reparto simétrico optimiza el uso de CPU y enlaces de subida en ambos routers de distribución.