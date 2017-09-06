function solonl
para cadena

local  a, i, cf

cf=''
a=cadena

lc=len(alltrim(a))

if lc<1
	return ''
endif
for i=1 to lc
	if between(asc(substr(a,i,1)),48,57) or between(asc(substr(a,i,1)),97,122) or between(asc(substr(a,i,1)),65,90) or substr(a,i,1)=' ' or substr(a,i,1)='@' or substr(a,i,1)='.'
		cf=cf+substr(a,i,1)
	endif
endfor
return cf
*********************************
************************************
* Funcion Generar Clave de Acceso de Documents
************************************
FUNCTION genclaveacceso
LPARAMETERS clavexcode
local tmpclavea, numrucemp, tmpclaveb, sumclaveb, codclaveb, digclaveb, dv, veces, dv11, dv12

tmpclavea=""

local tamb
q1="select tipoemi from periodos;"
IF !sqli(q1,'cTipoAmbi') then
	RETURN .f.
ENDIF
select cTipoAmbi
go top
* Tipo de Ambieente de Produccion
tamb=cTipoAmbi.tipoemi
*tamb=1

IF tamb=1 THEN

	local temi
	* Tipo de Emision
	*q1="select 
	temi=1 && Emision Normal
	* temi=2  && Emision Contingencia


	q1="select code, fecha, dtag, serie, num "+;
	" from vdocxml1 "+;
	" where code="+alup(clavexcode)+";"

	IF !sqli(q1,'curclaveacc1') then
		RETURN
	ENDIF

	select code, fecha, dtag, tamb as tipamb, nconcero(6,serie) as serie, ;
		nconcero(9,num) as num, nconcero(8,code) as codinum, ;
		temi as tipemi ;
	 from curclaveacc1 ;
	 into cursor curclaveacc

	select curclaveacc
	go top
	if RecCount("curclaveacc")>0 then
		* fecha
		tmpclavea=tmpclavea+devfeclet(curclaveacc.fecha,8)
		* Tipo Comprobante
		DO Case 
			Case substr(curclaveacc.dtag,1,3)='FAC'
				tmpclavea=tmpclavea+"01"	
			Case substr(curclaveacc.dtag,1,2)='NC'
				tmpclavea=tmpclavea+"04"
			Case substr(curclaveacc.dtag,1,2)='ND'
				tmpclavea=tmpclavea+"05"
			Case substr(curclaveacc.dtag,1,4)='REMI'
				tmpclavea=tmpclavea+"06"
			Case substr(curclaveacc.dtag,1,4)='COMP'
				tmpclavea=tmpclavea+"07"
			otherwise
				tmpclavea=tmpclavea+"00"
		EndCase
		* Numero RUC Empresa
			tmpclavea=tmpclavea+rucemp
		* Tipo Ambiente
			tmpclavea=tmpclavea+alltrim(str(curclaveacc.tipamb))
		* Serie
			tmpclavea=tmpclavea+alltrim((serie))
		* Numero Secuencia
			tmpclavea=tmpclavea+alltrim((curclaveacc.num))
		* Codigo Numerico
			tmpclavea=tmpclavea+"12345678" &&alltrim(str(curclaveacc.codinum))
		* Tipo de Emision
			tmpclavea=tmpclavea+alltrim(str(curclaveacc.tipemi))
		
		* Digito Verificador
		tmpclaveb=" "
		sumclaveb=0
		codclaveb=7
		digclaveb=" "
		veces=0
	*!*		for veces=48 to 1 step -1
	*!*			tmpclaveb=alltrim(tmpclaveb)+substr(tmpclavea,veces,1)
	*!*		endfor
		tmpclaveb=tmpclavea
		veces=0
		for veces=1 to 48
			digclaveb=substr(tmpclaveb,veces,1)
			if codclaveb=1
				codclaveb=7
			endif
			sumclaveb=sumclaveb+(val(digclaveb)*codclaveb)
			codclaveb=codclaveb-1
		endfor
		dv=0
		dv11=0
		dv12=0
		dv=11-dv
		dv11=(sumclaveb/11)-int((sumclaveb/11))
		dv12=dv11*11
		dv=11-dv12
		do case 
			case dv=11
				dv=0
			case dv=10
				dv=1
		endcase
				
		tmpclavea=tmpclavea+alltrim(str(dv))
		
		if used("cTipoAmbi")
			select cTipoAmbi
			use
		endif
		
		if used("curclaveacc")
			select curclaveacc
			use
		endif
		
		if used("curclaveacc1")
			select curclaveacc1
			use
		endif

		if used("empr")
			select empr
			use
		endif
		
		return 	tmpclavea
		
	else
		Messagebox("No Existe CODE",0+64,"SISCON")
		tmpclavea=""
		return .f.
	endif
ELSE
	* 	Clave de Contingencia
	q1="select clave from facelec_k where code=0 order by clave limit 1;"
	IF !sqli(q1,'cClaveConti') then
		RETURN .f.
	ENDIF

	If RecCount('cClaveConti')>0 then
		Select cClaveConti.clave
		go top
		tmpclavea=cClaveConti.clave
		return 	tmpclavea
	endif
ENDIF
ENDFUNC

************************************
* Funcion Generar Clave de Acceso de Retenciones
************************************
FUNCTION genclaveaccesoret
LPARAMETERS clavexcode
local tmpclavea, numrucemp, tmpclaveb, sumclaveb, codclaveb, digclaveb, dv, veces, dv11, dv12

tmpclavea=""

local tamb
q1="select tipoemi from periodos;"
IF !sqli(q1,'cTipoAmbi') then
	RETURN
ENDIF
select cTipoAmbi
go top
* Tipo de Ambieente de Produccion
tamb=cTipoAmbi.tipoemi
*tamb=1

IF tamb=1 THEN

	local temi
	* Tipo de Emision
	*q1="select 
	temi=1 && Emision Normal
	* temi=2  && Emision Contingencia


	q1="select code, fecha, 'COMPRETE' as dtag, serieret as serie, secueret as num "+;
	" from vdocxml2 "+;
	" where code="+alup(clavexcode)+";"


	IF !sqli(q1,'curclaveacc1') then
		RETURN
	ENDIF

	select code, fecha, dtag, tamb as tipamb, nconcero(6,serie) as serie, ;
		nconcero(9,num) as num, nconcero(8,code) as codinum, ;
		temi as tipemi ;
	 from curclaveacc1 ;
	 into cursor curclaveacc


	select curclaveacc
	go top
	if RecCount("curclaveacc")>0 then
		* fecha
		tmpclavea=tmpclavea+devfeclet(curclaveacc.fecha,8)
		* Tipo Comprobante
*!*			DO Case 
*!*				Case substr(curclaveacc.dtag,1,4)='FACT'
*!*					tmpclavea=tmpclavea+"01"	
*!*				Case substr(curclaveacc.dtag,1,4)='NC'
*!*					tmpclavea=tmpclavea+"04"
*!*				Case substr(curclaveacc.dtag,1,4)='ND'
*!*					tmpclavea=tmpclavea+"05"
*!*				Case substr(curclaveacc.dtag,1,4)='REMISION'
*!*					tmpclavea=tmpclavea+"06"
*!*				Case substr(curclaveacc.dtag,1,4)='COMPRETE'
				tmpclavea=tmpclavea+"07"
*!*			EndCase
		* Numero RUC Empresa
			tmpclavea=tmpclavea+rucemp
		* Tipo Ambiente
			tmpclavea=tmpclavea+alltrim(str(curclaveacc.tipamb))
		* Serie
			tmpclavea=tmpclavea+alltrim((serie))
		* Numero Secuencia
			tmpclavea=tmpclavea+alltrim((curclaveacc.num))
		* Codigo Numerico
			tmpclavea=tmpclavea+"12345678" &&alltrim(str(curclaveacc.codinum))
		* Tipo de Emision
			tmpclavea=tmpclavea+alltrim(str(curclaveacc.tipemi))
		
		* Digito Verificador
		tmpclaveb=" "
		sumclaveb=0
		codclaveb=7
		digclaveb=" "
		veces=0
	*!*		for veces=48 to 1 step -1
	*!*			tmpclaveb=alltrim(tmpclaveb)+substr(tmpclavea,veces,1)
	*!*		endfor
		tmpclaveb=tmpclavea
		veces=0
		for veces=1 to 48
			digclaveb=substr(tmpclaveb,veces,1)
			if codclaveb=1
				codclaveb=7
			endif
			sumclaveb=sumclaveb+(val(digclaveb)*codclaveb)
			codclaveb=codclaveb-1
		endfor
		dv=0
		dv11=0
		dv12=0
		dv=11-dv
		dv11=(sumclaveb/11)-int((sumclaveb/11))
		dv12=dv11*11
		dv=11-dv12
		do case 
			case dv=11
				dv=0
			case dv=10
				dv=1
		endcase

		tmpclavea=tmpclavea+alltrim(str(dv))
		
		if used("cTipoAmbi")
			select cTipoAmbi
			use
		endif
		
		if used("curclaveacc")
			select curclaveacc
			use
		endif
		
		if used("curclaveacc1")
			select curclaveacc1
			use
		endif

		if used("empr")
			select empr
			use
		endif
		
		return 	tmpclavea
		
	else
		Messagebox("No Existe CODE",0+64,"SISCON")
		tmpclavea=""
		return .f.
	endif
ELSE
	* 	Clave de Contingencia
	q1="select clave from facelec_k where code=0 order by clave limit 1;"
	IF !sqli(q1,'cClaveConti') then
		RETURN
	ENDIF

	If RecCount('cClaveConti')>0 then
		Select cClaveConti.clave
		go top
		tmpclavea=cClaveConti.clave
		return 	tmpclavea
	endif
ENDIF
ENDFUNC

*************************
** Factura Electronica
*************************
FUNCTION genxmlfac
LPARAMETERS xgencode

LOCAL lnFile, cFILE, xmlclavacc 

CREATE CURSOR encxml (code n(10), ;
	ambiente n(1),;
	emision n(1),;
	clavacc c(50),;
	coddoc c(2),;
	estab c(3),;
	ptoemi c(3),;
	secuen c(10),;
	dirmat c(250),;
	fecemi d(8),;
	direstab c(250),;
	conespec c(5),;
	obligcnt c(2),;
	tiposuj c(2),;
	gremisi c(15),;
	rsocial c(250),;
	numidec c(13),;
	subtot n(10,2),;
	tdescu n(10,2),;
	impcod1 n(1),;
	impporc1 n(1),;
	impbasi1 n(10,2),;
	impval1 n(10,2),;
	impcod2 n(1),;
	impporc2 n(1),;
	impbasi2 n(10,2),;
	impval2 n(10,2),;
	icecod n(1),;
	icepor n(1),;
	icebasi n(10,2),;
	iceval n(10,2),;
	propina n(10,2),;
	impototal n(10,2),;
	moneda c(15),;
	stelf c(10),;
	dirsuj c(250),;
	emailsuj c(250) )

CREATE CURSOR detxml (code n(10),;
	codpri n(10),;
	codaux n(10),;
	descrip c(250),;
	canti n(18,6),;
	punit n(10,2),;
	descu n(10,2),;
	precimp n(10,2),;
	impcod n(1),;
	imppor n(1),;
	imptarf n(2),;
	impbase n(10,2),;
	impval n(10,2),;
	icecod n(1),;
	icepor n(1),;
	icetarf n(2),;
	icebasi n(10,2),;
	iceval n(10,2) )
	
CREATE CURSOR retxml (code n(10),;
	codret n(2),;
	codpor n(2),;
	codtarf n(2),;
	valor N(10,2) )

q1="select * from periodos;"
if !sqli(q1,'empperi') then
	return
endif

select empperi
go top


q1="select distinct sruc, ssri, stelf, sfax, smail::char(60), saddr, siderepleg, srepleg, sruccontador, nrores, numestb from empresas ;"

if !sqli(q1,'rucempre') then
	return
endif

select 	substr(sruc,1,13) as sruc, ;
		substr(ssri,1,60) as ssri, ;
		nconcero(9,stelf) as stelf, ;
		nconcero(9,sfax) as sfax, ;
		substr(smail,1,60) as smail1, ;
		substr(saddr,1,60) as saddr, ;
		substr(siderepleg,1,1) as siderepleg, ;
		substr(srepleg,1,13) as srepleg, ;
		nconcero(3,numestb) as numestb, ;
		nrores, ;
		substr(sruccontador,1,13) as sruccontador ;
	from rucempre into cursor empresas
	
	
cFILE="FACELE_"+alltrim(str(xgencode))+".xml"

xmlclavacc = genclaveacceso(xgencode)

** Llenado Cursor Encabezado XML
q1="select * from vdocxml1 where code="+alup(xgencode)+";"
IF !sqli(q1,'curxmle') then
	RETURN
ENDIF

SELECT curxmle
GO top
SCAN
	SELECT encxml 
	APPEND BLANK

	Replace encxml.code 	WITH xgencode
	Replace encxml.ambiente WITH curxmle.tipoambi    && 1 pruebas 2 produccion
	Replace encxml.emision 	WITH empperi.tipoemi   && 1 emision normal   2 indiponiblidad del sistema
	Replace encxml.clavacc 	WITH xmlclavacc  && generar clave de acceso 
	Replace encxml.coddoc 	WITH "01"  && 01 fact 04 nc   05  nd  06 gremision 07  retencion
	Replace encxml.estab 	WITH SUBSTR(nconcero(6,curxmle.serie),1,3)
	Replace encxml.ptoemi 	WITH SUBSTR(nconcero(6,curxmle.serie),4,3)
	Replace encxml.secuen 	WITH nconcero(9,curxmle.num)
	*Replace encxml.dirmat 	WITH curxmle.
	Replace encxml.fecemi 	WITH curxmle.fecha
	*Replace encxml.direstab WITH curxmle.
	
	Replace encxml.conespec WITH nconcero(5,empresas.nrores)   && debemos almacenar en datos de la empresa
	Replace encxml.obligcnt WITH "SI" && debemos almacenar en datos de la empresa obligcnt
	Replace encxml.tiposuj 	WITH IIF(ALLTRIM(curxmle.sname)="CONSUMIDOR FINAL","07",IIF(LEN(ALLTRIM(curxmle.sruc))=13,"04",IIF(LEN(ALLTRIM(curxmle.scedula))=10,"05","06")))
*	Replace encxml.gremisi 	WITH curxmle.
	Replace encxml.rsocial 	WITH ALLTRIM(solonl(curxmle.sname))
	Replace encxml.numidec 	WITH IIF(ALLTRIM(curxmle.sname)="CONSUMIDOR FINAL","9999999999999",IIF(LEN(ALLTRIM(curxmle.sruc))=13,ALLTRIM(curxmle.sruc),IIF(LEN(ALLTRIM(curxmle.scedula))=10,ALLTRIM(curxmle.scedula),ALLTRIM(curxmle.spasaporte))))
	Replace encxml.dirsuj   WITH ALLTRIM(solonl(curxmle.saddr))
	Replace encxml.emailsuj WITH iif(isnull(curxmle.smail) or len(alltrim(curxmle.smail))=0,LOWER(ALLTRIM(empresas.smail1)),LOWER(ALLTRIM(curxmle.smail)) )
	Replace encxml.subtot 	WITH curxmle.subtotal
	Replace encxml.tdescu 	WITH curxmle.descuconiva+curxmle.descusiniva

	Replace encxml.impcod1 	WITH 2 && Codigo de IVA
	Replace encxml.impporc1	WITH 2  && cod 0 para 0%  y cod 2 para 12%   codigo 6 para no objeto de impuesto
	Replace encxml.impbasi1	WITH curxmle.subconiva
	Replace encxml.impval1 	WITH curxmle.ivavalor
	
	Replace encxml.impcod2 	WITH 2
	Replace encxml.impporc2	WITH 0 && cod 0 para 0%  y cod 2 para 12%   codigo 6 para no objeto de impuesto
	Replace encxml.impbasi2	WITH curxmle.subsiniva
	Replace encxml.impval2	WITH 0


	IF curxmle.icevalor>0.00 then
		Replace encxml.icecod 	WITH 0
		Replace encxml.icepor 	WITH 0
		Replace encxml.icebasi 	WITH 0
		Replace encxml.iceval 	WITH 0
	ELSE
		Replace encxml.icecod 	WITH 0
		Replace encxml.icepor 	WITH 0
		Replace encxml.icebasi 	WITH 0
		Replace encxml.iceval 	WITH 0
	endif	
	Replace encxml.propina 	WITH 0.00
	Replace encxml.impototal WITH curxmle.montototal
	Replace encxml.moneda 	WITH "DOLAR"
	Replace encxml.stelf 	WITH iif(len(alltrim(curxmle.stelf))=0,iif(len(alltrim(curxmle.scel))=0,empresas.stelf,curxmle.scel),curxmle.stelf)

	SELECT curxmle

ENDSCAN

** llenado de Cursor de Detalle de XML
q1="select * from vdocui where code="+alup(xgencode)+";"
IF !sqli(q1,'curxmld') then
	RETURN
ENDIF

SELECT curxmld
GO top
SCAN
	SELECT detxml 
	APPEND BLANK
	
	Replace detxml.code 	WITH xgencode
	Replace detxml.codpri 	WITH curxmld.iditem
	Replace detxml.codaux 	WITH curxmld.icode
	Replace detxml.descrip 	WITH curxmld.iname
	Replace detxml.canti 	WITH curxmld.qty
	Replace detxml.punit 	WITH curxmld.punitario
	Replace detxml.descu 	WITH curxmld.descuento
	Replace detxml.precimp 	WITH curxmld.valconiva
	IF curxmld.isiva=.t. THEN
		Replace detxml.impcod 	WITH 2 && Codigo de IVA
		Replace detxml.imppor 	WITH 2  && cod 0 para 0%  y cod 2 para 12%   codigo 6 para no objeto de impuesto
		Replace detxml.imptarf 	WITH 12  
		Replace detxml.impbase 	WITH curxmld.subtot
		Replace detxml.impval 	WITH curxmld.valconiva
	ELSE
		Replace detxml.impcod 	WITH 2 && Codigo de IVA
		Replace detxml.imppor 	WITH 0  && cod 0 para 0%  y cod 2 para 12%   codigo 6 para no objeto de impuesto
		Replace detxml.imptarf 	WITH 0  
		Replace detxml.impbase 	WITH curxmld.subtot
		Replace detxml.impval 	WITH 0.00
	endif
	Replace detxml.icecod 	WITH 0
	Replace detxml.icepor 	WITH 0
	Replace detxml.icetarf 	WITH 0
	Replace detxml.icebasi 	WITH 0
	Replace detxml.iceval	WITH 0
	
	SELECT curxmld
	
ENDSCAN

lnFile=FCreate(cFILE)
If lnFile<0
	fClose(lnFile)
	lnFile=FCreate(cFILE)
	If lnFile<0
		Messagebox("Error al Crear Archivo XML",0,empresa)
		Return(.f.)
	EndIf	
EndIf
*fputs(lnFile,'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>')
fputs(lnFile,'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
fputs(lnFile,'<factura id="comprobante" version="1.0.0">')
fputs(lnFile,"	<infoTributaria>")
fputs(lnFile,"		<ambiente>"+alltrim(str(encxml.ambiente,5,0))+"</ambiente>")																	&&
fputs(lnFile,"		<tipoEmision>"+alltrim(str(encxml.emision,5,0))+"</tipoEmision>")																&&
fputs(lnFile,"		<razonSocial>"+alltrim(empresas.ssri)+"</razonSocial>")
fputs(lnFile,"		<nombreComercial>"+alltrim(empresas.ssri)+"</nombreComercial>")
fputs(lnFile,"		<ruc>"+alltrim(empresas.sruc)+"</ruc>")
fputs(lnFile,"		<claveAcceso>"+alltrim(encxml.clavacc)+"</claveAcceso>")			
fputs(lnFile,"		<codDoc>"+alltrim(encxml.coddoc)+"</codDoc>") 
fputs(lnFile,"		<estab>"+alltrim(encxml.estab)+"</estab>") 
fputs(lnFile,"		<ptoEmi>"+alltrim(encxml.ptoemi)+"</ptoEmi>") 
fputs(lnFile,"		<secuencial>"+alltrim(encxml.secuen)+"</secuencial>") 
fputs(lnFile,"		<dirMatriz>"+alltrim(empresas.saddr)+"</dirMatriz>")
fputs(lnFile,"	</infoTributaria>")
fputs(lnFile,"    <infoFactura>")
fputs(lnFile,"    	<fechaEmision>"+devfeclet(encxml.fecemi,7)+"</fechaEmision>")
fputs(lnFile,"    	<dirEstablecimiento>"+alltrim(empresas.saddr)+"</dirEstablecimiento>")
fputs(lnFile,"    	<contribuyenteEspecial>"+alltrim(empresas.nrores)+"</contribuyenteEspecial>")
fputs(lnFile,"    	<obligadoContabilidad>"+alltrim(encxml.obligcnt)+"</obligadoContabilidad>")   
fputs(lnFile,"    	<tipoIdentificacionComprador>"+alltrim(encxml.tiposuj)+"</tipoIdentificacionComprador>")  &&&
fputs(lnFile,"    	<razonSocialComprador>"+alltrim(encxml.rsocial)+"</razonSocialComprador>")
fputs(lnFile,"    	<identificacionComprador>"+alltrim(encxml.numidec)+"</identificacionComprador>")
fputs(lnFile,"    	<totalSinImpuestos>"+alltrim(STR(encxml.subtot,10,2))+"</totalSinImpuestos>")
fputs(lnFile,"    	<totalDescuento>"+alltrim(STR(encxml.tdescu,10,2))+"</totalDescuento>")
fputs(lnFile,"    	<totalConImpuestos>")
IF encxml.impbasi1>0 then
	fputs(lnFile,"	    	<totalImpuesto>")
	fputs(lnFile,"	    		<codigo>"+ALLTRIM(STR(encxml.impcod1,5,0))+"</codigo>")
	fputs(lnFile,"	    		<codigoPorcentaje>"+ALLTRIM(STR(encxml.impporc1,5,0))+"</codigoPorcentaje>")
	fputs(lnFile,"	    		<baseImponible>"+ALLTRIM(STR(encxml.impbasi1,10,2))+"</baseImponible>")
	fputs(lnFile,"	    		<valor>"+ALLTRIM(STR(encxml.impval1,10,2))+"</valor>")
	fputs(lnFile,"	    	</totalImpuesto>")
ENDIF
IF encxml.impbasi2>0 then
	fputs(lnFile,"	    	<totalImpuesto>")
	fputs(lnFile,"	    		<codigo>"+ALLTRIM(STR(encxml.impcod2,5,0))+"</codigo>")
	fputs(lnFile,"	    		<codigoPorcentaje>"+ALLTRIM(STR(encxml.impporc2,5,0))+"</codigoPorcentaje>")
	fputs(lnFile,"	    		<baseImponible>"+ALLTRIM(STR(encxml.impbasi2,10,2))+"</baseImponible>")
	fputs(lnFile,"	    		<valor>"+ALLTRIM(STR(encxml.impval2,10,2))+"</valor>")
	fputs(lnFile,"	    	</totalImpuesto>")
ENDIF
fputs(lnFile,"    	</totalConImpuestos>")
fputs(lnFile,"    	<propina>0.00</propina>")
fputs(lnFile,"    	<importeTotal>"+ALLTRIM(STR(encxml.impototal,10,2))+"</importeTotal>")
fputs(lnFile,"    	<moneda>DOLAR</moneda>")
fputs(lnFile,"   	</infoFactura>")
fputs(lnFile,"   	<detalles>")
SELECT detxml
GO top
SCAN
fputs(lnFile,"   		<detalle>")
fputs(lnFile,"   			<codigoPrincipal>"+ALLTRIM(STR(detxml.codpri,10,0))+"</codigoPrincipal>")
fputs(lnFile,"   			<codigoAuxiliar>"+ALLTRIM(STR(detxml.codaux,10,0))+"</codigoAuxiliar>")
fputs(lnFile,"   			<descripcion>"+ALLTRIM(detxml.descrip)+"</descripcion>")
fputs(lnFile,"   			<cantidad>"+ALLTRIM(STR(detxml.canti,10,2))+"</cantidad>")
fputs(lnFile,"   			<precioUnitario>"+ALLTRIM(STR(detxml.punit,10,2))+"</precioUnitario>")
fputs(lnFile,"   			<descuento>"+ALLTRIM(STR(detxml.descu,10,2))+"</descuento>")
fputs(lnFile,"   			<precioTotalSinImpuesto>"+ALLTRIM(STR(detxml.impbase,10,2))+"</precioTotalSinImpuesto>")
fputs(lnFile,"   			<impuestos>")
fputs(lnFile,"   				<impuesto>")
fputs(lnFile,"   					<codigo>"+ALLTRIM(STR(detxml.impcod,5,0))+"</codigo>")
fputs(lnFile,"   					<codigoPorcentaje>"+ALLTRIM(STR(detxml.imppor,5,0))+"</codigoPorcentaje>")
fputs(lnFile,"   					<tarifa>"+ALLTRIM(STR(detxml.imptarf,10,2))+"</tarifa>")
fputs(lnFile,"   					<baseImponible>"+ALLTRIM(STR(detxml.impbase,10,2))+"</baseImponible>")
fputs(lnFile,"   					<valor>"+ALLTRIM(STR(detxml.impval,10,2))+"</valor>")
fputs(lnFile,"   				</impuesto>")
fputs(lnFile,"   			</impuestos>")
fputs(lnFile,"   		</detalle>")
ENDSCAN
fputs(lnFile,"   	</detalles>")
fputs(lnFile,"<infoAdicional>")
fputs(lnFile,'    <campoAdicional nombre="Direccion">'+alltrim(encxml.dirsuj)+'</campoAdicional>')
fputs(lnFile,'<campoAdicional nombre="Telefono">'+alltrim(encxml.stelf)+'</campoAdicional>')
fputs(lnFile,'<campoAdicional nombre="Email">'+alltrim(encxml.emailsuj)+'</campoAdicional>')
fputs(lnFile,'</infoAdicional>')
fputs(lnFile,"</factura>")
fClose(lnFile)
Wait Window "Creando Archivo de Factura Electronica XML......." NoWait 

if used("encxml")
	select encxml
	use
endif
if used("detxml")
	select detxml
	use
endif
if used("retxml")
	select retxml
	use
endif
if used("rucempre")
	select rucempre
	use
endif
if used("empresas")
	select empresas
	use
endif
if used("curxmld")
	select curxmld
	use
endif
if used("curxmle")
	select curxmle
	use
endif
if used("empr")
	select empr
	use
endif
if used("cClaveConti")
	select cClaveConti
	use
endif
if used("empperi")
	select empperi
	use
endif


RETURN .t.

ENDFUNC


***********************************************
*	REGISTRO DE ERRORES ODBC
***********************************************
procedure regerrfe
local cm
if used('errorfe') then
	sele errorfe
else
	sele 0
	use errorfe  share
endif
appen blank
e=sys(2018)
replace user 		with usuario
replace fecha   	with datetime()
replace code 		with faceletmp.code
*replace docele 		with ""
replace nivelerr 	with eNivelerr
replace descrip1	with cfdi_error(h)
replace claacce		with lclaveacceso
return


******************
* Generacion de Documento Nota de Credito Cliente
******************
FUNCTION genxmlncc
LPARAMETERS xgencode

LOCAL lnFile, cFILE, xmlclavacc 
CREATE CURSOR encxml (code n(10), ;
	ambiente n(1),;
	emision n(1),;
	clavacc c(50),;
	coddoc c(2),;
	estab c(3),;
	ptoemi c(3),;
	secuen c(10),;
	dirmat c(250),;
	fecemi d(8),;
	direstab c(250),;
	conespec c(5),;
	obligcnt c(2),;
	tiposuj c(2),;
	gremisi c(15),;
	rsocial c(250),;
	numidec c(13),;
	subtot n(10,2),;
	tdescu n(10,2),;
	impcod1 n(1),;
	impporc1 n(1),;
	impbasi1 n(10,2),;
	impval1 n(10,2),;
	impcod2 n(1),;
	impporc2 n(1),;
	impbasi2 n(10,2),;
	impval2 n(10,2),;
	icecod n(1),;
	icepor n(1),;
	icebasi n(10,2),;
	iceval n(10,2),;
	propina n(10,2),;
	impototal n(10,2),;
	moneda c(15),;
	dirsuj c(250),;
	emailsuj c(250),;
	stelf c(10),;
	mcoddoc c(2),;
	mnumdoc c(20),;
	mfecha d(8),;
	motivo c(30) )

CREATE CURSOR detxml (code n(10),;
	codpri n(10),;
	codaux n(10),;
	descrip c(250),;
	canti n(18,6),;
	punit n(10,2),;
	descu n(10,2),;
	precimp n(10,2),;
	impcod n(1),;
	imppor n(1),;
	imptarf n(2),;
	impbase n(10,2),;
	impval n(10,2),;
	icecod n(1),;
	icepor n(1),;
	icetarf n(2),;
	icebasi n(10,2),;
	iceval n(10,2) )
	

q1="select * from periodos;"
if !sqli(q1,'empperi') then
	return
endif

select empperi
go top

q1="select distinct sruc, ssri, stelf, sfax, smail::char(60), saddr, siderepleg, srepleg, sruccontador, nrores, numestb from empresas ;"

if !sqli(q1,'rucempre') then
	return
endif

select 	substr(sruc,1,13) as sruc, ;
		substr(ssri,1,60) as ssri, ;
		nconcero(9,stelf) as stelf, ;
		nconcero(9,sfax) as sfax, ;
		substr(smail,1,60) as smail1, ;
		substr(saddr,1,60) as saddr, ;
		substr(siderepleg,1,1) as siderepleg, ;
		substr(srepleg,1,13) as srepleg, ;
		nconcero(3,numestb) as numestb, ;
		nrores, ;
		substr(sruccontador,1,13) as sruccontador ;
	from rucempre into cursor empresas
	
	
cFILE="NCCELE_"+alltrim(str(xgencode))+".xml"

xmlclavacc = genclaveacceso(xgencode)

** Llenado Cursor Encabezado XML
q1="select d.*, a.idtipdoc, a.numserie2, a.numsecue2, a.fecha2, "+;
"to_char((c.codigo::int2)::int4,'FM09') as docmodificado "+;
"from vdocxml1 d left join  aneiva a on (d.code=a.code) "+;
"left join sritabla c on (a.idtipdoc=c.idsritabla) "+;
"where d.code="+alup(xgencode)+";"

IF !sqli(q1,'curxmle') then
	RETURN
ENDIF

SELECT curxmle
GO top
SCAN
	SELECT encxml 
	APPEND BLANK

	Replace encxml.code 	WITH xgencode
	Replace encxml.ambiente WITH curxmle.tipoambi    && 1 pruebas 2 produccion
	Replace encxml.emision 	WITH empperi.tipoemi   && 1 emision normal   2 indiponiblidad del sistema
	Replace encxml.clavacc 	WITH xmlclavacc  && generar clave de acceso 
	Replace encxml.coddoc 	WITH "04"  && 01 fact 04 nc   05  nd  06 gremision 07  retencion
	Replace encxml.estab 	WITH SUBSTR(nconcero(6,curxmle.serie),1,3)
	Replace encxml.ptoemi 	WITH SUBSTR(nconcero(6,curxmle.serie),4,3)
	Replace encxml.secuen 	WITH nconcero(9,curxmle.num)
	*Replace encxml.dirmat 	WITH curxmle.
	Replace encxml.fecemi 	WITH curxmle.fecha
	*Replace encxml.direstab WITH curxmle.
	
	Replace encxml.conespec WITH nconcero(5,empresas.nrores)  && debemos almacenar en datos de la empresa
	Replace encxml.obligcnt WITH "SI" && debemos almacenar en datos de la empresa obligcnt
	Replace encxml.tiposuj 	WITH IIF(ALLTRIM(curxmle.sname)="CONSUMIDOR FINAL","07",IIF(LEN(ALLTRIM(curxmle.sruc))=13,"04",IIF(LEN(ALLTRIM(curxmle.scedula))=10,"05","06")))
*	Replace encxml.gremisi 	WITH curxmle.
	Replace encxml.rsocial 	WITH ALLTRIM(solonl(curxmle.sname))
	Replace encxml.numidec 	WITH IIF(ALLTRIM(curxmle.sname)="CONSUMIDOR FINAL","9999999999999",IIF(LEN(ALLTRIM(curxmle.sruc))=13,ALLTRIM(curxmle.sruc),IIF(LEN(ALLTRIM(curxmle.scedula))=10,ALLTRIM(curxmle.scedula),ALLTRIM(curxmle.spasaporte))))
	Replace encxml.dirsuj   WITH ALLTRIM(solonl(curxmle.saddr))
	Replace encxml.emailsuj WITH iif(isnull(curxmle.smail) or len(alltrim(curxmle.smail))=0,LOWER(ALLTRIM(empresas.smail1)),LOWER(ALLTRIM(curxmle.smail)) )
	Replace encxml.subtot 	WITH curxmle.subtotal
	Replace encxml.tdescu 	WITH curxmle.descuconiva+curxmle.descusiniva

	Replace encxml.impcod1 	WITH 2 && Codigo de IVA
	Replace encxml.impporc1	WITH 2  && cod 0 para 0%  y cod 2 para 12%   codigo 6 para no objeto de impuesto
	Replace encxml.impbasi1	WITH curxmle.subconiva
	Replace encxml.impval1 	WITH curxmle.ivavalor
	
	Replace encxml.impcod2 	WITH 2
	Replace encxml.impporc2	WITH 0 && cod 0 para 0%  y cod 2 para 12%   codigo 6 para no objeto de impuesto
	Replace encxml.impbasi2	WITH curxmle.subsiniva
	Replace encxml.impval2	WITH 0


	IF curxmle.icevalor>0.00 then
		Replace encxml.icecod 	WITH 0
		Replace encxml.icepor 	WITH 0
		Replace encxml.icebasi 	WITH 0
		Replace encxml.iceval 	WITH 0
	ELSE
		Replace encxml.icecod 	WITH 0
		Replace encxml.icepor 	WITH 0
		Replace encxml.icebasi 	WITH 0
		Replace encxml.iceval 	WITH 0
	endif	
	Replace encxml.propina 	WITH 0.00
	Replace encxml.impototal WITH curxmle.montototal
	Replace encxml.moneda 	WITH "DOLAR"
	Replace encxml.mcoddoc 	WITH curxmle.docmodificado
	Replace encxml.mnumdoc 	WITH SUBSTR(nconcero(6,curxmle.numserie2),1,3)+"-"+SUBSTR(nconcero(6,curxmle.numserie2),4,3)+"-"+nconcero(9,curxmle.numsecue2)
	Replace encxml.mfecha 	WITH curxmle.fecha2
	Replace encxml.motivo 	WITH substr(curxmle.concepto,1,30)
	Replace encxml.stelf 	WITH iif(len(alltrim(curxmle.stelf))=0,iif(len(alltrim(curxmle.scel))=0,empresas.stelf,curxmle.scel),curxmle.stelf)


	SELECT curxmle

ENDSCAN

** llenado de Cursor de Detalle de XML
q1="select * from vdocui where code="+alup(xgencode)+";"
IF !sqli(q1,'curxmld') then
	RETURN
ENDIF

SELECT curxmld
GO top
SCAN
	SELECT detxml 
	APPEND BLANK
	
	Replace detxml.code 	WITH xgencode
	Replace detxml.codpri 	WITH curxmld.iditem
	Replace detxml.codaux 	WITH curxmld.icode
	Replace detxml.descrip 	WITH curxmld.iname
	Replace detxml.canti 	WITH curxmld.qty
	Replace detxml.punit 	WITH curxmld.punitario
	Replace detxml.descu 	WITH curxmld.descuento
	Replace detxml.precimp 	WITH curxmld.valconiva
	IF curxmld.isiva=.t. THEN
		Replace detxml.impcod 	WITH 2 && Codigo de IVA
		Replace detxml.imppor 	WITH 2  && cod 0 para 0%  y cod 2 para 12%   codigo 6 para no objeto de impuesto
		Replace detxml.imptarf 	WITH 12  
		Replace detxml.impbase 	WITH curxmld.subtot
		Replace detxml.impval 	WITH curxmld.valconiva
	ELSE
		Replace detxml.impcod 	WITH 2 && Codigo de IVA
		Replace detxml.imppor 	WITH 0  && cod 0 para 0%  y cod 2 para 12%   codigo 6 para no objeto de impuesto
		Replace detxml.imptarf 	WITH 0  
		Replace detxml.impbase 	WITH curxmld.subtot
		Replace detxml.impval 	WITH 0.00
	endif
	Replace detxml.icecod 	WITH 0
	Replace detxml.icepor 	WITH 0
	Replace detxml.icetarf 	WITH 0
	Replace detxml.icebasi 	WITH 0
	Replace detxml.iceval	WITH 0
	
	SELECT curxmld
	
ENDSCAN

lnFile=FCreate(cFILE)
If lnFile<0
	fClose(lnFile)
	lnFile=FCreate(cFILE)
	If lnFile<0
		Messagebox("Error al Crear Archivo XML",0,empresa)
		Return(.f.)
	EndIf	
EndIf
fputs(lnFile,'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
fputs(lnFile,'<notaCredito id="comprobante" version="1.0.0">')
fputs(lnFile,"	<infoTributaria>")
fputs(lnFile,"		<ambiente>"+alltrim(str(encxml.ambiente))+"</ambiente>")																	&&
fputs(lnFile,"		<tipoEmision>"+alltrim(str(encxml.emision))+"</tipoEmision>")																&&
fputs(lnFile,"		<razonSocial>"+alltrim(empresas.ssri)+"</razonSocial>")
fputs(lnFile,"		<nombreComercial>"+alltrim(empresas.ssri)+"</nombreComercial>")
fputs(lnFile,"		<ruc>"+alltrim(empresas.sruc)+"</ruc>")
fputs(lnFile,"		<claveAcceso>"+alltrim(encxml.clavacc)+"</claveAcceso>")			
fputs(lnFile,"		<codDoc>"+alltrim(encxml.coddoc)+"</codDoc>") 
fputs(lnFile,"		<estab>"+alltrim(encxml.estab)+"</estab>") 
fputs(lnFile,"		<ptoEmi>"+alltrim(encxml.ptoemi)+"</ptoEmi>") 
fputs(lnFile,"		<secuencial>"+alltrim(encxml.secuen)+"</secuencial>") 
fputs(lnFile,"		<dirMatriz>"+alltrim(empresas.saddr)+"</dirMatriz>")
fputs(lnFile,"	</infoTributaria>")
fputs(lnFile,"    <infoNotaCredito>")
fputs(lnFile,"    	<fechaEmision>"+devfeclet(encxml.fecemi,7)+"</fechaEmision>")
fputs(lnFile,"    	<dirEstablecimiento>"+alltrim(empresas.saddr)+"</dirEstablecimiento>")
fputs(lnFile,"    	<tipoIdentificacionComprador>"+alltrim(encxml.tiposuj)+"</tipoIdentificacionComprador>")  &&&
fputs(lnFile,"    	<razonSocialComprador>"+alltrim(encxml.rsocial)+"</razonSocialComprador>")
fputs(lnFile,"    	<identificacionComprador>"+alltrim(encxml.numidec)+"</identificacionComprador>")
fputs(lnFile,"    	<contribuyenteEspecial>"+alltrim(empresas.nrores)+"</contribuyenteEspecial>")
fputs(lnFile,"    	<obligadoContabilidad>"+alltrim(encxml.obligcnt)+"</obligadoContabilidad>")   
fputs(lnFile,"    	<codDocModificado>"+alltrim(encxml.mcoddoc)+"</codDocModificado>")
fputs(lnFile,"    	<numDocModificado>"+alltrim(encxml.mnumdoc)+"</numDocModificado>")
fputs(lnFile,"    	<fechaEmisionDocSustento>"+devfeclet(encxml.mfecha,7)+"</fechaEmisionDocSustento>")
fputs(lnFile,"    	<totalSinImpuestos>"+alltrim(STR(encxml.subtot,10,2))+"</totalSinImpuestos>")
fputs(lnFile,"    	<valorModificacion>"+alltrim(STR(encxml.impototal,10,2))+"</valorModificacion>")
fputs(lnFile,"    	<moneda>DOLAR</moneda>")
fputs(lnFile,"    	<totalConImpuestos>")
IF encxml.impbasi1>0 then
	fputs(lnFile,"	    	<totalImpuesto>")
	fputs(lnFile,"	    		<codigo>"+ALLTRIM(STR(encxml.impcod1,5,0))+"</codigo>")
	fputs(lnFile,"	    		<codigoPorcentaje>"+ALLTRIM(STR(encxml.impporc1,5,0))+"</codigoPorcentaje>")
	fputs(lnFile,"	    		<baseImponible>"+ALLTRIM(STR(encxml.impbasi1,10,2))+"</baseImponible>")
	fputs(lnFile,"	    		<valor>"+ALLTRIM(STR(encxml.impval1,10,2))+"</valor>")
	fputs(lnFile,"	    	</totalImpuesto>")
ENDIF
IF encxml.impbasi2>0 then
	fputs(lnFile,"	    	<totalImpuesto>")
	fputs(lnFile,"	    		<codigo>"+ALLTRIM(STR(encxml.impcod2,5,0))+"</codigo>")
	fputs(lnFile,"	    		<codigoPorcentaje>"+ALLTRIM(STR(encxml.impporc2,5,0))+"</codigoPorcentaje>")
	fputs(lnFile,"	    		<baseImponible>"+ALLTRIM(STR(encxml.impbasi2,10,2))+"</baseImponible>")
	fputs(lnFile,"	    		<valor>"+ALLTRIM(STR(encxml.impval2,10,2))+"</valor>")
	fputs(lnFile,"	    	</totalImpuesto>")
ENDIF
fputs(lnFile,"    	</totalConImpuestos>")
fputs(lnFile,"    	<motivo>"+ALLTRIM(encxml.motivo)+"</motivo>")
fputs(lnFile,"   	</infoNotaCredito>")
fputs(lnFile,"   	<detalles>")
SELECT detxml
GO top
SCAN
fputs(lnFile,"   		<detalle>")
fputs(lnFile,"   			<codigoInterno>"+ALLTRIM(STR(detxml.codpri,10,0))+"</codigoInterno>")
fputs(lnFile,"   			<codigoAdicional>"+ALLTRIM(STR(detxml.codaux,10,0))+"</codigoAdicional>")
fputs(lnFile,"   			<descripcion>"+ALLTRIM(detxml.descrip)+"</descripcion>")
fputs(lnFile,"   			<cantidad>"+ALLTRIM(STR(detxml.canti,10,2))+"</cantidad>")
fputs(lnFile,"   			<precioUnitario>"+ALLTRIM(STR(detxml.punit,10,2))+"</precioUnitario>")
fputs(lnFile,"   			<descuento>"+ALLTRIM(STR(detxml.descu,10,2))+"</descuento>")
fputs(lnFile,"   			<precioTotalSinImpuesto>"+ALLTRIM(STR(detxml.impbase,10,2))+"</precioTotalSinImpuesto>")
fputs(lnFile,"   			<impuestos>")
fputs(lnFile,"   				<impuesto>")
fputs(lnFile,"   					<codigo>"+ALLTRIM(STR(detxml.impcod,5,0))+"</codigo>")
fputs(lnFile,"   					<codigoPorcentaje>"+ALLTRIM(STR(detxml.imppor,5,0))+"</codigoPorcentaje>")
fputs(lnFile,"   					<tarifa>"+ALLTRIM(STR(detxml.imptarf,10,2))+"</tarifa>")
fputs(lnFile,"   					<baseImponible>"+ALLTRIM(STR(detxml.impbase,10,2))+"</baseImponible>")
fputs(lnFile,"   					<valor>"+ALLTRIM(STR(detxml.impval,10,2))+"</valor>")
fputs(lnFile,"   				</impuesto>")
fputs(lnFile,"   			</impuestos>")
fputs(lnFile,"   		</detalle>")
ENDSCAN
fputs(lnFile,"   	</detalles>")
fputs(lnFile,"<infoAdicional>")
fputs(lnFile,'    <campoAdicional nombre="Direccion">'+alltrim(encxml.dirsuj)+'</campoAdicional>')
fputs(lnFile,'<campoAdicional nombre="Telefono">'+alltrim(encxml.stelf)+'</campoAdicional>')
fputs(lnFile,'<campoAdicional nombre="Email">'+alltrim(encxml.emailsuj)+'</campoAdicional>')
fputs(lnFile,'</infoAdicional>')
fputs(lnFile,"</notaCredito>")
fClose(lnFile)
Wait Window "Creando Archivo de Nota de Credito Electronica XML......." NoWait 

if used("encxml")
	select encxml
	use
endif
if used("detxml")
	select detxml
	use
endif
if used("nccxml")
	select nccxml
	use
endif
if used("rucempre")
	select rucempre
	use
endif
if used("empresas")
	select empresas
	use
endif
if used("curxmld")
	select curxmld
	use
endif
if used("curxmle")
	select curxmle
	use
endif
if used("empr")
	select empr
	use
endif
if used("empperi")
	select empperi
	use
endif


RETURN .t.

ENDFUNC


******************
* Generacion de Documento Nota de Debito Cliente
******************
FUNCTION genxmlndc
LPARAMETERS xgencode

LOCAL lnFile, cFILE, xmlclavacc 
CREATE CURSOR encxml (code n(10), ;
	ambiente n(1),;
	emision n(1),;
	clavacc c(50),;
	coddoc c(2),;
	estab c(3),;
	ptoemi c(3),;
	secuen c(10),;
	dirmat c(250),;
	fecemi d(8),;
	direstab c(250),;
	conespec c(5),;
	obligcnt c(2),;
	tiposuj c(2),;
	gremisi c(15),;
	rsocial c(250),;
	numidec c(13),;
	subtot n(10,2),;
	tdescu n(10,2),;
	impcod1 n(1),;
	impporc1 n(1),;
	impbasi1 n(10,2),;
	impval1 n(10,2),;
	impcod2 n(1),;
	impporc2 n(1),;
	impbasi2 n(10,2),;
	impval2 n(10,2),;
	icecod n(1),;
	icepor n(1),;
	icebasi n(10,2),;
	iceval n(10,2),;
	propina n(10,2),;
	impototal n(10,2),;
	moneda c(15),;
	dirsuj c(250),;
	stelf c(10),;
	emailsuj c(250),;
	mcoddoc c(2),;
	mnumdoc c(20),;
	mfecha d(8),;
	motivo c(30) )

CREATE CURSOR detxml (code n(10),;
	codpri n(10),;
	codaux n(10),;
	descrip c(250),;
	canti n(18,6),;
	punit n(10,2),;
	descu n(10,2),;
	precimp n(10,2),;
	impcod n(1),;
	imppor n(1),;
	imptarf n(2),;
	impbase n(10,2),;
	impval n(10,2),;
	icecod n(1),;
	icepor n(1),;
	icetarf n(2),;
	icebasi n(10,2),;
	iceval n(10,2) )
	

q1="select * from periodos;"
if !sqli(q1,'empperi') then
	return
endif

select empperi
go top


q1="select distinct sruc, ssri, stelf, sfax, smail::char(60), saddr, siderepleg, srepleg, sruccontador, nrores, numestb from empresas ;"

if !sqli(q1,'rucempre') then
	return
endif

select 	substr(sruc,1,13) as sruc, ;
		substr(ssri,1,60) as ssri, ;
		nconcero(9,stelf) as stelf, ;
		nconcero(9,sfax) as sfax, ;
		substr(smail,1,60) as smail1, ;
		substr(saddr,1,60) as saddr, ;
		substr(siderepleg,1,1) as siderepleg, ;
		substr(srepleg,1,13) as srepleg, ;
		nconcero(3,numestb) as numestb, ;
		nrores, ;
		substr(sruccontador,1,13) as sruccontador ;
	from rucempre into cursor empresas
	
	
cFILE="NDCELE_"+alltrim(str(xgencode))+".xml"

xmlclavacc = genclaveacceso(xgencode)

** Llenado Cursor Encabezado XML
q1="select d.*, a.idtipdoc, a.numserie2, a.numsecue2, a.fecha2, "+;
"to_char((c.codigo::int2)::int4,'FM09') as docmodificado "+;
"from vdocxml1 d left join  aneiva a on (d.code=a.code) "+;
"left join sritabla c on (a.idtipdoc=c.idsritabla) "+;
"where d.code="+alup(xgencode)+";"

IF !sqli(q1,'curxmle') then
	RETURN
ENDIF

SELECT curxmle
GO top
SCAN
	SELECT encxml 
	APPEND BLANK

	Replace encxml.code 	WITH xgencode
	Replace encxml.ambiente WITH curxmle.tipoambi    && 1 pruebas 2 produccion
	Replace encxml.emision 	WITH empperi.tipoemi   && 1 emision normal   2 indiponiblidad del sistema
	Replace encxml.clavacc 	WITH xmlclavacc  && generar clave de acceso 
	Replace encxml.coddoc 	WITH "05"  && 01 fact 04 nc   05  nd  06 gremision 07  retencion
	Replace encxml.estab 	WITH SUBSTR(nconcero(6,curxmle.serie),1,3)
	Replace encxml.ptoemi 	WITH SUBSTR(nconcero(6,curxmle.serie),4,3)
	Replace encxml.secuen 	WITH nconcero(9,curxmle.num)
	*Replace encxml.dirmat 	WITH curxmle.
	Replace encxml.fecemi 	WITH curxmle.fecha
	*Replace encxml.direstab WITH curxmle.
	
	Replace encxml.conespec WITH nconcero(5,empresas.nrores)  && debemos almacenar en datos de la empresa
	Replace encxml.obligcnt WITH "SI" && debemos almacenar en datos de la empresa obligcnt
	Replace encxml.tiposuj 	WITH IIF(ALLTRIM(curxmle.sname)="CONSUMIDOR FINAL","07",IIF(LEN(ALLTRIM(curxmle.sruc))=13,"04",IIF(LEN(ALLTRIM(curxmle.scedula))=10,"05","06")))
*	Replace encxml.gremisi 	WITH curxmle.
	Replace encxml.rsocial 	WITH ALLTRIM(solonl(curxmle.sname))
	Replace encxml.numidec 	WITH IIF(ALLTRIM(curxmle.sname)="CONSUMIDOR FINAL","9999999999999",IIF(LEN(ALLTRIM(curxmle.sruc))=13,ALLTRIM(curxmle.sruc),IIF(LEN(ALLTRIM(curxmle.scedula))=10,ALLTRIM(curxmle.scedula),ALLTRIM(curxmle.spasaporte))))
	Replace encxml.dirsuj   WITH ALLTRIM(solonl(curxmle.saddr))
	Replace encxml.emailsuj WITH iif(isnull(curxmle.smail) or len(alltrim(curxmle.smail))=0,LOWER(ALLTRIM(empresas.smail1)),LOWER(ALLTRIM(curxmle.smail)) )
	Replace encxml.subtot 	WITH curxmle.subtotal
	Replace encxml.tdescu 	WITH curxmle.descuconiva+curxmle.descusiniva

	Replace encxml.impcod1 	WITH 2 && Codigo de IVA
	Replace encxml.impporc1	WITH 2  && cod 0 para 0%  y cod 2 para 12%   codigo 6 para no objeto de impuesto
	Replace encxml.impbasi1	WITH curxmle.subconiva
	Replace encxml.impval1 	WITH curxmle.ivavalor
	
	Replace encxml.impcod2 	WITH 2
	Replace encxml.impporc2	WITH 0 && cod 0 para 0%  y cod 2 para 12%   codigo 6 para no objeto de impuesto
	Replace encxml.impbasi2	WITH curxmle.subsiniva
	Replace encxml.impval2	WITH 0


	IF curxmle.icevalor>0.00 then
		Replace encxml.icecod 	WITH 0
		Replace encxml.icepor 	WITH 0
		Replace encxml.icebasi 	WITH 0
		Replace encxml.iceval 	WITH 0
	ELSE
		Replace encxml.icecod 	WITH 0
		Replace encxml.icepor 	WITH 0
		Replace encxml.icebasi 	WITH 0
		Replace encxml.iceval 	WITH 0
	endif	
	Replace encxml.propina 	WITH 0.00
	Replace encxml.impototal WITH curxmle.montototal
	Replace encxml.moneda 	WITH "DOLAR"
	Replace encxml.mcoddoc 	WITH curxmle.docmodificado
	Replace encxml.mnumdoc 	WITH SUBSTR(nconcero(6,curxmle.numserie2),1,3)+"-"+SUBSTR(nconcero(6,curxmle.numserie2),4,3)+"-"+nconcero(9,curxmle.numsecue2)
	Replace encxml.mfecha 	WITH curxmle.fecha2
	Replace encxml.motivo 	WITH substr(curxmle.concepto,1,30)

	Replace encxml.stelf 	WITH iif(len(alltrim(curxmle.stelf))=0,iif(len(alltrim(curxmle.scel))=0,empresas.stelf,curxmle.scel),curxmle.stelf)

	SELECT curxmle

ENDSCAN

** llenado de Cursor de Detalle de XML
q1="select * from vdocui where code="+alup(xgencode)+";"
IF !sqli(q1,'curxmld') then
	RETURN
ENDIF

SELECT curxmld
GO top
SCAN
	SELECT detxml 
	APPEND BLANK
	
	Replace detxml.code 	WITH xgencode
	Replace detxml.codpri 	WITH curxmld.iditem
	Replace detxml.codaux 	WITH curxmld.icode
	Replace detxml.descrip 	WITH curxmld.iname
	Replace detxml.canti 	WITH curxmld.qty
	Replace detxml.punit 	WITH curxmld.punitario
	Replace detxml.descu 	WITH curxmld.descuento
	Replace detxml.precimp 	WITH curxmld.valconiva
	IF curxmld.isiva=.t. THEN
		Replace detxml.impcod 	WITH 2 && Codigo de IVA
		Replace detxml.imppor 	WITH 2  && cod 0 para 0%  y cod 2 para 12%   codigo 6 para no objeto de impuesto
		Replace detxml.imptarf 	WITH 12  
		Replace detxml.impbase 	WITH curxmld.subtot
		Replace detxml.impval 	WITH curxmld.valconiva
	ELSE
		Replace detxml.impcod 	WITH 2 && Codigo de IVA
		Replace detxml.imppor 	WITH 0  && cod 0 para 0%  y cod 2 para 12%   codigo 6 para no objeto de impuesto
		Replace detxml.imptarf 	WITH 0  
		Replace detxml.impbase 	WITH curxmld.subtot
		Replace detxml.impval 	WITH 0.00
	endif
	Replace detxml.icecod 	WITH 0
	Replace detxml.icepor 	WITH 0
	Replace detxml.icetarf 	WITH 0
	Replace detxml.icebasi 	WITH 0
	Replace detxml.iceval	WITH 0
	
	SELECT curxmld
	
ENDSCAN

lnFile=FCreate(cFILE)
If lnFile<0
	fClose(lnFile)
	lnFile=FCreate(cFILE)
	If lnFile<0
		Messagebox("Error al Crear Archivo XML",0,empresa)
		Return(.f.)
	EndIf	
EndIf
fputs(lnFile,'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
fputs(lnFile,'<notaDebito id="comprobante" version="1.0.0">')
fputs(lnFile,"	<infoTributaria>")
fputs(lnFile,"		<ambiente>"+alltrim(str(encxml.ambiente))+"</ambiente>")																	&&
fputs(lnFile,"		<tipoEmision>"+alltrim(str(encxml.emision))+"</tipoEmision>")																&&
fputs(lnFile,"		<razonSocial>"+alltrim(empresas.ssri)+"</razonSocial>")
fputs(lnFile,"		<nombreComercial>"+alltrim(empresas.ssri)+"</nombreComercial>")
fputs(lnFile,"		<ruc>"+alltrim(empresas.sruc)+"</ruc>")
fputs(lnFile,"		<claveAcceso>"+alltrim(encxml.clavacc)+"</claveAcceso>")			
fputs(lnFile,"		<codDoc>"+alltrim(encxml.coddoc)+"</codDoc>") 
fputs(lnFile,"		<estab>"+alltrim(encxml.estab)+"</estab>") 
fputs(lnFile,"		<ptoEmi>"+alltrim(encxml.ptoemi)+"</ptoEmi>") 
fputs(lnFile,"		<secuencial>"+alltrim(encxml.secuen)+"</secuencial>") 
fputs(lnFile,"		<dirMatriz>"+alltrim(empresas.saddr)+"</dirMatriz>")
fputs(lnFile,"	</infoTributaria>")
fputs(lnFile,"    <infoNotaDebito>")
fputs(lnFile,"    	<fechaEmision>"+devfeclet(encxml.fecemi,7)+"</fechaEmision>")
fputs(lnFile,"    	<dirEstablecimiento>"+alltrim(empresas.saddr)+"</dirEstablecimiento>")
fputs(lnFile,"    	<tipoIdentificacionComprador>"+alltrim(encxml.tiposuj)+"</tipoIdentificacionComprador>")  &&&
fputs(lnFile,"    	<razonSocialComprador>"+alltrim(encxml.rsocial)+"</razonSocialComprador>")
fputs(lnFile,"    	<identificacionComprador>"+alltrim(encxml.numidec)+"</identificacionComprador>")
fputs(lnFile,"    	<contribuyenteEspecial>"+alltrim(empresas.nrores)+"</contribuyenteEspecial>")
fputs(lnFile,"    	<obligadoContabilidad>"+alltrim(encxml.obligcnt)+"</obligadoContabilidad>")   
fputs(lnFile,"    	<codDocModificado>"+alltrim(encxml.mcoddoc)+"</codDocModificado>")
fputs(lnFile,"    	<numDocModificado>"+alltrim(encxml.mnumdoc)+"</numDocModificado>")
fputs(lnFile,"    	<fechaEmisionDocSustento>"+devfeclet(encxml.mfecha,7)+"</fechaEmisionDocSustento>")
fputs(lnFile,"    	<totalSinImpuestos>"+alltrim(STR(encxml.subtot,10,2))+"</totalSinImpuestos>")
*fputs(lnFile,"    	<valorModificacion>"+alltrim(STR(encxml.impototal,10,2))+"</valorModificacion>")
*fputs(lnFile,"    	<moneda>DOLAR</moneda>")
fputs(lnFile,"    	<impuestos>")
IF encxml.impbasi1>0 then
	fputs(lnFile,"	    	<impuesto>")
	fputs(lnFile,"	    		<codigo>"+ALLTRIM(STR(encxml.impcod1,5,0))+"</codigo>")
	fputs(lnFile,"	    		<codigoPorcentaje>"+ALLTRIM(STR(encxml.impporc1,5,0))+"</codigoPorcentaje>")
	fputs(lnFile,"	    		<tarifa>12.00</tarifa>")
	fputs(lnFile,"	    		<baseImponible>"+ALLTRIM(STR(encxml.impbasi1,10,2))+"</baseImponible>")
	fputs(lnFile,"	    		<valor>"+ALLTRIM(STR(encxml.impval1,10,2))+"</valor>")
	fputs(lnFile,"	    	</impuesto>")
ENDIF
IF encxml.impbasi2>0 then
	fputs(lnFile,"	    	<impuesto>")
	fputs(lnFile,"	    		<codigo>"+ALLTRIM(STR(encxml.impcod2,5,0))+"</codigo>")
	fputs(lnFile,"	    		<codigoPorcentaje>"+ALLTRIM(STR(encxml.impporc2,5,0))+"</codigoPorcentaje>")
	fputs(lnFile,"	    		<tarifa>0.00</tarifa>")
	fputs(lnFile,"	    		<baseImponible>"+ALLTRIM(STR(encxml.impbasi2,10,2))+"</baseImponible>")
	fputs(lnFile,"	    		<valor>"+ALLTRIM(STR(encxml.impval2,10,2))+"</valor>")
	fputs(lnFile,"	    	</impuesto>")
ENDIF
fputs(lnFile,"    	</impuestos>")
fputs(lnFile,"    	<valorTotal>"+alltrim(STR(encxml.impototal,10,2))+"</valorTotal>")
fputs(lnFile,"   	</infoNotaDebito>")
fputs(lnFile,"   	<motivos>")
SELECT detxml
GO top
SCAN
	fputs(lnFile,"   		<motivo>")
	fputs(lnFile,"    			<razon>"+ALLTRIM(encxml.motivo)+"</razon>")
	fputs(lnFile,"   			<valor>"+ALLTRIM(STR(detxml.precimp,10,2))+"</valor>")
	fputs(lnFile,"   		</motivo>")
ENDSCAN
fputs(lnFile,"   	</motivos>")
fputs(lnFile,"<infoAdicional>")
fputs(lnFile,'<campoAdicional nombre="Direccion">'+alltrim(encxml.dirsuj)+'</campoAdicional>')
fputs(lnFile,'<campoAdicional nombre="Telefono">'+alltrim(encxml.stelf)+'</campoAdicional>')
fputs(lnFile,'<campoAdicional nombre="Email">'+alltrim(encxml.emailsuj)+'</campoAdicional>')
fputs(lnFile,'</infoAdicional>')
fputs(lnFile,"</notaDebito>")
fClose(lnFile)
Wait Window "Creando Archivo de Nota de Debito Electronica XML......." NoWait 

if used("encxml")
	select encxml
	use
endif
if used("detxml")
	select detxml
	use
endif
if used("nccxml")
	select nccxml
	use
endif
if used("rucempre")
	select rucempre
	use
endif
if used("empresas")
	select empresas
	use
endif
if used("curxmld")
	select curxmld
	use
endif
if used("curxmle")
	select curxmle
	use
endif
if used("empr")
	select empr
	use
endif
if used("empperi")
	select empperi
	use
endif



RETURN .t.


ENDFUNC


***********************************************
* Generacion de Retencion Electronica
***********************************************
FUNCTION genxmlret
LPARAMETERS xgencode

LOCAL lnFile, cFILE, xmlclavacc 

CREATE CURSOR encxml (code n(10), ;
	ambiente n(1),;
	emision n(1),;
	clavacc c(50),;
	coddoc c(2),;
	estab c(3),;
	ptoemi c(3),;
	secuen c(10),;
	dirmat c(250),;
	fecemi d(8),;
	direstab c(250),;
	conespec c(5),;
	obligcnt c(2),;
	tiposuj c(2),;
	gremisi c(15),;
	rsocial c(250),;
	numidec c(13),;
	subtot n(10,2),;
	tdescu n(10,2),;
	impcod1 n(1),;
	impporc1 n(1),;
	impbasi1 n(10,2),;
	impval1 n(10,2),;
	impcod2 n(1),;
	impporc2 n(1),;
	impbasi2 n(10,2),;
	impval2 n(10,2),;
	icecod n(1),;
	icepor n(1),;
	icebasi n(10,2),;
	iceval n(10,2),;
	impototal n(10,2),;
	moneda c(15),;
	dirsuj c(250),;
	stelf c(10),;
	emailsuj c(250),;
	coddocsus c(2),;
	numdocsus c(20),;
	fecdocsus d(8), ;
	perifis c(10) )

q1="select * from periodos;"
if !sqli(q1,'empperi') then
	return
endif

select empperi
go top

CREATE CURSOR retxml (code n(10),;
	codret n(2),;
	baseimp n(10,2),;
	codpor n(2),;
	porret n(10,2),;
	codtarf n(2),;
	valor n(10,2) )

q1="select distinct sruc, ssri, stelf, sfax, smail::char(60), saddr, siderepleg, srepleg, sruccontador, nrores, numestb from empresas ;"

if !sqli(q1,'rucempre') then
	return
endif

select 	substr(sruc,1,13) as sruc, ;
		substr(ssri,1,60) as ssri, ;
		nconcero(9,stelf) as stelf, ;
		nconcero(9,sfax) as sfax, ;
		substr(smail,1,60) as smail1, ;
		substr(saddr,1,60) as saddr, ;
		substr(siderepleg,1,1) as siderepleg, ;
		substr(srepleg,1,13) as srepleg, ;
		nconcero(3,numestb) as numestb, ;
		nrores, ;
		substr(sruccontador,1,13) as sruccontador ;
	from rucempre into cursor empresas
	
cFILE="RETELE_"+alltrim(str(xgencode))+".xml"

xmlclavacc = genclaveaccesoret(xgencode)

** Llenado Cursor Encabezado XML
q1="select * from vdocxml2 where code="+alup(xgencode)+";"

*!*	q1="select a.*, d.cliente, c.cretri, d.sname, d.sruc, d.scedula, x.spasaporte, x.smail "+;
*!*			"from aneiva a left join vdocusmall d on (a.code=d.code) "+;
*!*					     " left join docuse c on (d.iddocu=c.iddocu) "+;
*!*						 " left join vdocxml1 x on (a.code=x.code) "+;
*!*			"where a.code="+alup(xgencode)+";"
*!*			

IF !sqli(q1,'curxmle') then
	RETURN
ENDIF

q1="select * from vdocxml2 where code="+alup(xgencode)+";"
If !sqli(q1,'cRetenc') Then
	Return
EndIf

SELECT curxmle
GO top
SCAN
	SELECT encxml 
	APPEND BLANK
	Replace encxml.code 	WITH xgencode
	Replace encxml.ambiente WITH 1 &&curxmle.tipoambi    && 1 pruebas 2 produccion
	Replace encxml.emision 	WITH empperi.tipoemi   && 1 emision normal   2 indiponiblidad del sistema
	Replace encxml.clavacc 	WITH xmlclavacc  && generar clave de acceso 
	Replace encxml.coddoc 	WITH "07"  && 01 fact 04 nc   05  nd  06 gremision 07  retencion
	Replace encxml.estab 	WITH SUBSTR(nconcero(6,cRetenc.serieret),1,3)
	Replace encxml.ptoemi 	WITH SUBSTR(nconcero(6,cRetenc.serieret),4,3)
	Replace encxml.secuen 	WITH nconcero(9,cRetenc.secueret)
	Replace encxml.fecemi 	WITH cRetenc.fecha
	Replace encxml.conespec WITH nconcero(5,empresas.nrores)   && debemos almacenar en datos de la empresa
	Replace encxml.obligcnt WITH "SI" && debemos almacenar en datos de la empresa obligcnt
	Replace encxml.tiposuj 	WITH IIF(ALLTRIM(cRetenc.sname)="CONSUMIDOR FINAL","07",IIF(LEN(ALLTRIM(cRetenc.sruc))=13,"04",IIF(LEN(ALLTRIM(cRetenc.scedula))=10,"05","06")))
	Replace encxml.rsocial 	WITH ALLTRIM(solonl(cRetenc.sname))
	Replace encxml.numidec 	WITH IIF(ALLTRIM(cRetenc.sname)="CONSUMIDOR FINAL","9999999999999",IIF(LEN(ALLTRIM(cRetenc.sruc))=13,ALLTRIM(cRetenc.sruc),IIF(LEN(ALLTRIM(cRetenc.scedula))=10,ALLTRIM(cRetenc.scedula),ALLTRIM(cRetenc.spasaporte))))
	Replace encxml.dirsuj   WITH ALLTRIM(solonl(cRetenc.saddr))
	Replace encxml.emailsuj WITH iif(isnull(cRetenc.smail) or len(alltrim(cRetenc.smail))=0,LOWER(ALLTRIM(empresas.smail1)),LOWER(ALLTRIM(cRetenc.smail)) )
	Replace encxml.stelf    WITH ALLTRIM(cRetenc.stelf)
	Replace encxml.moneda 	WITH "DOLAR"
	Replace encxml.perifis 	WITH alltrim(nconcero(2,month(cRetenc.fecha)))+"/"+alltrim(nconcero(4,year(cRetenc.fecha)))
	Replace encxml.stelf 	WITH iif(len(alltrim(curxmle.stelf))=0,iif(len(alltrim(curxmle.scel))=0,empresas.stelf,curxmle.scel),curxmle.stelf)


	SELECT curxmle

ENDSCAN

lnFile=FCreate(cFILE)
If lnFile<0
	fClose(lnFile)
	lnFile=FCreate(cFILE)
	If lnFile<0
		Messagebox("Error al Crear Archivo XML",0,empresa)
		Return(.f.)
	EndIf	
EndIf
fputs(lnFile,'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
fputs(lnFile,'<comprobanteRetencion id="comprobante" version="1.0.0">')
fputs(lnFile,"	<infoTributaria>")
fputs(lnFile,"		<ambiente>"+alltrim(str(encxml.ambiente))+"</ambiente>")																	&&
fputs(lnFile,"		<tipoEmision>"+alltrim(str(encxml.emision))+"</tipoEmision>")																&&
fputs(lnFile,"		<razonSocial>"+alltrim(empresas.ssri)+"</razonSocial>")
fputs(lnFile,"		<nombreComercial>"+alltrim(empresas.ssri)+"</nombreComercial>")
fputs(lnFile,"		<ruc>"+alltrim(empresas.sruc)+"</ruc>")
fputs(lnFile,"		<claveAcceso>"+alltrim(encxml.clavacc)+"</claveAcceso>")			
fputs(lnFile,"		<codDoc>"+alltrim(encxml.coddoc)+"</codDoc>") 
fputs(lnFile,"		<estab>"+alltrim(encxml.estab)+"</estab>") 
fputs(lnFile,"		<ptoEmi>"+alltrim(encxml.ptoemi)+"</ptoEmi>") 
fputs(lnFile,"		<secuencial>"+alltrim(encxml.secuen)+"</secuencial>") 
fputs(lnFile,"		<dirMatriz>"+alltrim(empresas.saddr)+"</dirMatriz>")
fputs(lnFile,"	</infoTributaria>")
fputs(lnFile,"    <infoCompRetencion>")
fputs(lnFile,"    	<fechaEmision>"+devfeclet(encxml.fecemi,7)+"</fechaEmision>")
fputs(lnFile,"    	<dirEstablecimiento>"+alltrim(empresas.saddr)+"</dirEstablecimiento>")
fputs(lnFile,"    	<contribuyenteEspecial>"+alltrim(empresas.nrores)+"</contribuyenteEspecial>")
fputs(lnFile,"    	<obligadoContabilidad>"+alltrim(encxml.obligcnt)+"</obligadoContabilidad>")   
fputs(lnFile,"    	<tipoIdentificacionSujetoRetenido>"+alltrim(encxml.tiposuj)+"</tipoIdentificacionSujetoRetenido>")  &&&
fputs(lnFile,"    	<razonSocialSujetoRetenido>"+alltrim(encxml.rsocial)+"</razonSocialSujetoRetenido>")
fputs(lnFile,"    	<periodoFiscal>"+alltrim(encxml.perifis)+"</periodoFiscal>")  && revisa
fputs(lnFile,"   	</infoCompRetencion>")
fputs(lnFile,"   	<impuestos>")
select cRetenc
if RecCount("cRetenc")>0 then
	go top
	scan
		fputs(lnFile,"              <impuesto>")
		if SUBSTR(cRetenc.rubtab,1,4)="RETE"
			fputs(lnFile,"                  <codigo>1</codigo>")
			fputs(lnFile,"                  <codigoRetencion>"+alltrim(cRetenc.codigoret)+"</codigoRetencion>")
			
		else
			fputs(lnFile,"                  <codigo>2</codigo>")
			do case cRetenc.rubtab
			case cRetenc.rubtab="721"
			fputs(lnFile,"                  <codigoRetencion>1</codigoRetencion>")
			case cRetenc.rubtab="723"
			fputs(lnFile,"                  <codigoRetencion>2</codigoRetencion>")
			case cRetenc.rubtab="725"
			fputs(lnFile,"                  <codigoRetencion>3</codigoRetencion>")
			endcase
		endif
		fputs(lnFile,"                  <baseImponible>"+alltrim(STR(cRetenc.monto,10,2))+"</baseImponible>")            
		fputs(lnFile,"                  <porcentajeRetener>"+alltrim(STR(cRetenc.valcal,10,2))+"</porcentajeRetener>")            
		fputs(lnFile,"                  <valorRetenido>"+alltrim(STR(cRetenc.valor,10,2))+"</valorRetenido>")            
		fputs(lnFile,"                  <codDocSustento>"+alltrim(cRetenc.tipdocsustento)+"</codDocSustento>")            
		fputs(lnFile,"                  <numDocSustento>"+nconcero(6,cRetenc.serieret)+nconcero(9,cRetenc.secueret)+"</numDocSustento>")            
		fputs(lnFile,"                  <fechaEmisionDocSustento>"+devfeclet(cRetenc.fecdocadq,7)+"</fechaEmisionDocSustento>")
		fputs(lnFile,"              </impuesto>")
	endscan
endif
fputs(lnFile,"   	</impuestos>")
fputs(lnFile,"<infoAdicional>")
fputs(lnFile,'<campoAdicional nombre="Direccion">'+alltrim(encxml.dirsuj)+'</campoAdicional>')
fputs(lnFile,'<campoAdicional nombre="Telefono">'+alltrim(encxml.stelf)+'</campoAdicional>')
fputs(lnFile,'<campoAdicional nombre="Email">'+alltrim(encxml.emailsuj)+'</campoAdicional>')
fputs(lnFile,'</infoAdicional>')
fputs(lnFile,"</comprobanteRetencion>")
fClose(lnFile)
Wait Window "Creando Archivo de Comprobante de Retencion Electronica XML......." NoWait 

if used("encxml")
	select encxml
	use
endif
if used("detxml")
	select detxml
	use
endif
if used("retxml")
	select retxml
	use
endif
if used("rucempre")
	select rucempre
	use
endif
if used("empresas")
	select empresas
	use
endif
if used("curxmld")
	select curxmld
	use
endif
if used("curxmle")
	select curxmle
	use
endif
if used("empr")
	select empr
	use
endif
if used("cRetenc")
	select cRetenc
	use
endif

if used("empperi")
	select empperi
	use
endif


RETURN .t.


ENDFUNC

