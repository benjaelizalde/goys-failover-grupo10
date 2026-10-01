# Backlog — Laboratorio Failover Routing

> Copiar este archivo a `backlog.md` en el repo del grupo y completar.
> **Grupo:** <!-- número/nombre --> · **Vencimiento final:** vie 23/10

## Leyenda de estado

- `[ ]` pendiente · `[~]` en curso · `[x]` hecho
- Cada tarea lleva **dueño** (rol): `[R1]` … `[R5]`.
- **"Hecho" = criterio de aceptación cumplido** (ver spec, sección 6). No "más o menos".

---

## Epic F0 — Diseño y gestión de cambio · *vence vie 2/10*

### IPAM / direccionamiento
- [ ] <!-- [R#] tarea -->

### Corrección del diagrama (≥ 3 defectos)
- [ ] <!-- [R#] tarea -->

### Política de seguridad
- [ ] <!-- [R#] tarea -->

### Política de operación (change log + backup)
- [ ] <!-- [R#] tarea -->

### Repositorio git
- [ ] <!-- [R#] tarea -->

---

## Epic F1 — Topología + hardening + backup · *vence vie 9/10*

### Despliegue (7 CHR + 2 switches + 2 hosts)
- [ ] <!-- [R#] tarea -->

### IPs de enlace + loopbacks
- [ ] <!-- [R#] tarea -->

### Snapshot BASE
- [ ] <!-- [R#] tarea -->

### Hardening (los 7 routers)
- [ ] <!-- [R#] tarea -->

### Backup inicial (`/export`)
- [ ] <!-- [R#] tarea -->

---

## Epic F2 — VRRP + OSPF · *vence vie 16/10*

### VRRP (2 grupos, load-sharing, auth)
- [ ] [R4] configurar VRRP vrid 10 en DIST-1 (master)
- [ ] [R4] configurar VRRP vrid 20 en DIST-2 (master)
- [ ] [R4] activar auth simple en ambos grupos
- [ ] [R5] verificar master/backup con `/interface vrrp print`

### OSPF área 0 (con MD5, incluido core–core)
- [ ] <!-- [R#] tarea -->

### Verificación L3 (ping intra-LAN + gateway virtual)
- [ ] <!-- [R#] tarea -->

---

## Epic F3 — BGP + firewall · *vence vie 16/10*

### eBGP multi-homing (2 sesiones, TCP-MD5)
- [ ] <!-- [R#] tarea -->

### Redistribución OSPF→BGP
- [ ] <!-- [R#] tarea -->

### Salida a "Internet" (host → loopback ISP)
- [ ] <!-- [R#] tarea -->

### Firewall edge (filtro + plano de gestión)
- [ ] <!-- [R#] tarea -->

---

## Epic F4 — Drills + monitoreo · *vence mar 20/10*

### Los 5 drills (runbook + post-mortem + tiempo)
- [ ] <!-- [R#] tarea -->

### Monitoreo (SNMP/chequeos)
- [ ] <!-- [R#] tarea -->

### Verificación de seguridad (clave incorrecta falla)
- [ ] <!-- [R#] tarea -->

---

## Epic F5 — Memoria + defensa · *vence vie 23/10*

### Memoria (plantilla completa)
- [ ] <!-- [R#] tarea -->

### Backlog cerrado (todo en "hecho")
- [ ] <!-- [R#] tarea -->

### Defensa oral (parte propia + ajena)
- [ ] <!-- [R#] tarea -->
