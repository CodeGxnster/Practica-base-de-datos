CREATE DATABASE BanreservasDB
GO

USE BanreservasDB
GO


--Tabla Cuenta Habientes
CREATE TABLE Cuentahabientes
(
CuentahabienteId INT PRIMARY KEY,
Cedula VARCHAR(11) NOT NULL UNIQUE,
Nombres VARCHAR(100) NOT NULL,
Apellidos VARCHAR(100) NOT NULL,
Telefono VARCHAR(15) NOT NULL UNIQUE,
EstatusActivo BIT NOT NULL
)
GO


--Tabla Expedientes KYC
CREATE TABLE ExpedientesKYC
(
ExpedienteId INT PRIMARY KEY, 
CuentahabienteId INT UNIQUE FOREIGN KEY REFERENCES Cuentahabientes(cuentahabienteId),
NivelRiesgo VARCHAR(20) NOT NULL,
IngresoMensualEstimado DECIMAL(18,2) DEFAULT 0.00,
FechaVerificacion DATETIME NOT NULL DEFAULT GETDATE()
)

--Tabla Sucursales Bancarias
CREATE TABLE SucursalesBancarias
(
SucursalId INT PRIMARY KEY,
CodigoOficina VARCHAR(10) NOT NULL UNIQUE,
NombreOficina VARCHAR(100) NOT NULL, 
Provincia VARCHAR(50) NOT NULL
)


--Tabla Cuentas Bancarias
CREATE TABLE CuentasBancarias
(
CuentaId INT PRIMARY KEY,
NumeroCuenta VARCHAR(20) NOT NULL UNIQUE,
CuentahabienteId INT FOREIGN KEY REFERENCES Cuentahabientes(cuentahabienteId),
SucursalId INT FOREIGN KEY REFERENCES SucursalesBancarias(SucursalId),
TipoCuenta VARCHAR(30) NOT NULL,
SaldoDisponible DECIMAL(18,2) DEFAULT 0.00,
EstatusActivo BIT NOT NULL
)

--Tabla Servicios Financieros
CREATE TABLE ServiciosFinancieros
(
ServicioId INT PRIMARY KEY,
CodigoServicio VARCHAR(16) NOT NULL UNIQUE,
DescripcionServicio VARCHAR(100) NOT NULL,
TarifaMensual DECIMAL(10,2) DEFAULT 0.00
)

--Tabla Cuentas Servicios
CREATE TABLE CuentasServicios 
(
CuentaId INT ,
ServicioId INT,
FechaAfiliacion DATETIME DEFAULT GETDATE()

CONSTRAINT PK_CuentaServicios
 PRIMARY KEY (CuentaId,ServicioId),

CONSTRAINT FK_CuentasServicios_CuentasBancarias
FOREIGN KEY (CuentaId)
REFERENCES CuentasBancarias(CuentaId),

CONSTRAINT FK_CuentasServicios_ServiciosFinancieros
FOREIGN KEY (ServicioId) 
REFERENCES ServiciosFinancieros(ServicioId)
) 

--Tabla Bitacora Auditoria
CREATE TABLE BitacoraAuditoria
(
BitacoraId INT IDENTITY(1,1) PRIMARY KEY,
TablaAfectada VARCHAR(50) NOT NULL,
RegistroId INT NOT NULL,
CampoModificado VARCHAR(50),
ValorAnterior VARCHAR(250),
ValorActual VARCHAR(250),
FechaEvento DATETIME NOT NULL DEFAULT GETDATE(),
UsuarioEjecutor VARCHAR(100)
)





