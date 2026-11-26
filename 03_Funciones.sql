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
