Usar estos nombres exactos en el código de cada rama para que todo funcione al unir el proyecto, sin usar ninguna tabla de la base de datos ventas: Base de datos: `BanreservasDB`

1. `Cuentahabientes` (`CuentahabienteId` INT PK, `Cedula` VARCHAR(11) UNIQUE, `Nombres` VARCHAR(100), `Apellidos` VARCHAR(100), `Telefono` VARCHAR(15), `EstatusActivo` BIT)

2. `ExpedientesKYC` (`ExpedienteId` INT PK, `CuentahabienteId` INT UNIQUE FK, `NivelRiesgo` VARCHAR(20), `IngresoMensualEstimado` DECIMAL(18,2), `FechaVerificacion` DATETIME)

3. `SucursalesBancarias` (`SucursalId` INT PK, `CodigoOficina` VARCHAR(10) UNIQUE, `NombreOficina` VARCHAR(100), `Provincia` VARCHAR(50))

4. `CuentasBancarias` (`CuentaId` INT PK, `NumeroCuenta` VARCHAR(20) UNIQUE, `CuentahabienteId` INT FK, `SucursalId` INT FK, `TipoCuenta` VARCHAR(30), `SaldoDisponible` DECIMAL(18,2), `EstatusActivo` BIT)

5. `ServiciosFinancieros` (`ServicioId` INT PK, `CodigoServicio` VARCHAR(15) UNIQUE, `DescripcionServicio` VARCHAR(100), `TarifaMensual` DECIMAL(10,2))

6. `CuentasServicios` (`CuentaId` INT FK, `ServicioId` INT FK, `FechaAfiliacion` DATETIME, PK Compuesta: `CuentaId` + `ServicioId`)

7. `BitacoraAuditoria` (`BitacoraId` INT IDENTITY PK, `TablaAfectada` VARCHAR(50), `RegistroId` INT, `CampoModificado` VARCHAR(50), `ValorAnterior` VARCHAR(250), `ValorActual` VARCHAR(250), `FechaEvento` DATETIME, `UsuarioEjecutor` VARCHAR(100))

Integrante 1
Branch: `feature/tablas-relaciones-restricciones`
Archivo a entregar: `01_esquema_tablas.sql`
Lo que tiene que hacer:

* Crear la base de datos `BanreservasDB`.

* Crear las 7 tablas exactamente con las columnas y tipos de datos definidos en el contrato base.

* Configurar todas las Claves Primarias (`PRIMARY KEY`) en cada tabla.

* Configurar las Claves Secundarias (`FOREIGN KEY`) respetando las 3 relaciones pedidas:

  * Relación 1 a 1: `Cuentahabientes` con `ExpedientesKYC` (usando `UNIQUE` en la FK `CuentahabienteId` de `ExpedientesKYC`).

  * Relación 1 a muchos: `Cuentahabientes` con `CuentasBancarias`, y `SucursalesBancarias` con `CuentasBancarias`.

  * Relación muchos a muchos: `CuentasBancarias` y `ServiciosFinancieros` a través de la tabla puente `CuentasServicios`.

* Configurar las restricciones de Clave Única (`UNIQUE`) en `Cedula`, `CodigoOficina`, `NumeroCuenta` y `CodigoServicio`.

* Insertar al menos 5 registros de prueba en cada tabla para que el proyecto tenga datos al integrarse.
  Commits sugeridos:

* `feat(schema): crear base de datos BanreservasDB y estructura de tablas`

* `feat(constraints): agregar claves primarias, foraneas y unicas (1:1, 1:N, N:M)`

* `feat(seed): insertar datos iniciales de prueba para Banreservas`

Integrante 2
Branch: `feature/vistas-bancarias`
Archivo a entregar: `02_vistas.sql`
Lo que tiene que hacer:

* Asumir que las tablas del contrato base ya existen y escribir el script con las 3 vistas requeridas (si desea probarlas localmente, puede crear las tablas temporalmente en su máquina pero solo subir al repositorio el archivo `02_vistas.sql`):

  1. `vw_ResumenCuentasClientes`: Vista que relacione y muestre campos de `Cuentahabientes`, `CuentasBancarias` y `SucursalesBancarias` (`Cedula`, `Nombres`, `NumeroCuenta`, `TipoCuenta`, `SaldoDisponible`, `NombreOficina`).

  2. `vw_RankingSaldosCuentas`: Vista que muestre las cuentas bancarias ordenadas de mayor a menor según `SaldoDisponible` utilizando `ORDER BY` (recordar usar `TOP 100 PERCENT` en SQL Server para que permita el `ORDER BY` dentro de una vista).

  3. `vw_UnificacionContactosYServicios`: Vista que utilice dos `SELECT` unidos por el operador `UNION` o `UNION ALL` (por ejemplo, primer `SELECT` consultando cuentas de tipo 'Ahorro' y segundo `SELECT` consultando cuentas de tipo 'Corriente', o unificando códigos y nombres de `SucursalesBancarias` y `ServiciosFinancieros`).
     Commits sugeridos:

* `feat(views): crear vista relacional de cuentahabientes, cuentas y sucursales`

* `feat(views): crear vista de cuentas bancarias con clausula order by`

* `feat(views): crear vista combinada utilizando operador union entre dos select`

Integrante 3
Branch: `feature/funciones-bancarias`
Archivo a entregar: `03_funciones.sql`
Lo que tiene que hacer:

* Escribir el script con las 3 funciones requeridas basándose en los nombres del contrato base:

  1. `fn_ContarCuentasPorTipo` (`@TipoCuenta VARCHAR(30)`): Función escalar que reciba el tipo de cuenta como parámetro y devuelva el conteo (`COUNT`) de registros en la tabla `CuentasBancarias` que coincidan con ese criterio.

  2. `fn_DetalleCompletoServiciosCliente` (): Función Inline Table-Valued que relacione al menos 3 tablas (`Cuentahabientes`, `CuentasBancarias`, `CuentasServicios` y `ServiciosFinancieros`) devolviendo qué servicios tiene afiliada cada cuenta y a qué cliente pertenece.

  3. `fn_CuentasPorProvincia` (`@Provincia VARCHAR(50)`): Función Inline Table-Valued que reciba la provincia como parámetro y filtre las cuentas bancarias registradas en sucursales de dicha provincia.
     Commits sugeridos:

* `feat(functions): implementar funcion escalar para contar cuentas por tipo`

* `feat(functions): implementar funcion inline relacionando cuatro tablas del banco`

* `feat(functions): implementar funcion inline con parametro de filtro por provincia`

Integrante 4
Branch: `feature/triggers-auditoria`
Archivo a entregar: `04_triggers.sql`
Lo que tiene que hacer:

* Escribir el script con los desencadenadores requeridos basándose en el contrato base:

  1. `trg_BorradoLogicoCuenta`: Trigger `INSTEAD OF DELETE` sobre la tabla `CuentasBancarias` que, en lugar de eliminar el registro físicamente, actualice el campo `EstatusActivo = 0`.

  2. `trg_AuditoriaCuentasBancarias`: Trigger `AFTER UPDATE` en `CuentasBancarias` que guarde en la tabla `BitacoraAuditoria` los cambios realizados en `SaldoDisponible` (tomando el valor anterior de la tabla `deleted`, el valor actual de `inserted`, `GETDATE()` y `SYSTEM_USER`).

  3. `trg_AuditoriaExpedientesKYC`: Trigger `AFTER UPDATE` en `ExpedientesKYC` que guarde en la tabla `BitacoraAuditoria` los cambios realizados en `IngresoMensualEstimado` o `NivelRiesgo` (valor anterior, valor actual, fecha y usuario).
     Commits sugeridos:

* `feat(triggers): agregar trigger instead of delete para cambio de estatus en cuentas`

* `feat(triggers): agregar trigger de auditoria para cambios de saldo en CuentasBancarias`

* `feat(triggers): agregar trigger de auditoria para cambios en ExpedientesKYC`

Integrante 5
Branch: `feature/procedimientos-almacenados`
Archivo a entregar: `05_procedimientos.sql`
Lo que tiene que hacer:

* Escribir los procedimientos almacenados CRUD para la tabla `Cuentahabientes` (o `ServiciosFinancieros`) respetando las columnas del contrato base:

  1. `sp_InsertarCuentahabiente`: Recibe `@CuentahabienteId`, `@Cedula`, `@Nombres`, `@Apellidos`, `@Telefono`, `@EstatusActivo` e inserta el registro en `Cuentahabientes`.

  2. `sp_ModificarCuentahabiente`: Recibe `@CuentahabienteId` y los demás parámetros para actualizar (`UPDATE`) los datos del cliente en `Cuentahabientes`.

  3. `sp_EliminarCuentahabiente`: Recibe `@CuentahabienteId` y ejecuta el `DELETE` del registro en `Cuentahabientes`.
     Commits sugeridos:

* `feat(sp): crear procedimiento almacenado para insertar cuentahabientes`

* `feat(sp): crear procedimiento almacenado para modificar cuentahabientes`

* `feat(sp): crear procedimiento almacenado para eliminar cuentahabientes`

Integrante 6
Branch: `feature/usuarios-permisos`
Archivo a entregar: `06_seguridad_usuarios.sql`
Lo que tiene que hacer:

* Escribir el script de creación de Logins, Usuarios y asignación de roles/permisos DCL (`GRANT`, `DENY`, `ALTER ROLE`) sobre `BanreservasDB`:

  1. Crear el login y usuario `usr_admin_servidor` y asignarle el rol fijo de servidor `sysadmin` (administrador del servidor de base de datos).

  2. Crear el login y usuario `usr_admin_bd` y asignarle el rol `db_owner` dentro de `BanreservasDB` (administrador de la base de datos).

  3. Crear el login y usuario `usr_lectura_banreservas` y asignarle el rol `db_datareader` (solo acceso de lectura `SELECT`).

  4. Crear el login y usuario `usr_gestor_servicios` y otorgarle todos los permisos (`GRANT SELECT, INSERT, UPDATE, DELETE`) únicamente sobre la tabla `ServiciosFinancieros`.

  5. Crear el login y usuario `usr_cajero_restringido`, darle lectura general, pero negarle explícitamente el permiso de actualizar (`DENY UPDATE`) en `ExpedientesKYC` y negarle ver el campo `IngresoMensualEstimado` (`DENY SELECT ON dbo.ExpedientesKYC(IngresoMensualEstimado)`).
     Commits sugeridos:

* `feat(security): crear usuarios administradores de servidor y de base de datos`

* `feat(security): configurar usuario de solo lectura y usuario exclusivo de una tabla`

* `feat(security): configurar usuario con restriccion deny en actualizacion y columna especifica`
