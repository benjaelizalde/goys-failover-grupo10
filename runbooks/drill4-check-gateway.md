# Drill 4: Failover de Enlace Estático con Check-Gateway

## 1. Detección
- **Alerta / Síntoma:** Falta de respuesta ICMP en el gateway primario hacia Internet sin pérdida física de portadora (falla lógica del carrier upstream).
- **Herramienta de verificación:**
  - Inspección del estado de rutas en EDGE mediante `/ip route print where comment~"ISP"`.
  - Monitoreo de latencia y pérdida de paquetes desde PC-USER hacia destinos públicos.

## 2. Respuesta
- **Mecanismo configurado:**
  - Ruta primaria: `198.51.100.0/24` vía `192.0.2.1` con `check-gateway=ping` y `distance=1`.
  - Ruta flotante de respaldo: `198.51.100.0/24` vía `192.0.2.5` con `distance=2`.
- **Inyección de falla:** Deshabilitación de la IP de enlace en ISP-1 (`/ip address disable [find address~"192.0.2.1"]`).
- **Comportamiento observado:**
  - Tras fallar los pings periódicos de control, EDGE marca la ruta primaria como Inactiva (`Is`).
  - La ruta flotante de respaldo asciende a estado Activo (`As`), redirigiendo el tráfico saliente por la interfaz de ISP-2.

## 3. Recuperación (Failback)
- **Acción:** Rehabilitación de la IP en ISP-1 (`/ip address enable [find address~"192.0.2.1"]`).
- **Resultado:** EDGE vuelve a recibir respuesta de ping en el gateway primario y restablece la ruta de menor distancia administrativa (`distance=1`) con bandera `As`, devolviendo la ruta de respaldo a estado inactivo (`s`).

## 4. Tiempo medido
- **Tiempo de detección / conmutación:** ~20 segundos (2 pings de control fallidos según el intervalo estándar de RouterOS).
- **Pérdida de paquetes en host:** 0% packet loss durante la prueba hacia destinos alcanzables por el enlace alternativo (latencia media de 4.64 ms).

## 5. Post-mortem
- **¿Por qué funcionó?:** La combinación de `check-gateway=ping` con distancias administrativas diferenciadas permite detectar fallas de Capa 3 transparentes para la Capa 2 (enlaces donde el puerto Ethernet sigue arriba pero el gateway intermedio no enruta).
- **Lección aprendida:** El tiempo de conmutación de este mecanismo depende del temporizador de sondeo de ICMP (~20s), por lo que es más lento que una caída de enlace físico o BFD, pero resulta indispensable para gateways estáticos o enlaces sin protocolos de enrutamiento dinámico.