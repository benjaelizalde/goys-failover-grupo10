# Drill 1: Failover de Gateway VRRP

## 1. Detección
- **Alerta / Síntoma:** El gateway activo de la red USERS (DIST-1, VRID 10) deja de enviar anuncios VRRP por caída de nodo o interfaz.
- **Herramienta de verificación:** Monitoreo continuo mediante ping desde PC-USER hacia Internet (`198.51.100.1`) y verificación de estados con `/interface vrrp print` en los routers de distribución.

## 2. Respuesta
- **Inyección de falla:** Deshabilitación de la interfaz VRID 10 en DIST-1 (`/interface vrrp disable [find vrid=10]`).
- **Comportamiento observado:**
  - Al vencerse el intervalo de caída (3 * Advertisement_Interval + Skew_Time), DIST-2 detecta la ausencia del Master.
  - DIST-2 promueve el VRID 10 de estado Backup (`B`) a Running Master (`RM`).
  - DIST-2 emite un gratuitous ARP actualizando la tabla CAM de los switches para asociar la MAC virtual `00:00:5E:00:01:0A` a su puerto.

## 3. Recuperación (Failback)
- **Acción:** Rehabilitación de la interfaz VRID 10 en DIST-1 (`/interface vrrp enable [find vrid=10]`).
- **Resultado:** DIST-1 retoma la condición de Running Master (`RM`) de forma automática por preemption debido a su mayor prioridad (200 contra 100 de DIST-2). DIST-2 retorna a estado Backup (`B`).

## 4. Tiempo medido
- **Pérdida de paquetes en host:** 1 paquete perdido (secuencia 13 omitida en ping continuo de 1s).
- **Tiempo total de convergencia:** ~1 segundo.

## 5. Post-mortem
- **¿Por qué funcionó?:** El protocolo VRRP v2 operó de acuerdo al estándar RFC 5798. El mecanismo de preemption y la prioridad diferenciada permitieron una conmutación simétrica y no disruptiva.
- **Lección aprendida:** Mantener autenticación simple compartida y temporizadores consistentes de 1s garantiza una transición de gateway transparente para las estaciones de trabajo.