# Drill 2: Failover de Camino Interno OSPF

## 1. Detección
- **Alerta / Síntoma:** Pérdida de conectividad física en el enlace de tránsito primario entre EDGE y CORE-1 (`10.0.0.0/30`).
- **Herramienta de verificación:** 
  - Ping continuo desde PC-USER hacia la loopback de ISP-1 (`198.51.100.1`).
  - Monitoreo de vecinos en EDGE con `/routing ospf neighbor print`.
  - Inspección de tabla de ruteo en CORE-1 con `/ip route print where dst-address=0.0.0.0/0`.

## 2. Respuesta
- **Inyección de falla:** Deshabilitación de la interfaz `ether3` en EDGE (`/interface ethernet disable ether3`).
- **Comportamiento observado:**
  - La adyacencia OSPF entre EDGE y CORE-1 se interrumpe de inmediato por Link Down.
  - El algoritmo Dijkstra (SPF) recalcula la topología del Área 0.
  - CORE-1 actualiza su gateway por defecto (`0.0.0.0/0`) redirigiendo el tráfico hacia CORE-2 (`10.0.0.10`) a través del enlace dedicado `core-core` (`ether2`).
  - EDGE ajusta sus rutas hacia las subredes de usuarios (`192.168.10.0/24`) y servidores (`192.168.20.0/24`) reenviando exclusivamente a través de CORE-2 (`10.0.0.6%ether4`).

## 3. Recuperación (Failback)
- **Acción:** Rehabilitación de la interfaz `ether3` en EDGE (`/interface ethernet enable ether3`).
- **Resultado:**
  - Se restablece la adyacencia OSPF en estado `Full` entre EDGE y CORE-1 (`10.0.0.2%ether3`).
  - CORE-1 vuelve a instalar la ruta por defecto directa por `ether1` (`10.0.0.1`).
  - EDGE reinstala el balanceo de carga ECMP (`DAo+`) repartiendo el costo interno equitativamente entre CORE-1 y CORE-2.

## 4. Tiempo medido
- **Pérdida de paquetes en host:** 1 paquete perdido (secuencia 8 omitida; pico transitorio de 12.57 ms en secuencia 7).
- **Tiempo total de convergencia:** ~1 segundo.

## 5. Post-mortem
- **¿Por qué funcionó?:** La inclusión del enlace directo `CORE-1 ↔ CORE-2` (corrección del defecto 3 de F0) evitó el aislamiento de la capa de Core ante la pérdida del enlace vertical con EDGE. OSPF redirigió los paquetes por el camino redundante sin bucles de ruteo.
- **Lección aprendida:** La adyacencia punto a punto sobre interfaces Ethernet conmuta de forma casi instantánea ante un evento de interfaz física caída (carrier loss), limitando la pérdida de tráfico al tiempo que toma el cálculo de SPF.