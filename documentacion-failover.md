# Memoria del Laboratorio — Failover Routing

> Plantilla de documentación. Completar **todos** los campos. Los bloques entre `<!-- -->` son instrucciones (se borran al entregar).

**Grupo:** Grupo 10
**Materia:** Gestión Operativa y Seguridad en Redes (GOYS)
**Fecha de entrega:** 

## Integrantes y roles


| Integrante | Rol                         |
| ---------- | --------------------------- |
|            | R1 — Líder / Edge-WAN       |
|            | R2 — Proveedores            |
|            | R3 — Core                   |
|            | R4 — Distribución           |
|            | R5 — Hosts / QA / Operación |


---



## 1. Diseño (F0)



### 1.1 Corrección del diagrama

> Del diagrama "Enterprise Network Design (Cisco)", indiquen qué defectos corrigieron y justifiquen cada corrección.


| #   | Defecto detectado | Corrección aplicada | Justificación |
| --- | ----------------- | ------------------- | ------------- |
| 1   |                   |                     |               |
| 2   |                   |                     |               |
| 3   |                   |                     |               |




### 1.2 Plan de direccionamiento (IPAM)

> Completar. Regla: **cero solapamiento** — cada enlace un /30 distinto, cada LAN un /24 distinto.


| Enlace / Red                | Subred | Dispositivo A (IP/iface) | Dispositivo B (IP/iface) |
| --------------------------- | ------ | ------------------------ | ------------------------ |
| ISP-1 ↔ EDGE                |        |                          |                          |
| ISP-2 ↔ EDGE                |        |                          |                          |
| EDGE ↔ CORE-1               |        |                          |                          |
| EDGE ↔ CORE-2               |        |                          |                          |
| CORE-1 ↔ CORE-2 (core-core) |        |                          |                          |
| CORE ↔ DIST-1 (×2)          |        |                          |                          |
| CORE ↔ DIST-2 (×2)          |        |                          |                          |
| USERS (gateway VRRP)        |        |                          |                          |
| SERVERS (gateway VRRP)      |        |                          |                          |


**VRRP:**


| Grupo   | VRID | Master | Priority | IP virtual |
| ------- | ---- | ------ | -------- | ---------- |
| USERS   |      |        |          |            |
| SERVERS |      |        |          |            |


**Router-IDs:** 

### 1.3 Política de seguridad

- **Usuarios y privilegios:** 
- **Servicios que se deshabilitan:** 
- **Claves de autenticación** (OSPF / BGP / VRRP):



### 1.4 Política de operación

- **Formato del change log** (convención de commits): 
- **Política de backup** (cuándo y cómo):

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

- [ ] IPAM completo y sin solapamiento
- [ ] Corrección del diagrama justificada (≥ 3 defectos)
- [ ] Política de seguridad definida (usuarios, servicios, claves)
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