# Backlog — Laboratorio Failover Routing

> **Grupo:** Grupo 10 · **Vencimiento final:** vie 23/10

## Leyenda de estado

- `[ ]` pendiente · `[~]` en curso · `[x]` hecho
- Cada tarea lleva **dueño** (rol): `[R1]` … `[R5]`.
- **"Hecho" = criterio de aceptación cumplido** (ver spec, sección 6). No "más o menos".

**Roles:** R1 Alvite Damian (Líder / Edge-WAN) · R2 Capre Rodrigo (Proveedores) · R3 Di Grappa Emiliano (Core) · R4 Moscuzza Vicente (Distribución) · R5 Elizalde Benjamin (Hosts / QA / Ops)

---

## Epic F0 — Diseño y gestión de cambio · *vence vie 2/10*

### IPAM / direccionamiento

- [x] [R1] definir /30 de enlaces ISP-1↔EDGE, ISP-2↔EDGE y EDGE↔CORE-1/2
- [x] [R3] definir /30 de core-core y de los 4 enlaces CORE↔DIST
- [x] [R4] definir LANs USERS/SERVERS (/24) y tabla VRRP (VRID, prioridades, IP virtual)
- [x] [R5] definir router-ids y verificar cero solapamiento en toda la tabla



### Corrección del diagrama (≥ 3 defectos)

- [x] [R1] documentar defectos 1 (firewall SPOF) y 5 (iBGP RR) con corrección y justificación
- [x] [R2] documentar defecto 2 (subredes solapadas)
- [x] [R3] documentar defecto 3 (falta core–core)
- [x] [R4] documentar defecto 4 (HSRP en core → VRRP en distribución)



### Política de seguridad

- [x] [R5] definir usuarios y privilegios (admin robusto + `monitor` read)
- [x] [R2] definir servicios a deshabilitar y neighbor discovery/MAC-server hacia ISP
- [x] [R1] definir esquema de claves OSPF MD5 / BGP TCP-MD5 / VRRP auth y canal privado de secretos



### Política de operación (change log + backup)

- [x] [R5] definir formato de change log (Conventional Commits)
- [x] [R5] definir política de backup (cuándo y cómo)



### Repositorio git

- [x] [R5] crear repo `goys-failover-grupo10` con estructura (README, backlog.md, docs/, configs/, backups/, runbooks/, capturas/)
- [x] [R1] escribir README (integrantes, roles, resumen) y dar acceso al docente
- [x] [R5] subir `backlog.md` y `docs/memoria.md` (memoria F0 completa)
- [x] [R1–R5] un commit inicial por integrante (trazabilidad por autor)
- [x] [R1] enviar F0 al docente y obtener aprobación (gate: sin esto no se toca un nodo)

---



## Epic F1 — Topología + hardening + backup · *vence vie 9/10*



### Despliegue (7 CHR + 2 switches + 2 hosts)

- [x] [R5] importar proyecto GNS3 `topologia_failover_routing` y levantar los 11 nodos
- [x] [R5] verificar cableado y nombres de interfaces contra el IPAM
- [x] [R1] capturar topología con las 5 capas identificadas (`docs/diagramas/`)



### IPs de enlace + loopbacks

- [x] [R1] IPs y loopback en EDGE
- [x] [R2] IPs y loopback en ISP-1 e ISP-2
- [x] [R3] IPs y loopback en CORE-1 y CORE-2
- [x] [R4] IPs y loopback en DIST-1 y DIST-2
- [x] [R5] IPs de hosts y ping entre vecinos directos OK



### Snapshot BASE

- [x] [R5] tomar snapshot BASE de todos los nodos
- [x] [R5] documentar el snapshot en la memoria y en el change log



### Hardening (los 7 routers)

- [x] [R1] hardening de EDGE
- [x] [R2] hardening de ISP-1 e ISP-2
- [x] [R3] hardening de CORE-1 y CORE-2
- [x] [R4] hardening de DIST-1 y DIST-2
- [x] [R5] verificar en los 7: password cambiado, usuario `monitor`, servicios apagados



### Backup inicial (`/export`)

- [x] [R5] `/export` de los 7 routers a `backups/<fecha>/` (Cada uno subio sus respectivos .rsc)
- [x] [R5] commit `ops(backup): backup post-F1`

---



## Epic F2 — VRRP + OSPF · *vence vie 16/10*



### VRRP (2 grupos, load-sharing, auth)

- [ ] [R4] configurar VRRP vrid 10 en DIST-1 (master)
- [ ] [R4] configurar VRRP vrid 20 en DIST-2 (master)
- [ ] [R4] activar auth simple en ambos grupos
- [ ] [R5] verificar master/backup con `/interface vrrp print`



### OSPF área 0 (con MD5, incluido core–core)

- [ ] [R3] OSPF + MD5 en CORE-1 y CORE-2 (incluido enlace core–core)
- [ ] [R4] OSPF + MD5 en DIST-1 y DIST-2
- [ ] [R1] OSPF + MD5 en EDGE (hacia CORE-1/2)
- [ ] [R5] verificar adyacencias FULL con `/routing/ospf/neighbor print`



### Verificación L3 (ping intra-LAN + gateway virtual)

- [ ] [R5] ping PC-USER ↔ SRV
- [ ] [R5] ping al gateway virtual de cada LAN
- [ ] [R5] backup post-F2 y registro en change log

---



## Epic F3 — BGP + firewall · *vence vie 16/10*



### eBGP multi-homing (2 sesiones, TCP-MD5)

- [ ] [R1] sesión eBGP EDGE↔ISP-1 con TCP-MD5
- [ ] [R1] sesión eBGP EDGE↔ISP-2 con TCP-MD5
- [ ] [R2] sesión eBGP + default-originate en ISP-1 e ISP-2
- [ ] [R5] verificar ambas sesiones established



### Redistribución OSPF→BGP

- [ ] [R1] redistribuir OSPF→BGP en EDGE
- [ ] [R2] verificar que ISP-1 e ISP-2 reciben las LANs
- [ ] [R5] verificar default recibida por OSPF en core/dist



### Salida a "Internet" (host → loopback ISP)

- [ ] [R5] ping y traceroute desde PC-USER al loopback de ISP-1 e ISP-2
- [ ] [R5] documentar resultado en memoria 4.1



### Firewall edge (filtro + plano de gestión)

- [ ] [R1] reglas input: permitir established/related, OSPF, BGP, VRRP y SSH desde gestión; drop resto
- [ ] [R1] reglas forward: filtro de entrada desde ISP
- [ ] [R5] probar que el filtro bloquea lo no permitido (SSH desde ISP, etc.)

---



## Epic F4 — Drills + monitoreo · *vence mar 20/10*



### Los 5 drills (runbook + post-mortem + tiempo)

- [ ] [R5] backup previo a cada drill
- [ ] [R5] drill 1 — VRRP: runbook, tiempo, post-mortem
- [ ] [R5] drill 2 — OSPF: runbook, tiempo, post-mortem
- [ ] [R5] drill 3 — BGP: runbook, tiempo, post-mortem
- [ ] [R5] drill 4 — check-gateway: runbook, tiempo, post-mortem
- [ ] [R5] drill 5 — load-sharing VRRP: runbook, post-mortem
- [ ] [R1–R4] rotación R1↔R2: ejecutar un drill intercambiando roles



### Monitoreo (SNMP/chequeos)

- [ ] [R5] habilitar SNMP con usuario `monitor` en los 7 routers
- [ ] [R5] definir y documentar qué se monitorea (enlaces, OSPF, BGP, VRRP)



### Verificación de seguridad (clave incorrecta falla)

- [ ] [R3] clave OSPF incorrecta → adyacencia cae (captura)
- [ ] [R1] clave BGP incorrecta → sesión no establece (captura)
- [ ] [R4] clave VRRP incorrecta → documentar resultado
- [ ] [R5] restaurar claves correctas y registrar en change log

---



## Epic F5 — Memoria + defensa · *vence vie 23/10*



### Memoria (plantilla completa)

- [ ] [R1–R5] cada rol completa su sección de configuración (3.x)
- [ ] [R5] completar secciones 4, 5, 6, 7 y 8 con capturas
- [ ] [R5] change log (6.1) alineado con los commits del repo
- [ ] [R5] borrar bloques `<!-- -->` y completar fecha y referencias



### Backlog cerrado (todo en "hecho")

- [ ] [R5] revisar que cada tarea cumpla su criterio de aceptación
- [ ] [R5] checklist de entrega 100% marcado



### Defensa oral (parte propia + ajena)

- [ ] [R1–R5] cada integrante prepara su parte
- [ ] [R1–R5] cada integrante estudia una parte ajena (cruzar roles)
- [ ] [R1–R5] ensayo de defensa