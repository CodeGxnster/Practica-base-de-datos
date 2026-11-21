/* ============================================================
   PROYECTO      : BanreservasDB
   INTEGRANTE    : 6
   ARCHIVO       : 06_seguridad_usuarios.sql
   MOTOR         : Microsoft SQL Server
   DESCRIPCIÓN   : Creación de logins, usuarios y asignación de
                   roles/permisos DCL sobre BanreservasDB.
   ============================================================
   REQUISITOS PREVIOS:
     - La base de datos BanreservasDB debe existir.
     - Deben existir las tablas dbo.ServiciosFinancieros y
       dbo.ExpedientesKYC (01_esquema_tablas.sql).
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
