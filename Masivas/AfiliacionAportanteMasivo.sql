
CREATE PROCEDURE [dbo].[AfiliacionAportanteMasivo]
	@TipoDocumento  NVARCHAR(2),		-- Tipo de identificación del aportante
	@NumeroDocumento  NVARCHAR(17)		-- Número de identificación del aportante
AS

SET NOCOUNT ON

-- consulta pxxx_afiliaciones_empleador
select distinct
	'' as numeroTrasaccion
	,SUBSTRING(DB_NAME(), CHARINDEX('_', DB_NAME()) + 1, LEN(DB_NAME())) AS ccfCorrespondeConsultado
	,e.c8 as tipoIdenConsultado
	,e.c9 as numIdenConsultado
	,'NA' as tipoAfiliado
	,e.c11 as razonSocialEmpleador
	,afe.c523 as fechaIniAfiliacionEmpleador
	,afe.c525 as fechaFinAfiliacionEmpleador	
	,CASE WHEN afe.c583 is null THEN 'Activo' ELSE 'Inactivo' END AS estadoAfiliacion	
from [espejo_ccf02].[dbo].[empleadores] e
	inner join [espejo_ccf02].[dbo].[afiliaciones_empleadores] afe on afe.c8 = e.c8
		and afe.c9 = e.c9
		--and afe.NumeroCCF = e.NumeroCCF
		--and afe.c525 IS NULL 
	--inner join [BDCCFSERVER2].[H2_Migration].[dbo].[cat_cajascaja] c on c.cajaid = e.NumeroCCF
	----inner join [BDCCFSERVER2].[H2_Migration].[dbo].[cat_catalogosmain] cc on c.caja_departamento_bdsid = cc.bds_id	
where e.c8 = @TipoDocumento
	and e.c9 = @NumeroDocumento
;

-- consulta pxxx_datos_basicos_emp_juridica
select distinct
	'' as numeroTransaccion
	,SUBSTRING(DB_NAME(), CHARINDEX('_', DB_NAME()) + 1, LEN(DB_NAME())) as ccfResponde
	,e.c11 as razonSocial
	,e.c9 as numeroIdentificacionEmpresa
	,e.c8 as tipoIdentificacionEmpresa
	,'' as fechaCreacionEmpresa
	,'' as registroMercantil
	,'' as fechaRegistroMercantil
	,'' as fechaRenovacionMatriculaMercantil
	,'' as claseEmpleador
	,'' as codigoNovedad
	,'' as codigoReferencia
	,'' as fechaValidacionRUES
	,'' as codigoValidacionRUES		
from [espejo_ccf02].[dbo].[empleadores] e
	inner join [espejo_ccf02].[dbo].[afiliaciones_empleadores] afe on afe.c8 = e.c8
		and afe.c9 = e.c9
		--and afe.NumeroCCF = e.NumeroCCF
		and afe.c525 IS NULL 
	--inner join [BDCCFSERVER2].[H2_Migration].[dbo].[cat_cajascaja] c on c.cajaid = e.NumeroCCF
	----inner join [BDCCFSERVER2].[H2_Migration].[dbo].[cat_catalogosmain] cc on c.caja_departamento_bdsid = cc.bds_id	
where e.c8 = @TipoDocumento
	and e.c9 = @NumeroDocumento
;

-- consulta pxxx_total_trabajadores_aportante
select 
	'' as numeroTransaccion
	,COUNT(*) as totalTrabajadores
	,afe.c8 as tipoIdentificacionEmpleador
	,afe.c9 as numeroIdentificacionEmpleador
from [espejo_ccf02].[dbo].[empleadores] e
	inner join [espejo_ccf02].[dbo].[afiliaciones_empleadores] afe on afe.c8 = e.c8
		and afe.c9 = e.c9
		--and afe.NumeroCCF = e.NumeroCCF
		and afe.c525 IS NULL 
	--inner join [BDCCFSERVER2].[H2_Migration].[dbo].[cat_cajascaja] c on c.cajaid = e.NumeroCCF
	----inner join [BDCCFSERVER2].[H2_Migration].[dbo].[cat_catalogosmain] cc on c.caja_departamento_bdsid = cc.bds_id
	inner join [espejo_ccf02].[dbo].[afiliaciones_trabajadores] aft on aft.c8 = e.c8 
		and aft.c9 = e.c9
		AND (aft.C525 IS NULL OR aft.C525 = '1900-01-01')
		--and aft.NumeroCCF = afe.NumeroCCF		
where afe.c8 = @TipoDocumento
	and afe.c9 = @NumeroDocumento
group by afe.c8, afe.c9
;

-- consulta pxx_trabajadores_registrados_aportante
select distinct
	'' as numeroTransaccion
	,SUBSTRING(DB_NAME(), CHARINDEX('_', DB_NAME()) + 1, LEN(DB_NAME())) as ccfCorresponde
	,e.c8 as tipoIdentificacionConsultado
	,e.c9 as numeroIdentificacionConsultado
	,aft.c47 as tipoIdentificacionTrabajador
	,aft.c48 as numeroIdentificacionTrabajador
	,t.c51 as primerNombreTrabajador
	,t.c52 as segundoNombreTrabajador
	,t.c49 as primerApellidoTrabajador
	,t.c50 as segundoApellidoTrabajador
	,aft.c523 as fechaInicio
	,CASE WHEN aft.c525 is null THEN 'Activo' ELSE 'Inactivo' END AS estadoAfiliacionTrabajador
	,'' as tipoIdentificacionTrabajadorId
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
where e.c8 = @TipoDocumento
	and e.c9 = @NumeroDocumento
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