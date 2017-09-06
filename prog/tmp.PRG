RELEA nridedoc1,loSession, lnRetval

local nridedoc1,loSession, lnRetval

nridedoc1=sys(2003)+"\FACELEC_181294.pdf"


ride=.t.
if !impdoc(181294,ride)
	return .f.
endif

sele ridedocs

Wait 'Creando Archivo PDF' Window NoWait
loSession=EVALUATE([xfrx("XFRX#INIT")])
lnRetVal = loSession.SetParams(nridedoc1,,.t.,,,,"PDF")
If lnRetVal = 0
	loSession.ProcessReport("DOCELEC")
	loSession.finalize()
Endif

cancel