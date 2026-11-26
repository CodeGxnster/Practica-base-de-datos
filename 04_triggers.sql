USE BanreservasDB
GO

--Trigger sobre la tabla `CuentasBancarias` que hace un soft delete.
CREATE TRIGGER trg_BorradoLogicoCuenta ON CuentasBancarias
INSTEAD OF Delete
AS
BEGIN
	UPDATE CuentasBancarias set EstatusActivo = 0; 
END
GO

--``: Trigger `AFTER UPDATE` en `CuentasBancarias` que
--guarde en la tabla `BitacoraAuditoria` los cambios realizados en `SaldoDisponible`
--(tomando el valor anterior de la tabla `deleted`, el valor actual de `inserted`, `GETDATE()` y `SYSTEM_USER`).
CREATE TRIGGER trg_AuditoriaCuentasBancarias ON CuentasBancarias
AFTER UPDATE
AS
BEGIN
	INSERT INTO BitacoraAuditoria 
	SELECT 'CuentasBancarias' TablaAfectada, cb.CuentaId RegistroId, 'SaldoDisponible' CampoModificado,
	deleted
	FROM CuentasBancarias cb
	
	select * from deleted
	select * from CuentasBancarias
	select * from BitacoraAuditoria

END
GO