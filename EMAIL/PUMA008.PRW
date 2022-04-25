#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "colors.ch"
#Include "RPTDEF.CH"
#INCLUDE "TBICONN.CH"
#include "TOTVS.CH"

User Function PUMA008(cChaves)//chave C8_FILIAL+C8_NUM   cChave 

Private cChave	:= cChaves
 
Private cMailFor:=""
Private cMailComp:=""

GetDadosFor(cChave)
WHILE !TRC7->(EOF()) 
	cMailFor:=""
	MontaRel(TRC7->CHV)
	CpyT2S( "C:\anexos\pedidos\"+TRC7->CHV+".pdf", "\anexos\pedidos\", .F. )  
	ENVMAIL(TRC7->CHV,TRC7->FORNECE,TRC7->C7_NUM,TRC7->C7_EMISSAO)
	TRC7->(dbSkip())
EndDo


Return      



Static Function GetDadosFor(cChave)

cSql:=" SELECT  C7_FILIAL+C7_NUM+C7_FORNECE+C7_LOJA AS CHV, C7_FORNECE+C7_LOJA FORNECE,C7_NUM,C7_EMISSAO"
cSql+=" FROM "+RetSqlName('SC7')+" "
cSql+=" where C7_FILIAL+C7_NUM='"+cChave+"'"
cSql+=" AND D_E_L_E_T_<>'*'"
cSql+=" GROUP BY C7_FILIAL+C7_NUM+C7_FORNECE+C7_LOJA, C7_FORNECE+C7_LOJA,C7_NUM,C7_EMISSAO "

If Select('TRC7')<>0
	TRC7->(DBCloseArea())
EndIF

TcQuery cSql New Alias "TRC7"

return



Static Function MontaRel(cChave)

Local cFilePrintert		:=	cChave
Local nDevice			:= 	IMP_PDF
Local lAdjustToLegacy 	:= 	.F.
Local cRootPh := GetSrvProfString("ROOTPATH", "" )
//Local cPathInServer		:=	cRootPh+"\system\pedidocompra\"   
Local cPathInServer		:=	"C:\anexos\pedidos\"
Local lDisabeSetup		:=  .t.
Local lTReport			:=  .f.
//Local oPrintSetup		:=  nil
Local cPrinter			:=  "PDF"
Local lServer			:=  .F.
Local lPDFAsPNG			:=  .T.
Local lRaw				:=  .F.
Local lViewPDF			:=  .f.
Local nQtdCopy			:=  1
Local ni				:=  0   


Private cLogo			:= '\system\logo_empresa.bmp'
Private oPrinter		:=  FWMSPrinter():New(cFilePrintert,nDevice,lAdjustToLegacy,cPathInServer,lDisabeSetup,lTReport,,cPrinter,lServer,lPDFAsPNG,lRaw,lViewPDF,nQtdCopy)
Private oFont20N   		:= Nil
Private oFont10   		:= Nil
Private oFont10n   		:= Nil

Private nColItem		:= 27
Private nColCProd		:= nColItem+35
Private nColDescP		:= nColCProd+70
Private nColCUm			:= nColDescP+230
Private nColQtde		:= nColCUm+50
Private nColVun		    := nColQtde+70
Private nColVtt		    := nColVun+100
Private nColPipi		:= nColVtt+70  
Private nColVipi		:= nColPipi+65
Private nColPrz			:= nColVipi+65
Private nPagina			:= 1

Private aObs			:= {}   
Private ntotais         := 0   
Private nipi 			:= 0  
Private nicms 			:= 0 


oPrinter:SetLandscape()// fixo paisagem
oPrinter:cPathPDF := cPathInServer
Define Font oFont20N Name "Times New Roman" Size 20, 20 Bold
Define Font oFont10  Name "Times New Roman" Size 15, 15
Define Font oFont10n  Name "Times New Roman" Size 15, 15 Bold  
Define Font oFont08  Name "Times New Roman" Size 10, 10 
Define Font oFont09  Name "Times New Roman" Size 12, 12
Define Font oFont09n  Name "Times New Roman" Size 12, 12 Bold   
Define Font oFont14n  Name "Times New Roman" Size 14, 14 Bold    


getDadosCot(cChave)
cMailFor:=TRC7IT->A2_EMAIL

nLin:=impCab()

nLin:=impItens(nLin)

impRoda(cChave)

oPrinter:Print()

Return

Static Function impCab()

oPrinter:StartPage()

nLin:=030
oPrinter:Box(020,020,580,830)
oPrinter:SayBitmap(nLin,025,cLogo,91.5,16.5)

//nLin+=10
//oPrinter:Say(nLin, 230, alltrim(SM0->M0_NOMECOM) + " -  "+TRANSFORM(SM0->M0_CGC,'@R 99.999.999/9999-99'), oFont10n)
//qnLin+=15

//oPrinter:Say(nLin, 240, "TELEFONE: "+transform(STRTRAN(SM0->M0_TEL,'-',''),"@R 99 (99)9999-9999")+" - FAX "+transform(STRTRAN(SM0->M0_FAX,'-',''),"@R 99 (99)9999-9999")+" - www.Empresa.com.br", oFont10)

//oPrinter:Say(nLin, 720, "Cotação Nº:", oFont08, Nil, Nil, Nil)
//oPrinter:Say(nLin, 762, TRC7IT->C7_NUM, oFont20n, Nil, Nil, Nil)


nLin+=20
oPrinter:Say(nLin, 330, "Pedido de Compra", oFont20N, Nil, Nil, Nil, 2)

//oPrinter:Say(nLin, 720, "Emissão:", oFont08, Nil, Nil, Nil)
//oPrinter:Say(nLin, 760, DTOC(STOD(TRC7IT->C7_EMISSAO)), oFont20n, Nil, Nil, Nil)

nLin+=10

oPrinter:Line ( nLin, 020, nLin, 830 )
nLinCab:=nLin
nLin+=20
nCol:=30   
//cMsgDir:=" COTAÇÃO N.:"+TRC7IT->C7_NUM+" Página:"+alltrim(strzero(nPagina,4))
nColDir:=420     
//Vencimento: "+dToc(stod(TRC7IT->C8_VALIDA))+"  

//oPrinter:Say(nLin,nCol, "PREZADOS SENHORES, ", oFont09, Nil, Nil, Nil, 2)
//oPrinter:Say(nLin,nColDir, cMsgDir, oFont09, Nil, Nil, Nil, 2)

//nLin+=25

//oPrinter:Say(nLin,nCol, ALLTRIM(TRC7IT->A2_NOME)+"("+ALLTRIM(TRC7IT->A2_COD)+"-"+ALLTRIM(TRC7IT->A2_LOJA)+")", oFont09n, Nil, Nil, Nil, 2)

//cMsgDir:="Por Favor queira referenciar este número para quaisquer troca de informações referentes a esta cotação."
//oPrinter:Say(nLin,nColDir, cMsgDir, oFont09, Nil, Nil, Nil, 2)


//nLin+=15   
//cMsgDir:="Atenciosamente,"
oPrinter:Say(nLin,nCol,"Empresa: "+ alltrim(SM0->M0_NOMECOM), oFont09, Nil, Nil, Nil, 2)     
oPrinter:Say(nLin,nColDir,"PEDIDO DE COMPRA - REAL                                       ", oFont09, Nil, Nil, Nil, 2)
oPrinter:Say(nLin,nColDir,"                                                 NºPedido Compras: "+TRC7IT->C7_NUM, oFont20N, Nil, Nil, Nil, 2)
nLin+=15                                                      
//oPrinter:Say(nLin,nColDir, cMsgDir, oFont09, Nil, Nil, Nil, 2)
oPrinter:Say(nLin,nCol,"Endereco: "+alltrim(SM0->M0_ENDCOB), oFont09, Nil, Nil, Nil, 2)  
oPrinter:Say(nLin,nColDir,"Razão Social:"+ALLTRIM(TRC7IT->A2_NOME)+"  Codigo:"+ALLTRIM(TRC7IT->A2_COD)+"          Loja:"+ALLTRIM(TRC7IT->A2_LOJA), oFont09, Nil, Nil, Nil, 2)
nLin+=15                  

oPrinter:Say(nLin,nCol,"CEP: "+ALLTRIM(TRANSFORM(SM0->M0_CEPCOB,"@R 99999-999"))+" Cidade:"+ALLTRIM(SM0->M0_CIDCOB)+" UF:"+SM0->M0_ESTCOB, oFont09, Nil, Nil, Nil, 2) 
oPrinter:Say(nLin,nColDir,"Endereco: "+ALLTRIM(TRC7IT->A2_END)+" Bairro: "+ ALLTRIM(TRC7IT->A2_BAIRRO), oFont09, Nil, Nil, Nil, 2) 

nLin+=15 

oPrinter:Say(nLin,nCol,"TEL: "+alltrim(SM0->M0_TEL), oFont09, Nil, Nil, Nil, 2)
oPrinter:Say(nLin,nColDir,"Municipio: "+ALLTRIM(TRC7IT->A2_MUN)+"  Estado: "+ ALLTRIM(TRC7IT->A2_EST)+"        CNPJ:"+ TRANSFORM(TRC7IT->A2_CGC,'@R 99.999.999/9999-99'), oFont09, Nil, Nil, Nil, 2) 

nLin+=15                   

oPrinter:Say(nLin,nCol,"CNPJ/CPF: "+TRANSFORM(SM0->M0_CGC,'@R 99.999.999/9999-99')+"  INSC.EST: "+ALLTRIM(SM0->M0_INSC), oFont09, Nil, Nil, Nil, 2)    

oPrinter:Say(nLin,nColDir,"Fone: "+ALLTRIM(TRC7IT->A2_TEL)+" FAX: "+ ALLTRIM(TRC7IT->A2_FAX)+"  INSC.EST:"+ ALLTRIM(TRC7IT->A2_INSCR), oFont09, Nil, Nil, Nil, 2) 


//cMsgEsq:="Solicitamos de V Sas. Cotação de preços para os produtos discriminados"
nLin+=15          
//DBSelectArea('SY1')
//qDBSetOrder(2)
//qdbSeek(xfilial('SY1')+RETCODUSR())

//oPrinter:Say(nLin,nColDir,"Fone: "+SY1->Y1_TEL +"    Fax: "+SY1->Y1_FAX , oFont09, Nil, Nil, Nil, 2)

//oPrinter:Say(nLin,nCol, cMsgEsq, oFont09, Nil, Nil, Nil, 2)
//cMsgEsq:="conforme os padrões abaixo estabelecidos:"      
//nLin+=15
////oPrinter:Say(nLin,nCol, cMsgEsq, oFont09, Nil, Nil, Nil, 2)
//oPrinter:Say(nLin,nColDir,"E-Mail: "+SY1->Y1_EMAIL, oFont09, Nil, Nil, Nil, 2)
//cMailComp:=SY1->Y1_EMAIL
//nLin+=10


oPrinter:Line ( nLinCab, 415, nLin, 415 )

oPrinter:Line ( nLin, 020, nLin, 830 )
nLin+=2
oPrinter:Line ( nLin, 020, nLin, 830 )
nLin+=10

oPrinter:Say(nLin,nColItem, "Item", oFont09n, Nil, Nil, Nil, 2)
oPrinter:Say(nLin,nColCProd, "Cod.Produto" , oFont09n, Nil, Nil, Nil, 2)
oPrinter:Say(nLin,nColDescP, "Descrição"   , oFont09n, Nil, Nil, Nil, 2)
oPrinter:Say(nLin,nColCUm,  "Unidade"       , oFont09n, Nil, Nil, Nil, 2)
oPrinter:Say(nLin,nColQtde, "Quantidade"   , oFont09n, Nil, Nil, Nil, 2)

oPrinter:Say(nLin,nColVun	, "Vlr.Unit"	, oFont09n, Nil, Nil, Nil, 2)
oPrinter:Say(nLin,nColVtt	, "Vlr.Total   ", oFont09n, Nil, Nil, Nil, 2)
oPrinter:Say(nLin,nColPipi	, "IPI (%)"		, oFont09n, Nil, Nil, Nil, 2)
oPrinter:Say(nLin,nColPrz	, "Dt Entrega"	, oFont09n, Nil, Nil, Nil, 2)
oPrinter:Say(nLin,nColVipi	, "Nº SC"	    , oFont09n, Nil, Nil, Nil, 2)
nLin+=7
oPrinter:Line ( nLin, 020, nLin, 830 )                                                         


return nLin

Static Function impitens(nLin)

Local ni := 0

nLinIni:=nLin     
ntotais:=0  
nipi := 0  
nicms := 0  
While !TRC7IT->(eof())
	nLin+=15
	IF NLIN>469
		
		nPagina++
		improda()
		nLin:=impCab()
		nLin+=15
	EndIF
	
	oPrinter:Say(nLin,nColItem,TRC7IT->C7_ITEM, oFont09n, Nil, Nil, Nil, 2)
	oPrinter:Say(nLin,nColCProd,TRC7IT->C7_PRODUTO, oFont09n, Nil, Nil, Nil, 2)

	
	oPrinter:Say(nLin,nColDescP,TRC7IT->C7_DESCRI, oFont09n, Nil, Nil, Nil, 2)
   //	if Len(alltrim(cProd))>30           
   //		nLin+=15
  //		oPrinter:Say(nLin,nColDescP,substr(cProd,31,30) , oFont09n, Nil, Nil, Nil, 2)
  //	EndIF
		
	oPrinter:Say(nLin,nColCUm, TRC7IT->C7_UM, oFont09n, Nil, Nil, Nil, 2)
	oPrinter:Say(nLin,nColQtde,TRANSFORM(TRC7IT->C7_QUANT,"@E 999,999,999.9999"), oFont09n, Nil, Nil, Nil, 2) 
		
	oPrinter:Say(nLin,nColVun,TRANSFORM(TRC7IT->C7_PRECO,"@E 999,999,999.9999"), oFont09n, Nil, Nil, Nil, 2)
	oPrinter:Say(nLin,nColVtt,TRANSFORM(TRC7IT->C7_TOTAL,"@E 999,999,999.9999"), oFont09n, Nil, Nil, Nil, 2)
	oPrinter:Say(nLin,nColPipi,TRANSFORM(TRC7IT->C7_IPI,"@E 99"), oFont09n, Nil, Nil, Nil, 2)
	oPrinter:Say(nLin,nColPrz,TRANSFORM(dToc(stod(TRC7IT->C7_EMISSAO)),"99/99/9999"), oFont09n, Nil, Nil, Nil, 2)	
	oPrinter:Say(nLin,nColVipi,TRANSFORM(TRC7IT->C7_NUMSC,"@E 999999"), oFont09n, Nil, Nil, Nil, 2)
	 
	ntotais += TRC7IT->C7_TOTAL 
	nipi  += TRC7IT->C7_IPI
	nicms += TRC7IT->C7_ICMCOMP  
	
		
	oPrinter:Line ( nLin+3, 020, nLin+3, 830 )
	//if aScan(aObs,TRC7IT->OBS)==0
	//	aadd(aObs,TRC7IT->OBS)
	//EndIF
	TRC7IT->(dbSkip())
EndDO
oPrinter:Line ( nLinIni, nColCProd-3, nLin+3, nColCProd-3 )
oPrinter:Line ( nLinIni, nColDescP-3, nLin+3, nColDescP-3 )
oPrinter:Line ( nLinIni, nColCUm-3	, nLin+3, nColCUm-3 )
oPrinter:Line ( nLinIni, nColQtde-3	, nLin+3, nColQtde-3 )
oPrinter:Line ( nLinIni, nColVun-3	, nLin+3, nColVun-3 )
oPrinter:Line ( nLinIni, nColVtt-3	, nLin+3, nColVtt-3 )
oPrinter:Line ( nLinIni, nColPipi-3	, nLin+3, nColPipi-3 )
oPrinter:Line ( nLinIni, nColVipi-3	, nLin+3, nColVipi-3 )
oPrinter:Line ( nLinIni, nColPrz-3	, nLin+3, nColPrz-3 )
Return nlIn



Static Function improda(cChave)
local ni:=0
//nLin:=469 
nLin:=369         
nCol:=30
oPrinter:Line ( nLin+3, 020, nLin+3, 830 )
//oPrinter:Line ( nLin+3, 415, 580, 415 )
//nLin+=10
//oPrinter:Say(nLin,nCol,"Observações", oFont09n, Nil, Nil, Nil, 2)

nLin+=15

//for ni:=1 to len(aObs)                       
//	if ni<6
//		oPrinter:Say(nLin,nColItem,aObs[ni], oFont09, Nil, Nil, Nil, 2)
//		nLin+=15
//	ENDIF
//Next

//nLinDir:=484
//nColDir:=420 
getDadosCot(cChave)
 
oPrinter:Say(nLin,nCol,"Desconto: "+TRANSFORM(TRC7IT->C7_DESC1,"@E 99")+"%      -     "+TRANSFORM(TRC7IT->C7_DESC2,"@E 99")+"%     -     "+TRANSFORM(TRC7IT->C7_DESC1,"@E 99")+"%", oFont09, Nil, Nil, Nil, 2)
oPrinter:Line ( nLin+3, 020, nLin+3, 830 )
nLin+=15 

oPrinter:Say(nLin,nCol,"Local de Entrega: "+alltrim(SM0->M0_ENDENT)+" - "+alltrim(SM0->M0_BAIRENT)+" - CEP "+ALLTRIM(TRANSFORM(SM0->M0_CEPENT,"@R 99999-999"))+" - "+ALLTRIM(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT, oFont09, Nil, Nil, Nil, 2)
nLin+=15
oPrinter:Say(nLin,nCol,"Local de Cobrança: "+alltrim(SM0->M0_ENDCOB)+" - "+alltrim(SM0->M0_BAIRCOB)+" - CEP "+ALLTRIM(TRANSFORM(SM0->M0_CEPCOB,"@R 99999-999"))+" - "+ALLTRIM(SM0->M0_CIDCOB)+" - "+SM0->M0_ESTCOB, oFont09, Nil, Nil, Nil, 2)
oPrinter:Say(nLin,500,"Dta Emissao: "+dToc(stod(TRC7IT->C7_EMISSAO)), oFont09, Nil, Nil, Nil, 2)
oPrinter:Line ( nLin+3, 020, nLin+3, 830 )

nLin+=15  

oPrinter:Say(nLin,320,"Condicao de Pagto: "+TRC7IT->C7_COND + " - " +POSICIONE('SE4',1,xFilial('SE4') + TRC7IT->C7_COND,'E4_DESCRI'), oFont09, Nil, Nil, Nil, 2)

oPrinter:Say(nLin,620,"Total das Mercadoria: "+ALLTRIM(TRANSFORM(ntotais,"@R 999,999,999.9999")), oFont09n, Nil, Nil, Nil, 2)
nLin+=15  

oPrinter:Say(nLin,620,"Total com Impostos: "+ALLTRIM(TRANSFORM(ntotais,"@R 999,999,999.9999")), oFont09n, Nil, Nil, Nil, 2)  
oPrinter:Line ( nLin+3, 020, nLin+3, 830 )
nLin+=15         
oPrinter:Say(nLin,nCol,"Observação: "+TRC7IT->C7_OBS, oFont09n, Nil, Nil, Nil, 2) 
oPrinter:Say(nLin,320,"Obs.Frete: "+ALLTRIM(TRC7IT->C7_FRETE), oFont09, Nil, Nil, Nil, 2)  
oPrinter:Say(nLin,620,"IPI: "+ALLTRIM(TRANSFORM(nipi,"@R 999,999,999.9999")), oFont09, Nil, Nil, Nil, 2) 
nLin+=15         
oPrinter:Say(nLin,620,"ICMS: "+ALLTRIM(TRANSFORM(nicms,"@R 999,999,999.9999")), oFont09, Nil, Nil, Nil, 2) 
oPrinter:Say(nLin,nCol,"Status Pedido: "+IF(TRC7IT->C7_CONAPRO=='L',"LIBERADO","NÃO LIBERADO"), oFont09n, Nil, Nil, Nil, 2)   
nLin+=15   
//oPrinter:Say(nLin,620,"ST: "+ALLTRIM(TRANSFORM(TRC7IT->C7_ICMCOMP,"@R 999,999,999.9999")), oFont09, Nil, Nil, Nil, 2)  
oPrinter:Say(nLin,nCol,"Comprador responsavel: "+POSICIONE('SY1',3,xFilial('SY1') + TRC7IT->C7_USER,'Y1_NOME'), oFont09, Nil, Nil, Nil, 2) 
nLin+=15                                                                                      
oPrinter:Say(nLin,nCol,"Aprovador responsavel: "+POSICIONE('SAK',1,xFilial('SAK') + TRC7IT->C7_APROV,'AK_NOME'), oFont09, Nil, Nil, Nil, 2)  
oPrinter:Say(nLin,620,"Despesas: "+ALLTRIM(TRANSFORM(TRC7IT->C7_DESPESA,"@R 999,999,999.9999")), oFont09, Nil, Nil, Nil, 2) 
nLin+=15 
oPrinter:Say(nLin,620,"Seguro: "+ALLTRIM(TRANSFORM(TRC7IT->C7_SEGURO,"@R 999,999,999.9999")), oFont09, Nil, Nil, Nil, 2) 
nLin+=15  
oPrinter:Say(nLin,620,"Total Geral: "+ALLTRIM(TRANSFORM(ntotais,"@R 999,999,999.9999")), oFont20N, Nil, Nil, Nil, 2) 
nLin+=15 
oPrinter:Say(nLin,nCol,"Nota: so aceitamos a mercadoria se  na sua nota fiscal constar o numero do nosso pedido de compras", oFont09, Nil, Nil, Nil, 2)  
nLin+=15
oPrinter:Say(nLin,nCol,"Emitir nota fiscal conforme a Classificação dos produtos , indicada no pedido de compras industrialização consumo, revenda, prestação de serviço", oFont09, Nil, Nil, Nil, 2) 
oPrinter:EndPage()
return


Static Function getDadosCot(cChave)
cSql:="SELECT * "
cSql+=" FROM "+RetSqlName('SC7')+" SC7"
cSql+="	INNER JOIN "+RetSqlName('SA2')+" SA2"
cSql+="	ON A2_COD = C7_FORNECE"
cSql+="	AND A2_LOJA = C7_LOJA"
cSql+="	AND SA2.D_E_L_E_T_<>'*'"
cSql+=" where C7_FILIAL+C7_NUM+C7_FORNECE+C7_LOJA = '"+cChave+"'"
cSql+=" AND SC7.D_E_L_E_T_<>'*'"
If Select('TRC7IT')<>0
	TRC7IT->(DBCloseArea())
EndIF
TCQuery cSql new Alias "TRC7IT"

Return



Static Function ENVMAIL(cChave, cFornece,cNum,sDtEmis)

Local cServer    := GETMV("MV_RELSERV")
Local cAccount   := GETMV("MV_RELACNT")
Local cPassword  := GETMV("MV_RELPSW")
Local lAutentica := GETMV("MV_RELAUTH")
Local cFrom      := GETMV("MV_RELFROM")
Local cEnvia     := GETMV("MV_RELACNT")
Local cAssunto	 := 'Pedido de Compras - '+cNum
Local cRootPh := GetSrvProfString("ROOTPATH", "" )
Local cPathInServer		:=	"\anexos\pedidos\"
Local cAnexo:=cPathInServer+cChave+".pdf" 
local cCodEmp := FWCodEmp()
local cCompanyName := FWCompanyName()
local ntotal :=0   
local cAssunto:=""  
local cColor:=""
local cMensagem := ""
local cQuery:= ""
local cMailForn :=""

	getDadosCot(cChave)    // CHAMA CONSULTA PRA MONTAR HTML_CPED 

	cAssunto := " PEDIDO DE COMPRA Nº:"+cNum+" (EMPRESA:"+AllTrim(Posicione("SM0",1,cCodEmp+FWCodFil(),"M0_NOMECOM"))+"  /CNPJ :"+TRANSFORM(Posicione("SM0",1,cCodEmp+FWCodFil(),"M0_CGC"),'@R 99.999.999/9999-99')+")"
	cMensagem += " <html>"
	cMensagem += " <title>PEDIDO DE COMPRA</title>"      
    cMensagem += "<img src='http://www.suaempresa.com.br/img/marca.png' alt='Logo EMPRESA'><br />"

	cMensagem += "PEDIDO DE COMPRA Nº: "+cNum+"<br />"
	cMensagem += "Prezado, Segue anexo o pedido de compra SUA EMPRESA. <br />" 

	cMensagem += "OBSERVAÇÕES:<br />" 
	cMensagem += "Favor não responder esse e-mail.<br />"
	cMensagem += "Emitir nota fiscal conforme a Classificação dos produtos indicada no pedido de compras: industrialização, consumo, revenda ou prestação de serviço.<br />"    
	cMensagem += "Só aceitaremos a mercadoria se na sua nota fiscal constar o numero do nosso pedido de compras.<br />"
	cMensagem += "A entrega dos produtos deve ser feita no período da manhã. ( 8:30 às 11:30h )<br />"
	cMensagem += "A SUA EMPRESA não se enquadra no ramo automotivo e da construção Civil.<br />"    
	
	
	cMensagem += " </table>"   
	cMensagem += " </html>" 
	

cHTML:=cMensagem

// Buscar  email do do fornecedor
        cQuery := " Select A2_NOME, A2_EMAIL "
	    cQuery += " From " + RetSqlName("SA2") + " SA2 "
	    cQuery += " Where A2_COD = '" + cFornece + "'"  
	    cQuery += "   and A2_FILIAL =  '" + xFilial("SA2") + "' "  
	    cQuery += "   and D_E_L_E_T_ <> '*' "
	    cQuery := ChangeQuery(cQuery)     
	    
	    If Select("QSA2") > 0
	        QSA2->(dbCloseArea())
	    EndIf
	        
	    dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QSA2",.F.,.T.)
	    dbSelectArea("QSA2")
	    
	    if empty(QSA2->A2_NOME)
	        cMailForn := 'email_teste@emailfornecedor.com.br' 
	    else
	        cMailForn := QSA2->A2_NOME // pega do cadastro de fornecedor
	    endif

//cHTML:="Solicitação de Cotação número "+cNum +CRLF+'Emitido em '+dtoc(stod(sDtEmis))+CRLF
//cHTML:="Envio do pedido de compra aprovado  número: "+cNum+'Emitido em '+dtoc(stod(sDtEmis))+" documento em anexo." 
//CTO:=cMailFor+";"+cMailComp//'rodrigo@afsouza.com.br'//
      cTo:= cMailForn

//LENF:=EMail(cEnvia,cPassword,cServer,cEnvia,cTo,cAssunto,cHTML,cAnexo,.T.)
lenf:= SendMail(cEnvia,cPassword,cServer,cEnvia,cTo,cAssunto,cMensagem,cAnexo)

Return


Static Function SendMail(cEnvia,cPassword,cServer,cEnvia,cTo,cAssunto,cHTML,cAnexo)

Local oMail  		:= NIL
Local oMessage  	:= NIL
Local nErro 		:= 0
Local lRet 			:= .T.
Local cSMTPServer	:= substr(cServer,1,at(':',cserver)-1 )
Local cSMTPUser		:= cEnvia
Local cSMTPPass		:= cPassword
Local cMailFrom		:= "SUA EMPRESA <"+cEnvia+">"
Local nPort	   		:= val(substr(cServer,at(':',cserver)+1))
Local lUseAuth		:= GetMV("MV_RELAUTH",,.T.)
Local cPara 		:= cTo //Destinatário
Local lTLS			:= GetMV("MV_RELTLS ",.F.,.F.)
Local nTOUT			:= GetMV("MV_RELTIME",.F.,120)

DEFAULT cAssunto := ""
DEFAULT cHTML := ""

//cMsg := StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(cHTML, ";"), "&", "&amp;"), " ", "&nbsp;"), ">", "&gt;"), "<", "&lt;"), CRLF, "<BR>")

cMsg:=cHTML
If !lTLS
	//MailSMTPOn
	CONNECT SMTP SERVER cSMTPServer ACCOUNT cSMTPUser PASSWORD cSMTPPass RESULT lRet
	If 	lRet
		SEND MAIL FROM cMailFrom ;
		TO cPara ;
		SUBJECT cAssunto ;
		BODY cMsg;
		ATTACHMENT ;
		RESULT lRet
		If !lRet
			GET MAIL ERROR cMAilError
			ConOut("Erro no envio do e-mail " + RTrim(cMAilError)) //"Erro no envio do e-mail "
		EndIf
		DISCONNECT SMTP SERVER
	Else
		GET MAIL ERROR cMAilError
		ConOut("Erro na conexão:" +  RTrim(cErro)) //"Erro na conexão:"
	EndIf
	
Else
	
	oMail := TMailManager():New()
	oMail:SetUseTLS(.T.)
	oMail:Init( '', cSMTPServer , cSMTPUser, cSMTPPass, 0, nPort  )
	oMail:SetSmtpTimeOut( nTOUT )
	nErro := oMail:SmtpConnect()
	
	If lUseAuth
		nErro := oMail:SmtpAuth(cSMTPUser ,cSMTPPass)
		If nErro <> 0
			// Recupera erro ...
			cMAilError := oMail:GetErrorString(nErro)
			DEFAULT cMailError := '***UNKNOW***'
			Conout("Erro de Autenticacao "+str(nErro,4)+' ('+cMAilError+')') //"Erro de Autenticacao "
			lRet := .F.
		Endif
	Endif
	
	if nErro <> 0
		
		// Recupera erro
		cMAilError := oMail:GetErrorString(nErro)
		DEFAULT cMailError := '***UNKNOW***'
		conout(cMAilError)
		
		Conout("Erro de Conexão SMTP "+str(nErro,4)) //"Erro de Conexão SMTP "
		oMail:SMTPDisconnect()
		
		lRet := .F.
		
	Endif
	
	If lRet
		oMessage := TMailMessage():New()
		oMessage:Clear()
		oMessage:cFrom	:= cMailFrom
		oMessage:cTo	:= cPara
		oMessage:cSubject	:= cAssunto
		oMessage:cBody		:= cMsg  
	   	nRet := oMessage:AttachFile( cAnexo )
		nErro := oMessage:Send( oMail )
		
		if nErro <> 0
			xError := oMail:GetErrorString(nErro)
			Conout("Erro de Envio SMTP" +str(nErro,4)+" ("+xError+")") //"Erro de Envio SMTP "
			lRet := .F.
		Endif
		
		oMail:SMTPDisconnect()
		FreeObj(oMessage)
	Endif
	
	FreeObj(oMail)
	
EndIf

Return lRet