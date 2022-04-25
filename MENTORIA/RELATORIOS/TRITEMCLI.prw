#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

User Function TRITEMCLI()
Private oReport    := Nil
Private oSection1  := Nil //Primeira Sessão
Private oSection2  := Nil //Segunda  Sessão

Private cPerg 	 := "TRCLI"

ValidPerg()

Pergunte(cPerg,.T.)

ReportDef()
oReport:PrintDialog()

Return 


Static Function ReportDef()
oReport := TReport():New("TRPRODCLI","Relatório - Produtos Vendidos P/ Cliente",cPerg,{|oReport| PrintReport(oReport)},"Relatório de Produtos por Cliente")
oReport:SetLandscape(.T.) 

oSection1 := TRSection():New(oReport,"CLIENTE","SA1")
TRCell():New( oSection1, "A1_COD"      , "SA1")
TRCell():New( oSection1, "A1_LOJA"     , "SA1")
TRCell():New( oSection1, "A1_NOME"     , "SA1")

oSection2 := TRSection():New( oSection1 , "PRODUTOS VENDIDOS",{"SD2","SB1"} ) 
TRCell():New( oSection2, "B1_COD"      ,"SB1")
TRCell():New( oSection2, "B1_DESC"     ,"SB1")
TRCell():New( oSection2, "D2_QUANT"    ,"SD2")
TRCell():New( oSection2, "D2_PRCVEN"   ,"SD2")
TRCell():New( oSection2, "D2_TOTAL"    ,"SD2")

TRFunction():New(oSection2:Cell("D2_TOTAL"),,"SUM")
TRFunction():New(oSection2:Cell("D2_QUANT"),,"SUM")


Return 


Static Function PrintReport(oReport)
Local cAlias := GetNextAlias()

oSection1:BeginQuery() 

BeginSql Alias cAlias
  
SELECT A1_COD, A1_LOJA, A1_NOME,B1_COD, B1_DESC, D2_QUANT, D2_PRCVEN,D2_TOTAL	 FROM %table:SD2% AS SD2
INNER JOIN %table:SA1% AS SA1 ON SD2.D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.%notdel%
INNER JOIN %table:SB1% AS SB1 ON SD2.D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ' '
WHERE SD2.%notdel%  AND A1_COD BETWEEN %exp:(MV_PAR01)% AND %exp:(MV_PAR02)%  
ORDER BY A1_COD, A1_LOJA


EndSql

oSection1:EndQuery() //Fim da Query
oSection2:SetParentQuery() 
oSection2:SetParentFilter({|cCliLoja| (cAlias)->A1_COD+(cAlias)->A1_LOJA = cCliLoja},{|| (cAlias)->A1_COD+(cAlias)->A1_LOJA})

oSection1:Print() 

//O Alias utilizado para execução da querie é fechado.
(cAlias)->(DbCloseArea())

Return 


Static Function ValidPerg()
	Local aArea  := SX1->(GetArea())
	Local aRegs := {}
	Local i,j

	aadd( aRegs, { cPerg,"01","Cliente de ?","Cliente de ?","Cliente de ?","mv_ch1","C", 6,0,0,"G","","mv_par01","","","mv_par01"," ","",""," ","","","","","","","","","","","","","","","","","","SA1"          } )
	aadd( aRegs, { cPerg,"02","Cliente ate ?","Cliente ate ?","Cliente ate ?","mv_ch2","C", 6,0,0,"G","","mv_par02","","","mv_par02"," ","",""," ","","","","","","","","","","","","","","","","","","SA1"       } )

	DbselectArea('SX1')
	SX1->(DBSETORDER(1))
	For i:= 1 To Len(aRegs)
		If ! SX1->(DBSEEK( AvKey(cPerg,"X1_GRUPO") +aRegs[i,2]) )
			Reclock('SX1', .T.)
			FOR j:= 1 to SX1->( FCOUNT() )
				IF j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				ENDIF
			Next j
			SX1->(MsUnlock())
		Endif
	Next i 
	RestArea(aArea) 
Return(cPerg)
