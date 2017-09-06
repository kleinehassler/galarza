*       *********************************************************
*       *                                                         
*       * 11/10/2016            MENUCAJ.PRG             16:13:58  
*       *                                                         
*       *********************************************************
*       *                                                         
*       * Nombre del autor                                        
*       *                                                         
*       * Copyright (C) 2016 Nombre de compañía                   
*       * Dirección                                               
*       * Ciudad,     Código pos                                  
*       * País                                              
*       *                                                         
*       * Descripción:                                            
*       * Este PROGRAMA lo ha generado automáticamente GENMENU.    
*       *                                                         
*       *********************************************************


*       *********************************************************
*       *                                                         
*       *                    Definición de menú                   
*       *                                                         
*       *********************************************************
*

SET SYSMENU TO
SET SYSMENU AUTOMATIC

DEFINE PAD _4r10ysjg1 OF _MSYSMENU PROMPT "Ventas" COLOR SCHEME 3 ;
	KEY ALT+V, ""
DEFINE PAD _4r10ysjg2 OF _MSYSMENU PROMPT "Recaudacion" COLOR SCHEME 3 ;
	KEY ALT+R, ""
DEFINE PAD _4r10ysjg3 OF _MSYSMENU PROMPT "Varios" COLOR SCHEME 3 ;
	KEY ALT+V, ""
DEFINE PAD _4r10ysjg4 OF _MSYSMENU PROMPT "Reportes" COLOR SCHEME 3 ;
	KEY ALT+R, ""
DEFINE PAD _4r10ysjg5 OF _MSYSMENU PROMPT "Configuracion" COLOR SCHEME 3 ;
	KEY ALT+C, ""
DEFINE PAD _4r10ysjg6 OF _MSYSMENU PROMPT "Documentos" COLOR SCHEME 3 ;
	KEY ALT+D, ""
DEFINE PAD _4r10ysjg7 OF _MSYSMENU PROMPT "Impresion" COLOR SCHEME 3 ;
	KEY ALT+I, ""
DEFINE PAD _4r10ysjg8 OF _MSYSMENU PROMPT "Salir" COLOR SCHEME 3 ;
	KEY ALT+S, ""
ON PAD _4r10ysjg1 OF _MSYSMENU ACTIVATE POPUP ventas
ON PAD _4r10ysjg2 OF _MSYSMENU ACTIVATE POPUP recaudacio
ON PAD _4r10ysjg3 OF _MSYSMENU ACTIVATE POPUP varios
ON PAD _4r10ysjg4 OF _MSYSMENU ACTIVATE POPUP reportes
ON PAD _4r10ysjg5 OF _MSYSMENU ACTIVATE POPUP configurac
ON PAD _4r10ysjg6 OF _MSYSMENU ACTIVATE POPUP documentos
ON PAD _4r10ysjg7 OF _MSYSMENU ACTIVATE POPUP _2u51edjuu
ON SELECTION PAD _4r10ysjg8 OF _MSYSMENU ;
	DO _4r10ysjg9 ;
	IN LOCFILE("PROG\MENUCAJ" ,"MPX;MPR|FXP;PRG" ,"DÓNDE está MENUCAJ?")

DEFINE POPUP ventas MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF ventas PROMPT "Doc. Ventas"
DEFINE BAR 2 OF ventas PROMPT "Doc. Ventas x Bodega"
DEFINE BAR 3 OF ventas PROMPT "Cotizaciones"
DEFINE BAR 4 OF ventas PROMPT "Doc Generados"
DEFINE BAR 5 OF ventas PROMPT "\-"
DEFINE BAR 6 OF ventas PROMPT "Devoluciones SR"
DEFINE BAR 7 OF ventas PROMPT "Devoluciones"
DEFINE BAR 8 OF ventas PROMPT "Descuentos Sin Refer."
DEFINE BAR 9 OF ventas PROMPT "Descuentos"
DEFINE BAR 10 OF ventas PROMPT "\-"
DEFINE BAR 11 OF ventas PROMPT "Cheques Ventas"
DEFINE BAR 12 OF ventas PROMPT "\-"
DEFINE BAR 13 OF ventas PROMPT "Clientes"
DEFINE BAR 14 OF ventas PROMPT "Consulta de Items"
DEFINE BAR 15 OF ventas PROMPT "\-"
DEFINE BAR 16 OF ventas PROMPT "Vales de Caja, etc"
ON SELECTION BAR 1 OF ventas do form fac0101
ON SELECTION BAR 2 OF ventas do form fac0106a
ON SELECTION BAR 3 OF ventas do form fac0103
ON SELECTION BAR 4 OF ventas do form fac0101b
ON SELECTION BAR 6 OF ventas do form fac0401a
ON SELECTION BAR 7 OF ventas do form fac0401
ON SELECTION BAR 8 OF ventas do form fac0402a
ON SELECTION BAR 9 OF ventas do form fac0402
ON SELECTION BAR 11 OF ventas do form  cheques
ON SELECTION BAR 13 OF ventas do form adm0303
ON SELECTION BAR 14 OF ventas do form fac0109a
ON SELECTION BAR 16 OF ventas do form caj0207

DEFINE POPUP recaudacio MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF recaudacio PROMPT "Ctas X Cobrar"
ON SELECTION BAR 1 OF recaudacio do form ban0101

DEFINE POPUP varios MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF varios PROMPT "Transferencias"
DEFINE BAR 2 OF varios PROMPT "Liquidacion-Ventas"
DEFINE BAR 3 OF varios PROMPT "\-"
DEFINE BAR 4 OF varios PROMPT "Ingreso de Precios de Venta"
DEFINE BAR 5 OF varios PROMPT "Cambiar Items"
ON SELECTION BAR 1 OF varios do form inv0118
ON SELECTION BAR 2 OF varios do form fac0113
ON SELECTION BAR 4 OF varios do form inv0109e
ON SELECTION BAR 5 OF varios do form moditems

DEFINE POPUP reportes MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF reportes PROMPT "Ingresos - Egresos (Contable)"
DEFINE BAR 2 OF reportes PROMPT "Ingresos - Egresos (det cancelacion)"
DEFINE BAR 3 OF reportes PROMPT "Movimiento Cta. Caja"
DEFINE BAR 4 OF reportes PROMPT "Cheques"
DEFINE BAR 5 OF reportes PROMPT "Montos Totales"
DEFINE BAR 6 OF reportes PROMPT "Movimiento Historico de Items"
ON SELECTION BAR 1 OF reportes *do form con0116a
ON SELECTION BAR 2 OF reportes do form fac0311
ON SELECTION BAR 3 OF reportes do form fac0311a
ON SELECTION BAR 4 OF reportes do form fac0312
ON SELECTION BAR 5 OF reportes do form fac0303
ON SELECTION BAR 6 OF reportes do form inv0601c

DEFINE POPUP configurac MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF configurac PROMPT "Apariencia"
DEFINE BAR 2 OF configurac PROMPT "Cambiar Clave"
DEFINE BAR 3 OF configurac PROMPT "Configuracion"
ON SELECTION BAR 1 OF configurac do form set0403
ON SELECTION BAR 2 OF configurac do form set0401
ON SELECTION BAR 3 OF configurac do form configura

DEFINE POPUP documentos MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF documentos PROMPT "Consulta documentos"
DEFINE BAR 2 OF documentos PROMPT "Consulta de Saldos"
DEFINE BAR 3 OF documentos PROMPT "\-"
DEFINE BAR 4 OF documentos PROMPT "Formas de Pago"
DEFINE BAR 5 OF documentos PROMPT "Documento Bancario"
ON SELECTION BAR 1 OF documentos do form adq0705b
ON SELECTION BAR 2 OF documentos do form ban0110
ON SELECTION BAR 4 OF documentos do form adq0701b
ON SELECTION BAR 5 OF documentos do form adq0702b

DEFINE POPUP _2u51edjuu MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF _2u51edjuu PROMPT "Activar Impresión de Documentos"
DEFINE BAR 2 OF _2u51edjuu PROMPT "Desactivar Impresión de Doc. Ventas"
ON SELECTION BAR 1 OF _2u51edjuu do form actimpdoc
ON SELECTION BAR 2 OF _2u51edjuu ;
	DO _4r10ysjga ;
	IN LOCFILE("PROG\MENUCAJ" ,"MPX;MPR|FXP;PRG" ,"DÓNDE está MENUCAJ?")


*       *********************************************************
*       *                                                         
*       *              Limpiar Código y Procedimientos            
*       *                                                         
*       *********************************************************
*

read event

*       *********************************************************
*       *                                                         
*       * _4R10YSJG9  ON SELECTION PAD                            
*       *                                                         
*       * Procedure Origin:                                       
*       *                                                         
*       * From Menu:  MENUCAJ.PRG,            Record:   61        
*       * Called By:  ON SELECTION PAD                            
*       * Prompt:     Salir                                       
*       * Snippet:    1                                           
*       *                                                         
*       *********************************************************
*
PROCEDURE _4r10ysjg9
*!*	local a
*!*	a=.f.
*!*	do form claveadm to a
*!*	if !a
*!*		return
*!*	endif

deactivate menu _msysmenu
clea even
clea read
final=1
return



*       *********************************************************
*       *                                                         
*       * _4R10YSJGA  ON SELECTION BAR 2 OF POPUP _2u51edjuu      
*       *                                                         
*       * Procedure Origin:                                       
*       *                                                         
*       * From Menu:  MENUCAJ.PRG,            Record:   60        
*       * Called By:  ON SELECTION BAR 2 OF POPUP _2u51edjuu      
*       * Prompt:     Desactivar Impresión de Doc. Ventas         
*       * Snippet:    2                                           
*       *                                                         
*       *********************************************************
*
PROCEDURE _4r10ysjga
if type('_screen.objimp')='O'
	_screen.removeobject('objimp')
endif
