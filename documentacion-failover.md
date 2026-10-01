# Memoria del Laboratorio — Failover Routing

> Plantilla de documentación. Completar **todos** los campos. Los bloques entre `<!-- -->` son instrucciones (se borran al entregar).

**Grupo:** Grupo 10
**Materia:** Gestión Operativa y Seguridad en Redes (GOYS)
**Fecha de entrega:** 

## Integrantes y roles


| Integrante         | Rol                         |
| ------------------ | --------------------------- |
| Alvite Damian      | R1 — Líder / Edge-WAN       |
| Capre Rodrigo      | R2 — Proveedores            |
| Di Grappa Emiliano | R3 — Core                   |
| Moscuzza Vicente   | R4 — Distribución           |
| Elizalde Benjamin  | R5 — Hosts / QA / Operación |


---



## 1. Diseño (F0)



### 1.1 Corrección del diagrama

> Del diagrama "Enterprise Network Design (Cisco)", indiquen qué defectos corrigieron y justifiquen cada corrección.


| #   | Defecto detectado                              | Corrección aplicada                                                                                                                                          | Justificación                                                                                                                                                                                  |
| --- | ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | Firewall sin par de Alta Disponibilidad (SPOF) | En el laboratorio el filtrado perimetral vive en el router EDGE. En entornos de producción deben implementarse dos appliances en esquema activo/standby      | Un único firewall representa un punto único de falla (SPOF): ante una caída del equipo se interrumpe toda la salida a Internet, inutilizando la redundancia provista por los dos ISP           |
| 2   | Subredes solapadas entre sitios                | Plan IPAM con un /30 por cada enlace punto a punto y un /24 por LAN, garantizando cero solapamiento                                                          | El solapamiento genera ambigüedades en la tabla de ruteo global e impide cualquier interconexión o enrutamiento futuro entre sitios                                                            |
| 3   | Falta de enlace directo core–core              | Se incorpora el enlace directo CORE-1 <-> CORE-2 dentro del área 0 de OSPF                                                                                   | Si cae un enlace entre el Core y la Distribución, la red queda sin camino óptimo interno; el enlace core–core evita aislamiento y previene desvíos asimétricos o caídas de tránsito            |
| 4   | HSRP en el Core                                | Se reubica el protocolo de primer salto (FHRP) en la capa de Distribución implementando el estándar abierto VRRP, dejando el Core como tránsito puro de OSPF | Separa las funciones de la red: el Core solo transporta paquetes a alta velocidad, mientras que el gateway por defecto debe estar próximo al segmento de acceso de los usuarios y servidores   |
| 5   | iBGP Route Reflector mal ubicado               | Se elimina el Route Reflector y se configuran sesiones eBGP directas en EDGE con cada ISP                                                                    | Con un único router de borde y dos proveedores WAN no se requiere una malla interna compleja de iBGP ni reflectores cruzando firewalls; eBGP directo en el borde simplifica el plano de contro |




### 1.2 Plan de direccionamiento (IPAM)

> Completar. Regla: **cero solapamiento** — cada enlace un /30 distinto, cada LAN un /24 distinto.


| Enlace / Red                | Subred          | Dispositivo A (IP/iface)         | Dispositivo B (IP/iface)         |
| --------------------------- | --------------- | -------------------------------- | -------------------------------- |
| ISP-1 ↔ EDGE                | 192.0.2.0/30    | ISP-1: 192.0.2.1/30 (ether2)     | EDGE: 192.0.2.2/30 (ether1)      |
| ISP-2 ↔ EDGE                | 192.0.2.4/30    | ISP-2: 192.0.2.5/30 (ether2)     | EDGE: 192.0.2.6/30 (ether2)      |
| EDGE ↔ CORE-1               | 10.0.0.0/30     | EDGE: 10.0.0.1/30 (ether3)       | CORE-1: 10.0.0.2/30 (ether1)     |
| EDGE ↔ CORE-2               | 10.0.0.4/30     | EDGE: 10.0.0.5/30 (ether4)       | CORE-2: 10.0.0.6/30 (ether1)     |
| CORE-1 ↔ CORE-2 (core-core) | 10.0.0.8/30     | CORE-1: 10.0.0.9/30 (ether2)     | CORE-2: 10.0.0.10/30 (ether2)    |
| CORE 1 ↔ DIST-1 (enlace 1)  | 10.0.0.12/30    | CORE-1: 10.0.0.13/30 (ether3)    | DIST-1: 10.0.0.14/30 (ether1)    |
| CORE 2 ↔ DIST-1 (enlace 2)  | 10.0.0.20/30    | CORE-2: 10.0.0.21/30 (ether3)    | DIST-1: 10.0.0.22/30 (ether2)    |
| CORE 1 ↔ DIST-2 (enlace 1)  | 10.0.0.16/30    | CORE-1: 10.0.0.17/30 (ether4)    | DIST-2: 10.0.0.18/30 (ether1)    |
| CORE 2 ↔ DIST-2 (enlace 2)  | 10.0.0.24/30    | CORE-2: 10.0.0.25/30 (ether4)    | DIST-2: 10.0.0.26/30 (ether2)    |
| USERS (gateway VRRP)        | 192.168.10.0/24 | DIST-1: 192.168.10.2/24 (ether3) | DIST-2: 192.168.10.3/24 (ether3) |
| SERVERS (gateway VRRP)      | 192.168.20.0/24 | DIST-1: 192.168.20.2/24 (ether4) | DIST-2: 192.168.20.3/24 (ether4) |


**VRRP:**


| Grupo   | VRID | Master | Priority                      | IP virtual   |
| ------- | ---- | ------ | ----------------------------- | ------------ |
| USERS   | 10   | DIST-1 | 200 (Backup: DIST-2 prio 100) | 192.168.10.1 |
| SERVERS | 20   | DIST-2 | 200 (Backup: DIST-1 prio 100) | 192.168.20.1 |


**Router-IDs:** 

- **ISP-1:** 198.51.100.1 (AS 65001)
- **ISP-2:** 198.51.100.2 (AS 65002)
- **EDGE:** 10.255.0.1 (AS 65000)
- **CORE-1:** 10.255.0.11
- **CORE-2:** 10.255.0.12
- **DIST-1:** 10.255.0.21
- **DIST-2:** 10.255.0.22



### 1.3 Política de seguridad

- **Usuarios y privilegios:** 
  - Usuario admin: Contraseña por defecto modificada en los 7 routers por una credencial robusta; acceso exclusivo para tareas de configuración de cada rol asignado.
  - Usuario monitor: Grupo de permisos: read, creado exclusivamente para observabilidad, SNMP y tareas de testing de QA.
  - Restricción de acceso de administración exclusivamente por protocolo SSH, limitando el origen a las IPs de gestión/loopbacks internas.
- **Servicios que se deshabilitan:** 
  - Deshabilitar en los 7 MikroTik CHR: telnet, ftp, www (HTTP), api, api-ssl y servidor bandwidth-test.
  - Desactivar descubrimiento de vecinos (/ip neighbor discovery-settings) y MAC-Server hacia las interfaces que interconectan con el exterior (enlaces a los ISP).
- **Claves de autenticación** (OSPF / BGP / VRRP):
  - **OSPF:** Autenticación criptográfica MD5 (key-id=1) en todas las interfaces del Área 0 (EDGE, CORE-1, CORE-2, DIST-1, DIST-2).
  - **BGP:** TCP-MD5 implementado de forma independiente con secretos únicos para cada sesión (EDGE ↔ ISP-1 y EDGE ↔ ISP-2).
  - **VRRP:** Autenticación simple activada sobre VRRP v2 para los grupos VRID 10 y VRID 20.
  - Regla de seguridad: Las contraseñas reales se manejan por un canal privado seguro del grupo, y en el repositorio y la memoria se documentan por ejemplo como KEY_OSPF_MD5, etc.



### 1.4 Política de operación

- **Formato del change log** (convención de commits):
  - Se adopta el estándar **Conventional Commits**: (): (): <descripción breve>.
  - **Tipos permitidos:** feat (nueva configuración o protocolo), fix (corrección técnica), docs (documentación y memoria), ops (backlogs, backups y change log), chore (mantenimiento de carpetas o repo).
- **Política de backup** (cuándo y cómo):
  - **Cuándo:** Obligatoriamente antes de realizar cambios estructurales, antes de iniciar cada drill de failover en F4, y al cierre formal de cada hito (F1, F2, F3, F4).
  - **Cómo:**
    1. Respaldo en texto plano: /export file=nombre_router-fecha-fase (se guarda y versiona en git dentro de la carpeta backups/fecha/).
    2. Respaldo binario: /system backup save name=nombre_router-fecha-fase (se almacena localmente en el router o almacenamiento local del simulador, sin subirlo al repositorio).

---



## 2. Topología

> Pegar acá la captura del proyecto GNS3 (o el diagrama) con las 5 capas identificadas.

```
[INTERNET] [EDGE] [CORE] [DISTRIBUTION] [ACCESS]
<!-- insertar diagrama/captura -->
```

---



## 3. Configuración

> Un bloque por dispositivo. Se puede referenciar el archivo `.rsc` del repo y pegar el contenido final.



### 3.1 ISP-1

```routeros
<!-- config final -->
```



### 3.2 ISP-2

```routeros
<!-- config final -->
```



### 3.3 EDGE

```routeros
<!-- config final -->
```



### 3.4 CORE-1

```routeros
<!-- config final -->
```



### 3.5 CORE-2

```routeros
<!-- config final -->
```



### 3.6 DIST-1

```routeros
<!-- config final -->
```



### 3.7 DIST-2

```routeros
<!-- config final -->
```



### 3.8 Hosts (PC-USER / SRV)

```bash
<!-- config final de los hosts -->
```

---



## 4. Verificación



### 4.1 Conectividad básica


| Prueba                         | Comando | Resultado |
| ------------------------------ | ------- | --------- |
| ping intra-LAN (PC-USER ↔ SRV) |         |           |
| traceroute a ISP (loopback)    |         |           |


> Pegar capturas de las tablas: `/routing/route/print`, `/interface/vrrp/print`, `/routing/bgp/session/print`.



### 4.2 Los 5 drills de failover

> Para cada drill, documentar con la estructura **detección → respuesta → recuperación → post-mortem** y el **tiempo medido**.



#### Drill 1 — VRRP: se cae el gateway

- **Detección:** 
- **Respuesta:** 
- **Recuperación:** 
- **Tiempo medido:** 
- **Post-mortem** (¿por qué funcionó? ¿qué aprendieron?):



#### Drill 2 — OSPF: se corta el camino interno

- **Detección:** 
- **Respuesta:** 
- **Recuperación:** 
- **Tiempo medido:** 
- **Post-mortem:**



#### Drill 3 — BGP: se cae el proveedor

- **Detección:** 
- **Respuesta:** 
- **Recuperación:** 
- **Tiempo medido:** 
- **Post-mortem:**



#### Drill 4 — check-gateway: failover estático de enlace

- **Detección:** 
- **Respuesta:** 
- **Recuperación:** 
- **Tiempo medido:** 
- **Post-mortem:**



#### Drill 5 — Load-sharing VRRP: ambos DIST activos

- **Detección:** 
- **Respuesta:** 
- **Recuperación:** 
- **Post-mortem:**

---



## 5. Seguridad aplicada


| Mecanismo                      | Dónde se aplicó | Verificación (¿cómo probaron que funciona?) |
| ------------------------------ | --------------- | ------------------------------------------- |
| Hardening (usuarios/servicios) |                 |                                             |
| OSPF MD5                       |                 |                                             |
| BGP TCP-MD5                    |                 |                                             |
| VRRP auth                      |                 |                                             |
| Firewall/ACL (edge)            |                 |                                             |


> Prueba de seguridad obligatoria: adyacencia OSPF / sesión BGP debe **fallar** con clave incorrecta. Documentar el resultado.

---



## 6. Gestión operativa



### 6.1 Change log


| Fecha | Responsable | Cambio | Motivo | Cómo se revierte |
| ----- | ----------- | ------ | ------ | ---------------- |
|       |             |        |        |                  |




### 6.2 Backups

> Evidencia de backup (`/export` + `/system backup save`) y de **restore probado**.



### 6.3 Monitoreo

> Qué se monitorea (enlaces, vecinos OSPF, sesiones BGP, VRRP) y con qué (SNMP, chequeos).

---



## 7. Capturas

> Listar o enlazar la carpeta de capturas (drills, tablas, failover).

---



## 8. Conclusiones y lecciones aprendidas

> Post-mortem global: qué salió bien, qué fue difícil, qué harían distinto.

---



## 9. Referencias

> Lecturas y videos efectivamente consultados.

- 

- 

---



## 10. Checklist de entrega

> Marcar **todo** antes de entregar. Si algo no está, el lab no está completo.



### Diseño (F0)

- [x] IPAM completo y sin solapamiento
- [x] Corrección del diagrama justificada (≥ 3 defectos)
- [x] Política de seguridad definida (usuarios, servicios, claves)
- [ ] Política de operación definida (change log + backup)



### Redes

- [ ] 7 CHR + 2 switches + 2 hosts levantados y cableados
- [ ] VRRP operativo (2 grupos, load-sharing)
- [ ] OSPF área 0 con adyacencias (incluido core–core)
- [ ] BGP eBGP ×2 establecido (multi-homing)
- [ ] Los 5 drills ejecutados y documentados (runbook + post-mortem + tiempo)



### Seguridad

- [ ] Hardening aplicado (password, usuario mínimo, servicios apagados)
- [ ] OSPF MD5 funcionando
- [ ] BGP TCP-MD5 funcionando
- [ ] VRRP auth funcionando
- [ ] Firewall edge aplicado
- [ ] Prueba con clave incorrecta → debe **fallar** (documentado)



### Operación

- [ ] Change log completo (refleja los commits del repo)
- [ ] Backups con restore probado
- [ ] Monitoreo habilitado y documentado
- [ ] Runbook por drill + post-mortem global