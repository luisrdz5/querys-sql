CREATE PROCEDURE SPOBTENERCREDITOSDETRASPASOS
AS
BEGIN
			update  a
			set a.numcredito=s.numerocredito
			from [SOF_SIRCANAC].[HISTORICO].[ARQUEO] a
			left join SIRCANAC.DBO.solicitudese19 s  on s.estatus ='A'  and s.RpuOriginal = a.RPU
			where a.numcredito='000000000' and s.numerocredito is not null
END

