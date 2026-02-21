
CREATE PROCEDURE [dbo].[AfiliacionTrabajadorMasivo]
	@TipoDocumento  NVARCHAR(2),		-- Tipo de identificación del trabajador o cotizante o cabeza de familia
	@NumeroDocumento  NVARCHAR(17)		-- Número de identificación del trabajador o cotizante o cabeza de familia
AS

SET NOCOUNT ON

-- consulta pxxx_afiliaciones_trabajador
select 
	'' as numeroTransaccion
	,SUBSTRING(DB_NAME(), CHARINDEX('_', DB_NAME()) + 1, LEN(DB_NAME())) as ccfCorrespondeConsultado
	,aft.c47 as tipoIdentificacionConsultado
	,aft.c48 as numIdenConsultado
	,'' as tipoAfiliado
	,e.c8 as tipoIdenEmpleador
	,e.c9 as numIdenEmpleador
	,e.c11 as razonSocialEmpleador
	,afe.c523 as fechaIniAfiliacionEmpleador
	,afe.c525 as fechaFinAfiliacionEmpleador	
	,CASE WHEN afe.c583 is null THEN 'Activo' ELSE 'Inactivo' END AS estadoAfiliacionEmpleador	
	,t.c51 as primerNombreTrabajador
	,t.c52 as segundoNombreTrabajador
	,t.c49 as primerApellidoTrabajador
	,t.c50 as segundoApellidoTrabajador
	,'' as tipoAfiliacion
	,'' as subTipoTrabajador
	,'' as horasMesContratadas
	,aft.c523 as fechaIniAfiliacionTrabajador
	,aft.c525 as fechaFinAfiliacionTrabajador
	,CASE WHEN aft.c525 is null THEN 'Activo' ELSE 'Inactivo' END AS estadoAfiliacionTrabajador
	,'' as salarioBasicoIntegral
	,'' as salarioIntegral
	,'' as ingresosReportDependiente
	,'' as ingresosReportIndependiente
	,'' as ingresosReportPensionado
from [espejo_ccf02].[dbo].[empleadores] e
	inner join [espejo_ccf02].[dbo].[afiliaciones_empleadores] afe on afe.c8 = e.c8
		and afe.c9 = e.c9
		--and afe.NumeroCCF = e.NumeroCCF
		--and afe.c525 IS NULL 
	--inner join [BDCCFSERVER2].[H2_Migration].[dbo].[cat_cajascaja] c on c.cajaid = e.NumeroCCF
	----inner join [BDCCFSERVER2].[H2_Migration].[dbo].[cat_catalogosmain] cc on c.caja_departamento_bdsid = cc.bds_id
	inner join [espejo_ccf02].[dbo].[afiliaciones_trabajadores] aft on aft.c8 = e.c8 
		and aft.c9 = e.c9
		--and aft.NumeroCCF = afe.NumeroCCF
		AND (aft.C525 IS NULL OR aft.C525 = '1900-01-01')
	inner join [espejo_ccf02].[dbo].[trabajadores] t on t.c47 = aft.c47 
		and t.c48 = aft.c48
where aft.c47 = @TipoDocumento
	and aft.c48 = @NumeroDocumento
;

-- consulta pxxx_beneficiarios_afiliado
select 
	'' as numeroTransaccion
	,SUBSTRING(DB_NAME(), CHARINDEX('_', DB_NAME()) + 1, LEN(DB_NAME())) as ccfCorresponde
	,e.c11 as razonSocialEmpleador
	,b.c94 as tipoDocumBeneficiario
	,b.c95 as numDocumBeneficiario
	,b.c98 as primerNomBeneficiario
	,b.c99 as segundoNomBeneficiario
	,b.c96 as primerApeBeneficiario
	,b.c97 as segundoApeBeneficiario
	,afb.c523 as fechaIniAfiliacionBeneficiario
	,afb.c745 as tipoBeneficiario
	,CASE WHEN afb.c861 is null THEN 'Activo' ELSE 'Inactivo' END AS estadoAfiliacionBeneficiario
	,aft.c47 as tipoIdenConsultado
	,aft.c48 as numIdenConsultado
from [espejo_ccf02].[dbo].[empleadores] e
	inner join [espejo_ccf02].[dbo].[afiliaciones_empleadores] afe on afe.c8 = e.c8
		and afe.c9 = e.c9
		--and afe.NumeroCCF = e.NumeroCCF
		--and afe.c525 IS NULL 
	--inner join [BDCCFSERVER2].[H2_Migration].[dbo].[cat_cajascaja] c on c.cajaid = e.NumeroCCF
	----inner join [BDCCFSERVER2].[H2_Migration].[dbo].[cat_catalogosmain] cc on c.caja_departamento_bdsid = cc.bds_id
	inner join [espejo_ccf02].[dbo].[afiliaciones_trabajadores] aft on aft.c8 = e.c8 
		and aft.c9 = e.c9
		--and aft.NumeroCCF = afe.NumeroCCF
		AND (aft.C525 IS NULL OR aft.C525 = '1900-01-01')
	inner join [espejo_ccf02].[dbo].[trabajadores] t on t.c47 = aft.c47 
		and t.c48 = aft.c48
	inner join [espejo_ccf02].[dbo].[afiliaciones_beneficiarios] afb on afb.c47 = aft.c47
		and afb.c48 = aft.c48
	inner join [espejo_ccf02].[dbo].[beneficiarios] b on b.c94 = afb.c94
		and b.c95 = afb.c95
where aft.c47 = @TipoDocumento
	and aft.c48 = @NumeroDocumento
;

-- consulta pxx_datos_basicos_afiliado
select
	'' as numeroTransaccion
	,SUBSTRING(DB_NAME(), CHARINDEX('_', DB_NAME()) + 1, LEN(DB_NAME())) as ccfResponde
	,t.c51 + ' ' + ISNULL(t.c52, '') as nombresAfiliado
	,t.c49 + ' ' + ISNULL(t.c50, '') as apellidosAfiliado
	,t.c54 as fechaNacimientoAfiliado
	,aft.c48 as numeroIdentificacionConsultado
	,aft.c47 as tipoIdentificacionConsultado
	,'NA' as nacionalidad
	,'' as lugarNacimiento
	,'' as fechaExpedicionDocumento
	,'' as lugarExpedicionDocumento
	,e.c11 as razonSocialEmpleador
	,e.c9 as numeroIdentificacionEmpleador
	,e.c8 as tipoIdentificacionEmpleador
	,t.c53 as genero
	,'' as fechaValidacionRNEC
	,'' as codigoVerificacionRNEC
from [espejo_ccf02].[dbo].[empleadores] e
	inner join [espejo_ccf02].[dbo].[afiliaciones_empleadores] afe on afe.c8 = e.c8
		and afe.c9 = e.c9
		--and afe.NumeroCCF = e.NumeroCCF
		--and afe.c525 IS NULL 
	--inner join [BDCCFSERVER2].[H2_Migration].[dbo].[cat_cajascaja] c on c.cajaid = e.NumeroCCF
	----inner join [BDCCFSERVER2].[H2_Migration].[dbo].[cat_catalogosmain] cc on c.caja_departamento_bdsid = cc.bds_id
	inner join [espejo_ccf02].[dbo].[afiliaciones_trabajadores] aft on aft.c8 = e.c8 
		and aft.c9 = e.c9
		--and aft.NumeroCCF = afe.NumeroCCF
		AND (aft.C525 IS NULL OR aft.C525 = '1900-01-01')
	inner join [espejo_ccf02].[dbo].[trabajadores] t on t.c47 = aft.c47 
		and t.c48 = aft.c48
where aft.c47 = @TipoDocumento
	and aft.c48 = @NumeroDocumento
;

-- consulta pxx_fecha_hora_procesamiento
SELECT 
	'' as nombreTransaccion
    ,CAST(GETDATE() AS DATE) AS fechaProcesamiento
	,CAST(GETDATE() AS TIME) AS horaProcesamiento;

-- consulta pxx_actualizacion_bd
-- numeroTrasaccion,ccfId,proceso,fechaTerminacion,estadoCarga,tipoCarga

-- consulta a bd
--EXEC [dbo].[InformeActualizacionesBasesDatosEspejo];
