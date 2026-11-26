USE BanreservasDB
GO

-- Vista relacional de cuentahabientes, cuentasBancarias y sucursalesBancarias
Create view vw_ResumenCuentasClientes
as
Select a.Cedula, a.Nombres, b.NumeroCuenta, b.TipoCuenta, b.SaldoDisponible, c.NombreOficina
From Cuentahabientes a
inner join CuentasBancarias b on a.CuentahabienteId = b.CuentahabienteId
inner join SucursalesBancarias c on b.SucursalId = c.SucursalId
GO

-- Vista de cuentas bancarias con clausula ORDER BY
Create view vw_RankingSaldosCuentas
as
Select top 100 percent CuentaId, NumeroCuenta, CuentahabienteId, SucursalId, TipoCuenta, SaldoDisponible, EstatusActivo
From CuentasBancarias
order by SaldoDisponible desc
GO

-- Vista combinada utilizando operador UNION entre dos SELECT
Create view vw_UnificacionContactosYServicios
as
Select CuentaId, NumeroCuenta, TipoCuenta, SaldoDisponible
From CuentasBancarias
where TipoCuenta = 'Ahorro'

UNION

Select CuentaId, NumeroCuenta, TipoCuenta, SaldoDisponible
From CuentasBancarias
where TipoCuenta = 'Corriente'
GO
