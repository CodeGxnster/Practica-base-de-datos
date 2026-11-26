Use BanreservasDB;
Go

Create Function dbo.ContarCuentasPorTipo
(
    @TipoCuenta VARCHAR(30)
)
Returns Int
As
begin
    Declare @TotalCuentas Int;

    Select @TotalCuentas = Count(*)
    From dbo.CuentasBancarias
    Where TipoCuenta = @TipoCuenta;

    Return @TotalCuentas;
End
go 

USE BanreservasDB;
GO

Create function dbo.fn_DetalleCompletoServiciosCliente()
Returns table
As
Return
(
    Select
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
    From dbo.Cuentahabientes As CH
    INNER JOIN dbo.CuentasBancarias As CB
        On CH.CuentahabienteId = CB.CuentahabienteId
    INNER JOIN dbo.CuentasServicios As CS
        On CB.CuentaId = CS.CuentaId
    INNER JOIN dbo.ServiciosFinancieros As SF
        On CS.ServicioId = SF.ServicioId
);
GO


Create function dbo.fn_CuentasPorProvincia
(
    @Provincia Varchar(50)
)
Returns table
As
Return
(
    Select
        CB.CuentaId,
        CB.NumeroCuenta,
        CB.CuentahabienteId,
        CB.SucursalId,
        CB.TipoCuenta,
        CB.SaldoDisponible,
        CB.EstatusActivo,
        SB.NombreOficina,
        SB.Provincia
    From dbo.CuentasBancarias As CB
    INNER JOIN dbo.SucursalesBancarias As SB
        On CB.SucursalId = SB.SucursalId
    where SB.Provincia = @Provincia
);
