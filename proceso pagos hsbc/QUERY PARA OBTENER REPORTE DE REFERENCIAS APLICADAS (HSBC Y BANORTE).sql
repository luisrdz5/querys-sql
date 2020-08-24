CREATE PROCEDURE nsp_reportePagosRap
AS
BEGIN
	WITH DATOS AS (
		SELECT 
			REG.NOMBREREGION AS REGION ,
			COO.NOMBRECOORD AS ZONA,
			CR.RPU AS RPU,
			LEFT(RIGHT(LTRIM(RTRIM(C.CCONCEPTO)), 17), 9) AS NUMCREDITO,
			M.FECHAOPERACION AS FECHAPAGO,
			RIGHT(LTRIM(RTRIM(C.CCONCEPTO)), 17) AS REFERENCIA,
			M.IMPORTE AS 'MONTOPAGADO',
			'BANORTE' AS BANCO,
			C.ESTATUS
		FROM DBO.EDOCUENTA_CCONCEPTO C
		JOIN DBO.EDOCUENTA_MOV M ON M.ID = C.IDEDOCUENTA_MOV
		LEFT JOIN SIRCANAC.DBO.CREDITOS CR ON CR.NUMCREDITO=LEFT(RIGHT(LTRIM(RTRIM(C.CCONCEPTO)), 17), 9)
		LEFT JOIN COORDINACIONES COO ON COO.CODCOORD=CR.CODCOORD AND COO.CODREGION=CR.CODREGION
		LEFT JOIN REGIONALES REG ON REG.CODREGION=CR.CODREGION
		WHERE  C.CCONCEPTO LIKE '%PAGO DETALLE%' AND C.ESTATUS NOT IN ('PENDIENTE')
		UNION 
		SELECT
			REG.NOMBREREGION AS REGION ,
			COO.NOMBRECOORD AS ZONA,
			CR.RPU AS RPU,
			LEFT(RIGHT(LTRIM(RTRIM(B.REFERENCIAMOV)), 17), 9) AS NUMCREDITO,
			CONVERT(VARCHAR,B.FECHAMOV,112) AS FECHAPAGO,
			RIGHT(LTRIM(RTRIM(B.REFERENCIAMOV)), 17) AS REFERENCIA,
			B.IMPORTEMOV,
			'HSBC' AS BANCO,
			B.ESTATUS
		FROM SIRCANAC.DBO.EDOCUENTA_HSBC B
		LEFT JOIN SIRCANAC.DBO.CREDITOS CR ON CR.NUMCREDITO=LEFT(RIGHT(LTRIM(RTRIM(B.REFERENCIAMOV)), 17), 9)
		LEFT JOIN COORDINACIONES COO ON COO.CODCOORD=CR.CODCOORD AND COO.CODREGION=CR.CODREGION
		LEFT JOIN REGIONALES REG ON REG.CODREGION=CR.CODREGION
		WHERE TIPOARCHIVO = 'RPTMOVDIARIO'
		AND ESTATUS NOT IN ('PENDIENTE')
		AND DESCRIPCION LIKE 'ABONO%'
	)
	SELECT 
		REGION,
		ZONA,
		RPU,
		NUMCREDITO,
		FECHAPAGO,
		REFERENCIA,
		MONTOPAGADO,
		BANCO,
		CASE 
			WHEN (SELECT TOP 1 TIPOCONVENIO FROM CONVENIOS WHERE  REFERENCIA=D.REFERENCIA OR REFERPARCIALIDAD=D.REFERENCIA) IS NOT NULL THEN 'CONVENIO'
			WHEN (SELECT TOP 1 NUMCREDITO FROM SOLICITUDPAGOANTICIPADO WHERE REFERENCIA=D.REFERENCIA) IS NOT NULL THEN 'LIQUIDACION ANTICIPADA'
			WHEN (SELECT TOP 1 NUMCREDITO FROM DBO.EDOCUENTA_REF WHERE REF_BANCARIA=D.REFERENCIA) IS NOT NULL THEN 'REFERENCIA MANUAL'
			ELSE 'NO ENCONTRADO'
		END AS 'TIPO PAGO',
		ESTATUS
	FROM DATOS D
	ORDER BY FECHAPAGO DESC

END
GO