--Procedimientos almacenados CRUD

CREATE PROCEDURE sp_InsertCuentaHabiente
@Cedula varchar(15), @Nombre varchar(30), @Apellidos varchar(40), @Telefono varchar(14), @EstatusActivo int,
@CuentahabienteId int output 
AS
BEGIN
    SET NOCOUNT ON;
    SELECT @CuentahabienteId = ISNULL(MAX(CuentahabienteId),0)+1 FROM Cuentahabientes;
    INSERT INTO Cuentahabientes (Cedula, Nombre, Apellidos, Telefono, EstatusActivo, CuentahabienteId)
    VALUES (@Cedula, @Nombre, @Apellidos, @Telefono, @EstatusActivo, @CuentahabienteId);
END;
GO

CREATE PROCEDURE sp_ReadCuentaHabiente
AS 
BEGIN
    SET NOCOUNT ON;
    SELECT Cedula, Nombre, Apellidos, Telefono, EstatusActivo, CuentahabienteId
    FROM dbo.Cuentahabientes;
END;
GO

CREATE PROCEDURE sp_UpdateCuentaHabiente
@CuentahabienteId int, @Cedula varchar(15), @Nombre varchar(30), @Apellidos varchar(40), @Telefono varchar(14), @EstatusActivo int
AS
BEGIN   
    SET NOCOUNT ON;
    UPDATE Cuentahabientes
    SET Cedula = @Cedula, Nombre = @Nombre, Apellidos = @Apellidos, Telefono = @Telefono, EstatusActivo = @EstatusActivo
    WHERE CuentahabienteId = @CuentahabienteId;
END;
GO

CREATE PROCEDURE sp_DeleteCuentahabientes
@CuentahabienteId int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        DELETE FROM Cuentahabientes WHERE CuentahabienteId = @CuentahabienteId;
        COMMIT TRANSACTION;
    END TRY 
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS mensaje;
    END CATCH;
END;
GO