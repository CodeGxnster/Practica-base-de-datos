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
