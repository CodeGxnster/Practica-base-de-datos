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

--Trigger sobre la tabla `CuentasBancarias` que guarde en `BitacoraAuditoria` los cambios realizados en `SaldoDisponible`.
CREATE TRIGGER trg_AuditoriaCuentasBancarias ON CuentasBancarias
AFTER UPDATE
AS
BEGIN
	IF UPDATE(SaldoDisponible)
	BEGIN
		INSERT INTO BitacoraAuditoria 
		SELECT 'CuentasBancarias' TablaAfectada,
				cb.CuentaId	      RegistroId, 
			   'SaldoDisponible'  CampoModificado, 
			   d.SaldoDisponible  ValorAnterior,
			   i.SaldoDisponible  ValorActual,
			   GETDATE()	      FechaEvento,
			   SYSTEM_USER		  UsuarioEjector
		FROM CuentasBancarias cb
		INNER JOIN inserted i ON cb.CuentaId = i.CuentaId
		INNER JOIN deleted d ON cb.CuentaId = d.CuentaId
	END
END
GO

-- Trigger sobre la tabla`ExpedientesKYC` que guarda en la tabla `BitacoraAuditoria` los cambios realizados en `IngresoMensualEstimado` y en `NivelRiesgo`.
CREATE TRIGGER trg_AuditoriaExpedientesKYC ON ExpedientesKYC
AFTER UPDATE	
AS
BEGIN
	IF UPDATE(IngresoMensualEstimado)
	BEGIN
		INSERT INTO BitacoraAuditoria
		SELECT 'ExpedientesKYC' TablaAfectada,
			   e.ExpedienteId RegistroId,
			   'IngresoMensualEstimado' CampoModificado,
			   d.IngresoMensualEstimado ValorAnterior,
			   i.IngresoMensualEstimado ValorActual,
			   GETDATE() FechaEvento,
			   SYSTEM_USER UsuarioEjecutor
		FROM ExpedientesKYC e
		INNER JOIN inserted i ON e.ExpedienteId = i.ExpedienteId
		INNER JOIN deleted d ON e.ExpedienteId = d.ExpedienteId
	END

	IF UPDATE(NivelRiesgo)
	BEGIN
		INSERT INTO BitacoraAuditoria
		SELECT 'ExpedientesKYC' TablaAfectada,
			   e.ExpedienteId RegistroId,
			   'NivelRiesgo' CampoModificado,
			   d.NivelRiesgo ValorAnterior,
			   i.NivelRiesgo ValorActual,
			   GETDATE() FechaEvento,
			   SYSTEM_USER UsuarioEjecutor
		FROM ExpedientesKYC e
		INNER JOIN inserted i ON e.ExpedienteId = i.ExpedienteId
		INNER JOIN deleted d ON e.ExpedienteId = d.ExpedienteId
	END
END
