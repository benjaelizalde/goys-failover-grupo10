# Drill 3: Failover de Proveedor eBGP (Corte WAN ISP-1)

## 1. Detección

- **Alerta / Síntoma:** Caída del enlace WAN principal hacia ISP-1 (`192.0.2.0/30` en `ether1` de EDGE).
- **Herramienta de verificación:**
  - Monitoreo continuo mediante ping desde PC-USER a destinos en Internet.
  - Verificación de sesiones en EDGE con `/routing bgp session print`.
  - Inspección del gateway activo por defecto con `/ip route print where dst-address=0.0.0.0/0`.

## 2. Respuesta

- **Inyección de falla:** Deshabilitación de la interfaz `ether1` en EDGE (`/interface ethernet disable [find name=ether1]`).
- **Comportamiento observado:**
  - La sesión eBGP con ISP-1 (`to-ISP1`) se interrumpe y la ruta por defecto aprendida pasa a estado Inactivo (`DIb`).
  - BGP desempata hacia la ruta por defecto alternativa anunciada por ISP-2 (`to-ISP2`), instalándola como activa (`DAb`) vía `192.0.2.5%ether2`.
  - El tráfico saliente de las LANs (PC-USER) se redirige automáticamente hacia el enlace WAN de ISP-2 sin intervención manual.

## 3. Recuperación (Failback)

- **Acción:** Rehabilitación de la interfaz `ether1` en EDGE (`/interface ethernet enable [find name=ether1]`).
- **Resultado:**
  - EDGE vuelve a incorporar la ruta por defecto de ISP-1 a la tabla de enrutamiento principal.

## 4. Tiempo medido

- **Pérdida de paquetes en host:** Conmutación automática de la ruta por defecto en EDGE. Tráfico continuo hacia destinos de respaldo (ISP-2) con 0% de pérdida y latencia promedio de 4.0 ms.
- **Tiempo de convergencia de ruta:** Inmediato ante Link Down de la interfaz WAN.

## 5. Post-mortem

- **¿Por qué funcionó?:** La arquitectura dual-homing con eBGP y recepción simultánea de default-originate desde ambos ISPs garantiza redundancia completa de salida a Internet. La caída de la interfaz física fuerza el retiro inmediato del prefijo en la FIB sin esperar el vencimiento del hold-timer.
- **Lección aprendida:** Mantener sesiones eBGP independientes con políticas de entrada simétricas permite que el desempate automático de BGP mantenga la conectividad externa de la empresa ante la falla de un proveedor.