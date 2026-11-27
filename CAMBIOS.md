# Registro de Errores y Cambios

- Error en 05_procedimientos.sql por referencia a la columna inexistente 'Nombre'; se corrigió a 'Nombres' en los procedimientos CRUD para coincidir con la definición de Cuentahabientes.
- Error en 04_triggers.sql donde trg_BorradoLogicoCuenta actualizaba todas las cuentas sin filtro; se agregó la relación con la tabla 'deleted' para desactivar únicamente la cuenta eliminada.
- Error tipográfico en 04_triggers.sql en el alias 'UsuarioEjector'; se corrigió a 'UsuarioEjecutor' para mantener consistencia con el esquema de BitacoraAuditoria.
- Inconsistencia en 02_vistas.sql donde vw_UnificacionContactosYServicios buscaba 'Ahorro' en singular; se unificó la condición para admitir tanto 'Ahorro' como 'Ahorros' de los datos semilla.
- Formato no conforme en 06_seguridad_usuarios.sql por uso de comentarios multilínea; se reemplazaron por comentarios puntuales de una sola línea en el archivo unificado.
