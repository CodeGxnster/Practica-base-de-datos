/* ============================================================
   PROYECTO      : BanreservasDB
   INTEGRANTE    : 6
   ============================================================ */

USE [master];
GO

/* ------------------------------------------------------------
   1. ADMINISTRADOR DEL SERVIDOR
      Login/usuario   : usr_admin_servidor
      Rol de servidor : sysadmin
   ------------------------------------------------------------ */
IF NOT EXISTS (
    SELECT 1
    FROM sys.server_principals
    WHERE name = N'usr_admin_servidor'
)
BEGIN
    CREATE LOGIN [usr_admin_servidor]
        WITH PASSWORD = N'N0d0S3gur0#2026',
             CHECK_POLICY = ON,
             CHECK_EXPIRATION = OFF;
END;
GO

USE [BanreservasDB];
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = N'usr_admin_servidor'
)
BEGIN
    CREATE USER [usr_admin_servidor]
        FOR LOGIN [usr_admin_servidor]
        WITH DEFAULT_SCHEMA = [dbo];
END;
GO

IF IS_SRVROLEMEMBER(N'sysadmin', N'usr_admin_servidor') = 0
BEGIN
    ALTER SERVER ROLE [sysadmin] ADD MEMBER [usr_admin_servidor];
END;
GO

/* ------------------------------------------------------------
   2. ADMINISTRADOR DE LA BASE DE DATOS
      Login/usuario        : usr_admin_bd
      Rol de base de datos : db_owner
   ------------------------------------------------------------ */
USE [master];
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.server_principals
    WHERE name = N'usr_admin_bd'
)
BEGIN
    CREATE LOGIN [usr_admin_bd]
        WITH PASSWORD = N'B4s3D4t0s#2026',
             CHECK_POLICY = ON,
             CHECK_EXPIRATION = OFF;
END;
GO

USE [BanreservasDB];
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = N'usr_admin_bd'
)
BEGIN
    CREATE USER [usr_admin_bd]
        FOR LOGIN [usr_admin_bd]
        WITH DEFAULT_SCHEMA = [dbo];
END;
GO

IF IS_ROLEMEMBER(N'db_owner', N'usr_admin_bd') = 0
BEGIN
    ALTER ROLE [db_owner] ADD MEMBER [usr_admin_bd];
END;
GO

/* ------------------------------------------------------------
   3. USUARIO DE SOLO LECTURA
      Login/usuario        : usr_lectura_banreservas
      Rol de base de datos : db_datareader
   ------------------------------------------------------------ */
USE [master];
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.server_principals
    WHERE name = N'usr_lectura_banreservas'
)
BEGIN
    CREATE LOGIN [usr_lectura_banreservas]
        WITH PASSWORD = N'S0l0Acc3s0#2026',
             CHECK_POLICY = ON,
             CHECK_EXPIRATION = OFF;
END;
GO

USE [BanreservasDB];
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = N'usr_lectura_banreservas'
)
BEGIN
    CREATE USER [usr_lectura_banreservas]
        FOR LOGIN [usr_lectura_banreservas]
        WITH DEFAULT_SCHEMA = [dbo];
END;
GO

IF IS_ROLEMEMBER(N'db_datareader', N'usr_lectura_banreservas') = 0
BEGIN
    ALTER ROLE [db_datareader] ADD MEMBER [usr_lectura_banreservas];
END;
GO

/* ------------------------------------------------------------
   4. GESTOR EXCLUSIVO DE SERVICIOS FINANCIEROS
      Login/usuario : usr_gestor_servicios
      Permisos      : SELECT, INSERT, UPDATE y DELETE únicamente
                      sobre dbo.ServiciosFinancieros
   ------------------------------------------------------------ */
USE [master];
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.server_principals
    WHERE name = N'usr_gestor_servicios'
)
BEGIN
    CREATE LOGIN [usr_gestor_servicios]
        WITH PASSWORD = N'P3rm1s0s#2026',
             CHECK_POLICY = ON,
             CHECK_EXPIRATION = OFF;
END;
GO

USE [BanreservasDB];
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = N'usr_gestor_servicios'
)
BEGIN
    CREATE USER [usr_gestor_servicios]
        FOR LOGIN [usr_gestor_servicios]
        WITH DEFAULT_SCHEMA = [dbo];
END;
GO

GRANT SELECT, INSERT, UPDATE, DELETE
    ON [dbo].[ServiciosFinancieros]
    TO [usr_gestor_servicios];
GO

/* ------------------------------------------------------------
   5. CAJERO CON RESTRICCIONES
      Login/usuario : usr_cajero_restringido
      Permisos      : lectura general (db_datareader)
      Restricciones : DENY UPDATE sobre dbo.ExpedientesKYC y
                      DENY SELECT sobre la columna
                      IngresoMensualEstimado
   ------------------------------------------------------------ */
USE [master];
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.server_principals
    WHERE name = N'usr_cajero_restringido'
)
BEGIN
    CREATE LOGIN [usr_cajero_restringido]
        WITH PASSWORD = N'Acc3s0L1m1t4d0#2026',
             CHECK_POLICY = ON,
             CHECK_EXPIRATION = OFF;
END;
GO

USE [BanreservasDB];
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = N'usr_cajero_restringido'
)
BEGIN
    CREATE USER [usr_cajero_restringido]
        FOR LOGIN [usr_cajero_restringido]
        WITH DEFAULT_SCHEMA = [dbo];
END;
GO

IF IS_ROLEMEMBER(N'db_datareader', N'usr_cajero_restringido') = 0
BEGIN
    ALTER ROLE [db_datareader] ADD MEMBER [usr_cajero_restringido];
END;
GO

DENY UPDATE ON [dbo].[ExpedientesKYC] TO [usr_cajero_restringido];
GO

DENY SELECT ON [dbo].[ExpedientesKYC] ([IngresoMensualEstimado])
    TO [usr_cajero_restringido];
GO
