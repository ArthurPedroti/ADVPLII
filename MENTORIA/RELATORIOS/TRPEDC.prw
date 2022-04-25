#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

/*/{Protheus.doc} TRPEDC
Relatório no modelo TReport que é responsável por imprimir os dados do cadatro de clientes, mais precisamente os campos CODIGO, LOJA e NOME
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=jy-ocHaYIKs
/*/
User Function TRPEDC()

//VARIAVEIS 
Private oReport  := Nil
Private oSecCab	 := Nil
Private cPerg 	 := "TRCLI"

//Função que cria as perguntas/filtros que iremos usar no relatório, na SX1
ValidPerg()

//Função responsável por chamar a pergunta criada na função ValidaPerg, a variável PRIVATE cPerg, é passada.
Pergunte(cPerg,.F.)

//CHAMAMOS AS FUNÇÕES QUE CONSTRUIRÃO O RELATÓRIO
ReportDef()
oReport:PrintDialog()

Return 



/*/{Protheus.doc} ReportDef
Função responsável por estruturar as seções e campos que darão forma ao relatório, bem como outras características.
Aqui os campos contidos na querie, que você quer que apareça no relatório, são adicionados
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=H25BvYyPDDY
/*/Static Function ReportDef()

oReport := TReport():New("TRPEDC","Relatório - Pedidos de compra / Fornecedor",cPerg,{|oReport| PrintReport(oReport)},"Relatório Pedidos de Compra/Fornecedor")
oReport:SetLandscape(.T.) // SIGNIFICA QUE O RELATÓRIO SERÁ EM PAISAGEM

//TrSection serve para constrole da seção do relatório, neste caso, teremos somente uma
oSecCab := TRSection():New( oReport , "TITULOS POR FORNECEDOR"  )

/*
TrCell serve para inserir os campos/colunas que você quer no relatório, lembrando que devem ser os mesmos campos que contém na QUERIE
Um detalhe importante, todos os campos contidos nas linhas abaixo, devem estar na querie, mas.. 
você pode colocar campos na querie e adcionar aqui embaixo, conforme a sua necessidade.
*/

//A2_COD, A2_NOME, C7_NUM, C7_EMISSAO,C7_PRODUTO, C7_QUANT

TRCell():New( oSecCab, "C7_NUM"    , "SC7")
TRCell():New( oSecCab, "C7_FORNECE"     , "SC7")
TRCell():New( oSecCab, "A2_NOME"    , "SA2")
TRCell():New( oSecCab, "C7_EMISSAO"    , "SC7")
TRCell():New( oSecCab, "C7_PRODUTO"    , "SC7")
TRCell():New( oSecCab, "C7_QUANT"    , "SC7")

oBreak := TRBreak():New(oSecCab,oSecCab:Cell("C7_FORNECE"),"Sub Total Pedidos")

//ESTA LINHA IRÁ CONTAR A QUANTIDADE DE REGISTROS LISTADOS NO RELATÓRIO PARA A ÚNICA SEÇÃO QUE TEMOS
TRFunction():New(oSecCab:Cell("C7_NUM"),NIL,"COUNT",oBreak)
//TRFunction():New(oSecCab:Cell("E2_SALDO"),NIL,"SUM",oBreak)

TRFunction():New(oSecCab:Cell("C7_FORNECE"),,"COUNT")

Return 


/*/{Protheus.doc} PrintReport
Nesta função é inserida a query utilizada para exibição dos dados;
A função de PERGUNTAS  é chamada para que os filtros possam ser montados
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@param oReport, objeto, (Descrição do parâmetro)
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=vSiJxbiSt8E
/*/Static Function PrintReport(oReport)
Local cAlias := GetNextAlias()


oSecCab:BeginQuery() //Relatório começa a ser estruturado
//INICIO DA QUERY
BeginSql Alias cAlias

	SELECT C7_FORNECE, A2_NOME, C7_NUM, C7_EMISSAO,C7_PRODUTO, C7_QUANT FROM %table:SC7% SC7
	INNER JOIN %table:SA2% SA2 ON SC7.C7_FORNECE = SA2.A2_COD AND SC7.C7_LOJA = SA2.A2_LOJA 
	WHERE C7_FORNECE BETWEEN %exp:(MV_PAR01)% AND %exp:(MV_PAR02)%  
	AND SC7.%notdel% and SA2.%notdel%

//FIM DA QUERY
EndSql


oSecCab:EndQuery() //Fim da Query
oSecCab:Print() //É dada a ordem de impressão, visto os filtros selecionados

//O Alias utilizado para execução da querie é fechado.
(cAlias)->(DbCloseArea())

Return 


/*/{Protheus.doc} ValidPerg
FUNÇÃO RESPONSÁVEL POR CRIAR AS PERGUNTAS NA SX1 
@type function
@author PLACIDO / SISTEMATIZEI
@since 24/06/2019
@version 1.0
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=vSiJxbiSt8E
/*/Static Function ValidPerg()
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
