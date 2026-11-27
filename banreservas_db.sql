-- Creacion de la base de datos BanreservasDB
IF DB_ID('BanreservasDB') IS NULL
BEGIN
    CREATE DATABASE BanreservasDB;
END;
GO

USE BanreservasDB;
GO

-- Tabla Cuentahabientes
CREATE TABLE Cuentahabientes
(
    CuentahabienteId INT PRIMARY KEY,
    Cedula VARCHAR(11) NOT NULL UNIQUE,
    Nombres VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    Telefono VARCHAR(15) NOT NULL UNIQUE,
    EstatusActivo BIT NOT NULL
);
GO

-- Tabla ExpedientesKYC
CREATE TABLE ExpedientesKYC
(
    ExpedienteId INT PRIMARY KEY,
    CuentahabienteId INT UNIQUE FOREIGN KEY REFERENCES Cuentahabientes(CuentahabienteId),
    NivelRiesgo VARCHAR(20) NOT NULL,
    IngresoMensualEstimado DECIMAL(18,2) DEFAULT 0.00,
    FechaVerificacion DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Tabla SucursalesBancarias
CREATE TABLE SucursalesBancarias
(
    SucursalId INT PRIMARY KEY,
    CodigoOficina VARCHAR(10) NOT NULL UNIQUE,
    NombreOficina VARCHAR(100) NOT NULL,
    Provincia VARCHAR(50) NOT NULL
);
GO

-- Tabla CuentasBancarias
CREATE TABLE CuentasBancarias
(
    CuentaId INT PRIMARY KEY,
    NumeroCuenta VARCHAR(20) NOT NULL UNIQUE,
    CuentahabienteId INT FOREIGN KEY REFERENCES Cuentahabientes(CuentahabienteId),
    SucursalId INT FOREIGN KEY REFERENCES SucursalesBancarias(SucursalId),
    TipoCuenta VARCHAR(30) NOT NULL,
    SaldoDisponible DECIMAL(18,2) DEFAULT 0.00,
    EstatusActivo BIT NOT NULL
);
GO

-- Tabla ServiciosFinancieros
CREATE TABLE ServiciosFinancieros
(
    ServicioId INT PRIMARY KEY,
    CodigoServicio VARCHAR(16) NOT NULL UNIQUE,
    DescripcionServicio VARCHAR(100) NOT NULL,
    TarifaMensual DECIMAL(10,2) DEFAULT 0.00
);
GO

-- Tabla CuentasServicios
CREATE TABLE CuentasServicios
(
    CuentaId INT,
    ServicioId INT,
    FechaAfiliacion DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_CuentaServicios PRIMARY KEY (CuentaId, ServicioId),
    CONSTRAINT FK_CuentasServicios_CuentasBancarias FOREIGN KEY (CuentaId) REFERENCES CuentasBancarias(CuentaId),
    CONSTRAINT FK_CuentasServicios_ServiciosFinancieros FOREIGN KEY (ServicioId) REFERENCES ServiciosFinancieros(ServicioId)
);
GO

-- Tabla BitacoraAuditoria
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
);
GO
-- Insercion de datos en Cuentahabientes
INSERT INTO Cuentahabientes (CuentahabienteId, Cedula, Nombres, Apellidos, Telefono, EstatusActivo)
VALUES
(1,  '00101234567', 'Frankelly',  'Cordero Eusebio',    '8095550101', 1),
(2,  '00109876543', 'Adelin',     'Vidal Mercedes',       '8095550102', 1),
(3,  '02300451289', 'Robert',       'Zorrilla',   '8295550103', 1),
(4,  '40223456789', 'Katherine',    'Ramirez',    '8495550104', 1),
(5,  '00111223344', 'Pedro Antonio',   'Gómez Núñez',        '8095550105', 1),
(6,  '02600789123', 'Laura Sofía',     'Castillo Tavares',   '8295550106', 1),
(7,  '40219871234', 'Angel',    'Hilario',   '8495550107', 0),
(8,  '00105566778', 'Carmen Rosa',     'Vásquez Lora',       '8095550108', 1),
(9,  '03100345678', 'Ramón Emilio',    'Almonte Reyes',      '8295550109', 1),
(10, '40227654321', 'Paola Andrea',    'Sánchez Polanco',    '8495550110', 1),
(11, '00114567890', 'Luis Eduardo',    'Morales Féliz',      '8095550111', 1),
(12, '02700112233', 'Elena Cristina',  'Bautista Peña',      '8295550112', 1),
(13, '40211229876', 'Jorge David',     'Reyes Mercedes',     '8495550113', 1),
(14, '00107788990', 'Valeria Nicole',  'Peguero De León',    '8095550114', 1),
(15, '02300998877', 'Fernando José',   'Cruz Cabrera',       '8295550115', 0),
(16, '40230112233', 'Sofía Isabel',    'Jiménez Herrera',    '8495550116', 1),
(17, '00116789012', 'Andrés Felipe',   'Taveras Marte',      '8095550117', 1),
(18, '02800445566', 'Gabriela María',  'Espinal Soto',       '8295550118', 1),
(19, '40218877665', 'Ricardo Antonio', 'Cordero Matos',      '8495550119', 1),
(20, '00103344556', 'Daniela Esther',  'Arias Contreras',    '8095550120', 1),
(21, '00119001122', 'Héctor Manuel',   'Peralta Tejeda',     '8095550121', 1),
(22, '40225544332', 'Natalia Beatriz', 'Valdez Paulino',     '8495550122', 1);
GO

-- Insercion de datos en ExpedientesKYC
INSERT INTO ExpedientesKYC (ExpedienteId, CuentahabienteId, NivelRiesgo, IngresoMensualEstimado, FechaVerificacion)
VALUES
(1,  1,  'Bajo',  85000.00,  '2026-01-15T10:30:00'),
(2,  2,  'Bajo',  120000.00, '2026-01-20T14:15:00'),
(3,  3,  'Medio', 65000.00,  '2026-02-03T09:00:00'),
(4,  4,  'Bajo',  95000.00,  '2026-02-10T11:45:00'),
(5,  5,  'Alto',  350000.00, '2026-02-18T16:20:00'),
(6,  6,  'Bajo',  72000.00,  '2026-03-01T08:50:00'),
(7,  7,  'Medio', 48000.00,  '2026-03-05T13:10:00'),
(8,  8,  'Bajo',  110000.00, '2026-03-12T15:00:00'),
(9,  9,  'Medio', 88000.00,  '2026-03-19T10:15:00'),
(10, 10, 'Bajo',  145000.00, '2026-04-02T09:40:00'),
(11, 11, 'Bajo',  92000.00,  '2026-04-09T14:30:00'),
(12, 12, 'Medio', 55000.00,  '2026-04-16T11:05:00'),
(13, 13, 'Alto',  420000.00, '2026-04-22T16:45:00'),
(14, 14, 'Bajo',  78000.00,  '2026-05-04T08:30:00'),
(15, 15, 'Medio', 52000.00,  '2026-05-11T12:20:00'),
(16, 16, 'Bajo',  130000.00, '2026-05-18T10:50:00'),
(17, 17, 'Bajo',  105000.00, '2026-05-25T15:35:00'),
(18, 18, 'Medio', 68000.00,  '2026-06-03T09:15:00'),
(19, 19, 'Bajo',  160000.00, '2026-06-10T14:00:00'),
(20, 20, 'Bajo',  89000.00,  '2026-06-17T11:25:00'),
(21, 21, 'Medio', 74000.00,  '2026-06-24T13:50:00');
GO

-- Insercion de datos en SucursalesBancarias
INSERT INTO SucursalesBancarias (SucursalId, CodigoOficina, NombreOficina, Provincia)
VALUES
(1,  'SUC-001', 'Oficina Principal Churchill',         'Distrito Nacional'),
(2,  'SUC-002', 'Sucursal San Pedro Centro',           'San Pedro de Macorís'),
(3,  'SUC-003', 'Sucursal Santiago Independencia',     'Santiago'),
(4,  'SUC-004', 'Sucursal La Romana Duarte',           'La Romana'),
(5,  'SUC-005', 'Sucursal Higüey Altagracia',          'La Altagracia'),
(6,  'SUC-006', 'Sucursal San Cristóbal Constitución',  'San Cristóbal'),
(7,  'SUC-007', 'Sucursal Puerto Plata Malecón',       'Puerto Plata'),
(8,  'SUC-008', 'Sucursal La Vega Las Carreras',       'La Vega'),
(9,  'SUC-009', 'Sucursal Bonao Duarte',               'Monseñor Nouel'),
(10, 'SUC-010', 'Sucursal San Francisco Libertad',     'Duarte'),
(11, 'SUC-011', 'Sucursal Moca Sánchez',               'Espaillat'),
(12, 'SUC-012', 'Sucursal Baní Máximo Gómez',          'Peravia'),
(13, 'SUC-013', 'Sucursal Azua Emilio Prud''Homme',    'Azua'),
(14, 'SUC-014', 'Sucursal Barahona María Montez',      'Barahona'),
(15, 'SUC-015', 'Sucursal Mao Duarte',                 'Valverde'),
(16, 'SUC-016', 'Sucursal Cotuí 27 de Febrero',        'Sánchez Ramírez'),
(17, 'SUC-017', 'Sucursal Nagua María Trinidad',       'María Trinidad Sánchez'),
(18, 'SUC-018', 'Sucursal Samaná Malecón',             'Samaná'),
(19, 'SUC-019', 'Sucursal Hato Mayor Mercedes',        'Hato Mayor'),
(20, 'SUC-020', 'Sucursal Monte Plata Duarte',         'Monte Plata');
GO

-- Insercion de datos en CuentasBancarias
INSERT INTO CuentasBancarias (CuentaId, NumeroCuenta, CuentahabienteId, SucursalId, TipoCuenta, SaldoDisponible, EstatusActivo)
VALUES
(1,  '9601234501', 1,  1,  'Ahorros',   45200.50,  1),
(2,  '9601234502', 2,  1,  'Corriente', 185000.00, 1),
(3,  '9601234503', 3,  2,  'Ahorros',   31450.75,  1),
(4,  '9601234504', 4,  1,  'Ahorros',   64800.00,  1),
(5,  '9601234505', 5,  3,  'Corriente', 512300.25, 1),
(6,  '9601234506', 6,  4,  'Ahorros',   27900.00,  1),
(7,  '9601234507', 7,  2,  'Ahorros',   1250.00,   0),
(8,  '9601234508', 8,  5,  'Ahorros',   93600.80,  1),
(9,  '9601234509', 9,  3,  'Corriente', 74120.00,  1),
(10, '9601234510', 10, 1,  'Ahorros',   158900.40, 1),
(11, '9601234511', 11, 6,  'Ahorros',   53200.00,  1),
(12, '9601234512', 12, 7,  'Ahorros',   19850.60,  1),
(13, '9601234513', 13, 8,  'Corriente', 689400.00, 1),
(14, '9601234514', 14, 1,  'Ahorros',   41300.15,  1),
(15, '9601234515', 15, 2,  'Ahorros',   5400.00,   0),
(16, '9601234516', 16, 9,  'Ahorros',   112750.90, 1),
(17, '9601234517', 17, 10, 'Corriente', 87600.00,  1),
(18, '9601234518', 18, 11, 'Ahorros',   29450.30,  1),
(19, '9601234519', 19, 12, 'Corriente', 234500.00, 1),
(20, '9601234520', 20, 19, 'Ahorros',   62100.75,  1),
(21, '9601234521', 21, 2,  'Ahorros',   38700.00,  1),
(22, '9601234522', 22, 4,  'Ahorros',   79500.20,  1);
GO

-- Insercion de datos en ServiciosFinancieros
INSERT INTO ServiciosFinancieros (ServicioId, CodigoServicio, DescripcionServicio, TarifaMensual)
VALUES
(1,  'SRV-BANCA-DIG',  'Banca Digital y App Móvil',           0.00),
(2,  'SRV-ALERTA-SMS', 'Alertas SMS Transaccionales',         150.00),
(3,  'SRV-TOKEN-SEG',  'Token Digital de Seguridad',          0.00),
(4,  'SRV-CHEQUERA',   'Emisión de Chequera Personal',        650.00),
(5,  'SRV-TRANS-LBTR', 'Transferencias Interbancarias LBTR',  100.00),
(6,  'SRV-PAGO-SERV',  'Pago de Servicios Públicos en Línea', 0.00),
(7,  'SRV-ESTADO-DIG', 'Estado de Cuenta Electrónico',        0.00),
(8,  'SRV-SEGURO-FRAU','Protección Antifraude de Cuenta',     250.00),
(9,  'SRV-RETIRO-SIN', 'Retiro Sin Tarjeta en ATM',           0.00),
(10, 'SRV-NOMINA-PLUS','Gestión de Nómina Empresarial',       1200.00),
(11, 'SRV-DIVISAS-FX', 'Mesa de Cambio y Divisas Online',     0.00),
(12, 'SRV-CORRESPONSAL','Pagos en Subagentes Bancarios',      0.00),
(13, 'SRV-CERT-SALDO', 'Certificación de Saldo y Cuenta',     300.00),
(14, 'SRV-DOMICILIA',  'Débito Automático Recurrente',        0.00),
(15, 'SRV-TARJ-DEBITO','Tarjeta de Débito Banreservas',       350.00),
(16, 'SRV-AVISO-VIAJE','Notificación de Viaje Internacional', 0.00),
(17, 'SRV-CASH-MGMT',  'Cash Management Corporativo',         2500.00),
(18, 'SRV-REMESAS-RX', 'Cobro de Remesas en Sucursal y App',  0.00),
(19, 'SRV-CONSULTA-HIS','Histórico Extendido de Movimientos', 200.00),
(20, 'SRV-QR-COBRO',   'Cobros mediante Código QR',           0.00);
GO

-- Insercion de datos en CuentasServicios
INSERT INTO CuentasServicios (CuentaId, ServicioId, FechaAfiliacion)
VALUES
(1,  1,  '2026-01-16T09:00:00'),
(1,  2,  '2026-01-16T09:05:00'),
(1,  15, '2026-01-16T09:10:00'),
(2,  1,  '2026-01-21T10:00:00'),
(2,  4,  '2026-01-21T10:15:00'),
(3,  1,  '2026-02-04T11:20:00'),
(3,  9,  '2026-02-04T11:25:00'),
(4,  1,  '2026-02-11T08:40:00'),
(4,  2,  '2026-02-11T08:45:00'),
(5,  1,  '2026-02-19T14:00:00'),
(5,  5,  '2026-02-19T14:10:00'),
(5,  10, '2026-02-19T14:20:00'),
(6,  1,  '2026-03-02T09:30:00'),
(8,  1,  '2026-03-13T10:15:00'),
(8,  8,  '2026-03-13T10:20:00'),
(9,  1,  '2026-03-20T12:00:00'),
(10, 1,  '2026-04-03T09:45:00'),
(10, 15, '2026-04-03T09:50:00'),
(11, 1,  '2026-04-10T15:10:00'),
(13, 1,  '2026-04-23T16:00:00'),
(13, 17, '2026-04-23T16:15:00'),
(16, 20, '2026-05-19T11:00:00');
GO

-- Insercion de datos en BitacoraAuditoria
INSERT INTO BitacoraAuditoria (TablaAfectada, RegistroId, CampoModificado, ValorAnterior, ValorActual, FechaEvento, UsuarioEjecutor)
VALUES
('Cuentahabientes',      1,  'EstatusActivo',         '0',       '1',         '2026-01-15T10:25:00', 'admin.sistema'),
('ExpedientesKYC',       1,  'NivelRiesgo',           NULL,      'Bajo',      '2026-01-15T10:30:00', 'kyc.analista1'),
('CuentasBancarias',     1,  'SaldoDisponible',       '0.00',    '45200.50',  '2026-01-16T08:55:00', 'cajero.suc001'),
('CuentasServicios',     1,  'ServicioId',            NULL,      '1',         '2026-01-16T09:00:00', 'digital.bot'),
('Cuentahabientes',      2,  'Telefono',              '8095559999','8095550102','2026-01-20T14:10:00', 'oficial.cumplimiento'),
('ExpedientesKYC',       2,  'IngresoMensualEstimado','90000.00','120000.00','2026-01-20T14:15:00', 'kyc.analista1'),
('CuentasBancarias',     2,  'SaldoDisponible',       '0.00',    '185000.00', '2026-01-21T09:50:00', 'cajero.suc001'),
('Cuentahabientes',      3,  'EstatusActivo',         '0',       '1',         '2026-02-03T08:55:00', 'oficial.suc002'),
('ExpedientesKYC',       3,  'NivelRiesgo',           'Bajo',    'Medio',     '2026-02-03T09:00:00', 'kyc.analista2'),
('CuentasBancarias',     3,  'SaldoDisponible',       '0.00',    '31450.75',  '2026-02-04T11:15:00', 'cajero.suc002'),
('Cuentahabientes',      7,  'EstatusActivo',         '1',       '0',         '2026-03-05T13:05:00', 'riesgo.operativo'),
('ExpedientesKYC',       7,  'NivelRiesgo',           'Bajo',    'Medio',     '2026-03-05T13:10:00', 'kyc.analista2'),
('CuentasBancarias',     7,  'EstatusActivo',         '1',       '0',         '2026-03-05T13:12:00', 'riesgo.operativo'),
('CuentasBancarias',     5,  'SaldoDisponible',       '250000.00','512300.25','2026-02-19T13:50:00', 'cajero.suc003'),
('ServiciosFinancieros', 10, 'TarifaMensual',         '1000.00', '1200.00',   '2026-04-01T08:00:00', 'prod.finanzas'),
('CuentasBancarias',     13, 'SaldoDisponible',       '400000.00','689400.00','2026-04-23T15:50:00', 'cajero.suc008'),
('Cuentahabientes',      15, 'EstatusActivo',         '1',       '0',         '2026-05-11T12:15:00', 'riesgo.operativo'),
('CuentasBancarias',     15, 'EstatusActivo',         '1',       '0',         '2026-05-11T12:18:00', 'riesgo.operativo'),
('SucursalesBancarias',  19, 'NombreOficina',         'Sucursal Hato Mayor','Sucursal Hato Mayor Mercedes','2026-06-01T10:00:00','admin.red'),
('CuentasBancarias',     20, 'SaldoDisponible',       '0.00',    '62100.75',  '2026-06-17T11:20:00', 'cajero.suc019');
GO

-- Vista relacional de cuentahabientes, cuentas y sucursales
CREATE VIEW vw_ResumenCuentasClientes
AS
SELECT a.Cedula, a.Nombres, b.NumeroCuenta, b.TipoCuenta, b.SaldoDisponible, c.NombreOficina
FROM Cuentahabientes a
INNER JOIN CuentasBancarias b ON a.CuentahabienteId = b.CuentahabienteId
INNER JOIN SucursalesBancarias c ON b.SucursalId = c.SucursalId;
GO

-- Vista de cuentas ordenadas descendentemente por saldo
CREATE VIEW vw_RankingSaldosCuentas
AS
SELECT TOP 100 PERCENT CuentaId, NumeroCuenta, CuentahabienteId, SucursalId, TipoCuenta, SaldoDisponible, EstatusActivo
FROM CuentasBancarias
ORDER BY SaldoDisponible DESC;
GO

-- Vista combinada de cuentas de ahorros y corrientes
CREATE VIEW vw_UnificacionContactosYServicios
AS
SELECT CuentaId, NumeroCuenta, TipoCuenta, SaldoDisponible
FROM CuentasBancarias
WHERE TipoCuenta IN ('Ahorro', 'Ahorros')
UNION
SELECT CuentaId, NumeroCuenta, TipoCuenta, SaldoDisponible
FROM CuentasBancarias
WHERE TipoCuenta = 'Corriente';
GO

-- Funcion escalar que cuenta cuentas segun su tipo
CREATE FUNCTION dbo.ContarCuentasPorTipo
(
    @TipoCuenta VARCHAR(30)
)
RETURNS INT
AS
BEGIN
    DECLARE @TotalCuentas INT;
    SELECT @TotalCuentas = COUNT(*)
    FROM dbo.CuentasBancarias
    WHERE TipoCuenta = @TipoCuenta;
    RETURN @TotalCuentas;
END;
GO

-- Funcion inline con detalle de servicios por cliente y cuenta
CREATE FUNCTION dbo.fn_DetalleCompletoServiciosCliente()
RETURNS TABLE
AS
RETURN
(
    SELECT
        CH.CuentahabienteId,
        CH.Cedula,
        CH.Nombres,
        CH.Apellidos,
        CB.CuentaId,
        CB.NumeroCuenta,
        CB.TipoCuenta,
        SF.ServicioId,
        SF.CodigoServicio,
        SF.DescripcionServicio,
        SF.TarifaMensual,
        CS.FechaAfiliacion
    FROM dbo.Cuentahabientes AS CH
    INNER JOIN dbo.CuentasBancarias AS CB
        ON CH.CuentahabienteId = CB.CuentahabienteId
    INNER JOIN dbo.CuentasServicios AS CS
        ON CB.CuentaId = CS.CuentaId
    INNER JOIN dbo.ServiciosFinancieros AS SF
        ON CS.ServicioId = SF.ServicioId
);
GO

-- Funcion inline que filtra cuentas por provincia de la sucursal
CREATE FUNCTION dbo.fn_CuentasPorProvincia
(
    @Provincia VARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        CB.CuentaId,
        CB.NumeroCuenta,
        CB.CuentahabienteId,
        CB.SucursalId,
        CB.TipoCuenta,
        CB.SaldoDisponible,
        CB.EstatusActivo,
        SB.NombreOficina,
        SB.Provincia
    FROM dbo.CuentasBancarias AS CB
    INNER JOIN dbo.SucursalesBancarias AS SB
        ON CB.SucursalId = SB.SucursalId
    WHERE SB.Provincia = @Provincia
);
GO

-- Trigger para borrado logico de cuentas bancarias
CREATE TRIGGER trg_BorradoLogicoCuenta ON CuentasBancarias
INSTEAD OF DELETE
AS
BEGIN
    UPDATE CuentasBancarias
    SET EstatusActivo = 0
    FROM CuentasBancarias cb
    INNER JOIN deleted d ON cb.CuentaId = d.CuentaId;
END;
GO

-- Trigger de auditoria ante cambios en saldo disponible
CREATE TRIGGER trg_AuditoriaCuentasBancarias ON CuentasBancarias
AFTER UPDATE
AS
BEGIN
    IF UPDATE(SaldoDisponible)
    BEGIN
        INSERT INTO BitacoraAuditoria (TablaAfectada, RegistroId, CampoModificado, ValorAnterior, ValorActual, FechaEvento, UsuarioEjecutor)
        SELECT 'CuentasBancarias',
               cb.CuentaId,
               'SaldoDisponible',
               CAST(d.SaldoDisponible AS VARCHAR(250)),
               CAST(i.SaldoDisponible AS VARCHAR(250)),
               GETDATE(),
               SYSTEM_USER
        FROM CuentasBancarias cb
        INNER JOIN inserted i ON cb.CuentaId = i.CuentaId
        INNER JOIN deleted d ON cb.CuentaId = d.CuentaId;
    END
END;
GO

-- Trigger de auditoria ante cambios en ingreso o riesgo de expedientes KYC
CREATE TRIGGER trg_AuditoriaExpedientesKYC ON ExpedientesKYC
AFTER UPDATE
AS
BEGIN
    IF UPDATE(IngresoMensualEstimado)
    BEGIN
        INSERT INTO BitacoraAuditoria (TablaAfectada, RegistroId, CampoModificado, ValorAnterior, ValorActual, FechaEvento, UsuarioEjecutor)
        SELECT 'ExpedientesKYC',
               e.ExpedienteId,
               'IngresoMensualEstimado',
               CAST(d.IngresoMensualEstimado AS VARCHAR(250)),
               CAST(i.IngresoMensualEstimado AS VARCHAR(250)),
               GETDATE(),
               SYSTEM_USER
        FROM ExpedientesKYC e
        INNER JOIN inserted i ON e.ExpedienteId = i.ExpedienteId
        INNER JOIN deleted d ON e.ExpedienteId = d.ExpedienteId;
    END

    IF UPDATE(NivelRiesgo)
    BEGIN
        INSERT INTO BitacoraAuditoria (TablaAfectada, RegistroId, CampoModificado, ValorAnterior, ValorActual, FechaEvento, UsuarioEjecutor)
        SELECT 'ExpedientesKYC',
               e.ExpedienteId,
               'NivelRiesgo',
               d.NivelRiesgo,
               i.NivelRiesgo,
               GETDATE(),
               SYSTEM_USER
        FROM ExpedientesKYC e
        INNER JOIN inserted i ON e.ExpedienteId = i.ExpedienteId
        INNER JOIN deleted d ON e.ExpedienteId = d.ExpedienteId;
    END
END;
GO

-- Procedimiento para registrar un nuevo cuentahabiente
CREATE PROCEDURE sp_InsertCuentaHabiente
@Cedula VARCHAR(15), @Nombres VARCHAR(100), @Apellidos VARCHAR(100), @Telefono VARCHAR(15), @EstatusActivo INT,
@CuentahabienteId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT @CuentahabienteId = ISNULL(MAX(CuentahabienteId), 0) + 1 FROM Cuentahabientes;
    INSERT INTO Cuentahabientes (Cedula, Nombres, Apellidos, Telefono, EstatusActivo, CuentahabienteId)
    VALUES (@Cedula, @Nombres, @Apellidos, @Telefono, @EstatusActivo, @CuentahabienteId);
END;
GO

-- Procedimiento para consultar todos los cuentahabientes
CREATE PROCEDURE sp_ReadCuentaHabiente
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Cedula, Nombres, Apellidos, Telefono, EstatusActivo, CuentahabienteId
    FROM dbo.Cuentahabientes;
END;
GO

-- Procedimiento para actualizar los datos de un cuentahabiente
CREATE PROCEDURE sp_UpdateCuentaHabiente
@CuentahabienteId INT, @Cedula VARCHAR(15), @Nombres VARCHAR(100), @Apellidos VARCHAR(100), @Telefono VARCHAR(15), @EstatusActivo INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Cuentahabientes
    SET Cedula = @Cedula, Nombres = @Nombres, Apellidos = @Apellidos, Telefono = @Telefono, EstatusActivo = @EstatusActivo
    WHERE CuentahabienteId = @CuentahabienteId;
END;
GO

-- Procedimiento para eliminar un cuentahabiente con manejo transaccional
CREATE PROCEDURE sp_DeleteCuentahabientes
@CuentahabienteId INT
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

-- Login y usuario administrador del servidor
USE [master];
GO
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'usr_admin_servidor')
BEGIN
    CREATE LOGIN [usr_admin_servidor] WITH PASSWORD = N'N0d0S3gur0#2026', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
END;
GO
USE [BanreservasDB];
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'usr_admin_servidor')
BEGIN
    CREATE USER [usr_admin_servidor] FOR LOGIN [usr_admin_servidor] WITH DEFAULT_SCHEMA = [dbo];
END;
GO
IF IS_SRVROLEMEMBER(N'sysadmin', N'usr_admin_servidor') = 0
BEGIN
    ALTER SERVER ROLE [sysadmin] ADD MEMBER [usr_admin_servidor];
END;
GO

-- Login y usuario administrador de base de datos
USE [master];
GO
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'usr_admin_bd')
BEGIN
    CREATE LOGIN [usr_admin_bd] WITH PASSWORD = N'B4s3D4t0s#2026', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
END;
GO
USE [BanreservasDB];
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'usr_admin_bd')
BEGIN
    CREATE USER [usr_admin_bd] FOR LOGIN [usr_admin_bd] WITH DEFAULT_SCHEMA = [dbo];
END;
GO
IF IS_ROLEMEMBER(N'db_owner', N'usr_admin_bd') = 0
BEGIN
    ALTER ROLE [db_owner] ADD MEMBER [usr_admin_bd];
END;
GO

-- Login y usuario de solo lectura
USE [master];
GO
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'usr_lectura_banreservas')
BEGIN
    CREATE LOGIN [usr_lectura_banreservas] WITH PASSWORD = N'S0l0Acc3s0#2026', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
END;
GO
USE [BanreservasDB];
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'usr_lectura_banreservas')
BEGIN
    CREATE USER [usr_lectura_banreservas] FOR LOGIN [usr_lectura_banreservas] WITH DEFAULT_SCHEMA = [dbo];
END;
GO
IF IS_ROLEMEMBER(N'db_datareader', N'usr_lectura_banreservas') = 0
BEGIN
    ALTER ROLE [db_datareader] ADD MEMBER [usr_lectura_banreservas];
END;
GO

-- Login y usuario gestor de servicios financieros
USE [master];
GO
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'usr_gestor_servicios')
BEGIN
    CREATE LOGIN [usr_gestor_servicios] WITH PASSWORD = N'P3rm1s0s#2026', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
END;
GO
USE [BanreservasDB];
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'usr_gestor_servicios')
BEGIN
    CREATE USER [usr_gestor_servicios] FOR LOGIN [usr_gestor_servicios] WITH DEFAULT_SCHEMA = [dbo];
END;
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[ServiciosFinancieros] TO [usr_gestor_servicios];
GO

-- Login y usuario cajero restringido
USE [master];
GO
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'usr_cajero_restringido')
BEGIN
    CREATE LOGIN [usr_cajero_restringido] WITH PASSWORD = N'Acc3s0L1m1t4d0#2026', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
END;
GO
USE [BanreservasDB];
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'usr_cajero_restringido')
BEGIN
    CREATE USER [usr_cajero_restringido] FOR LOGIN [usr_cajero_restringido] WITH DEFAULT_SCHEMA = [dbo];
END;
GO
IF IS_ROLEMEMBER(N'db_datareader', N'usr_cajero_restringido') = 0
BEGIN
    ALTER ROLE [db_datareader] ADD MEMBER [usr_cajero_restringido];
END;
GO
DENY UPDATE ON [dbo].[ExpedientesKYC] TO [usr_cajero_restringido];
GO
DENY SELECT ON [dbo].[ExpedientesKYC] ([IngresoMensualEstimado]) TO [usr_cajero_restringido];
GO
