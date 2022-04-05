/*/{Protheus.doc} maxSoma1
  maxSoma1
  @type  Function
  @author user
  @since 04/04/2022
/*/
Static Function maxSoma1(table,field)
  Local cTable := table
  Local cField := field
  Local cNum := ''

  DbSelectArea(cTable)
  WHILE !cTable->(EOF())
      cNum := cTable->(cField)
  cTable->(dbSkip())
  ENDDO
Return cNum
