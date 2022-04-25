#include 'Protheus.ch'
#include 'FwMvcDef.ch'

/*/{Protheus.doc} User Function MVCZ2Z3
  MVCZ2Z3
  @author arthurpedroti
  @type  Function
  @since 06/04/2022
  /*/
User Function MVCZ2Z3()
  Local oBrowse := FwLoadBrw("MVCZ2Z3") // Diz o fonte que eu estou buscando o BrowseDef

  // Ativa o browse
  oBrowse:Activate()
Return 

/*/{Protheus.doc} BrowseDef
  Fun��o responsavel por criar o browse e retornalo para o menu
  Quando eu tenho uma Static Function no meu fonte, significa
  que eu posso emprest�-la para outros fontes, atrav�s do FwLoadBrowse
  @type  Function
  @author user
  @since 06/04/2022
/*/
Static Function BrowseDef()
  Local aArea := GetArea()
  Local oBrowse := FwMBrowse():New()

  oBrowse:SetAlias("SZ2")
  oBrowse:SetDescription("Cadastro de Chamados")

  // Legenda
  oBrowse:AddLegend("SZ2->Z2_STATUS == '1'",'GREEN','Chamado Aberto')
  oBrowse:AddLegend("SZ2->Z2_STATUS == '2'",'RED','Chamado Finalizado')
  oBrowse:AddLegend("SZ2->Z2_STATUS == '3'",'YELLOW','Chamado em Andamento')

  // Deve definir de onde vir� o MenuDef, devo chamar o meu menu
  oBrowse:SetMenuDef("MVCZ2Z3") // Coloco o fonte de onde vir� o meu menu

  RestArea(aArea)
Return oBrowse

/*/{Protheus.doc} MenuDef
  (MenuDef)
  @type   Function
  @author user
  @since 07/04/2022
/*/
Static Function MenuDef()
  Local aMenu := {}
  Local n
  // Menus padr�es
  Local aMenuAut := FwMvcMenu("MVCZ2Z3")

  // Menus personalizados
  ADD OPTION aMenu TITLE 'Legenda' ACTION 'u_SZ2LEG' OPERATION 6 ACCESS 0
  ADD OPTION aMenu TITLE 'Sobre' ACTION 'u_SZ2SOBRE' OPERATION 6 ACCESS 0

  For n := 1 to Len(aMenuAut)
    aAdd(aMenu,aMenuAut[n])
  Next

Return aMenu

/*/{Protheus.doc} ModelDef
  (ModelDef)
  @type   Function
  @author user
  @since 06/04/2022
/*/
Static Function ModelDef()
  // Declaro o modelo com as valida��es padr�es
  Local oModel := MPFormModel():New("MVCZ23M",,,,)

  // Crio as estruturas das tabelas pai(sz2) e filho(sz3)
  Local oStPaiZ2 := FwFormStruct(1, "SZ2")
  Local oStFilhoZ3 := FwFormStruct(1, "SZ3")

  // adicionar inicializador padr�o dos campos
  oStFilhoZ3:SetProperty("Z3_CHAMADO", MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, 'SZ2->Z2_COD'))

  // crio modelo de cabe�alho e itens
  oModel:AddFields("SZ2MASTER",,oStPaiZ2)
  oModel:AddGrid("SZ3DETAIL","SZ2MASTER",oStFilhoZ3,,,,,) // essas virgulas s�o blocos de valida��o

  // O meu grid ira se relacionar com o cabe�alho, atravpes dos campos FILIAL e CODIGO DO CHAMADO
  oModel:SetRelation("SZ3DETAIL",{{"Z3_FILIAL","xFilial('SZ2')"},{"Z3_CHAMADO","Z2_COD"}},SZ3->(IndexKey(1)))

  // Setamos a chave primaria, prevalece o que est� na SX2(X2_UNICO), se na X2 estiver preenchido
  // n�o podemos ter dentro de um chamado, dois coment�rios com o mesmo c�digo
  oModel:SetPrimaryKey({"Z3_FILIAL","Z3_CHAMADO","Z3_CODIGO"})

  // combina��o de campos que n�o podem se repetir, ficarem iguais
  oModel:GetModel("SZ3DETAIL"):SetUniqueLine({"Z3_CHAMADO","Z3_CODIGO"})

  oModel:SetDescription("Modelo 3 - Sistema de Chamados")
  oModel:GetModel("SZ2MASTER"):SetDescription("Cabe�alho do chamado")
  oModel:GetModel("SZ3DETAIL"):SetDescription("Comentarios do chamado")

  // Como n�o vamos manipular aCols nem aHeader, n�o vou usar o SetOldGrid

Return oModel

/*/{Protheus.doc} ViewDef
  (ViewDef)
  @type   Function
  @author user
  @since 07/04/2022
/*/
Static Function ViewDef()
  Local oView := Nil

  // carrega o modelo
  Local oModel := FwLoadModel("MVCZ2Z3")

  Local oStPaiZ2 := FwFormStruct(2, "SZ2")
  Local oStFilhoZ3 := FwFormStruct(2, "SZ3")

  // Remove o campo para n�o aparecer, j� que estara sendo preenchido pelo codigo do chamado do cabe�alho
  oStFilhoZ3:RemoveField("Z3_CHAMADO")

  // instancia o view
  oView := FwFormView():New()
  oView:SetModel(oModel)

  oView:AddField("VIEWSZ2",oStPaiZ2,"SZ2MASTER")
  oView:AddGrid("VIEWSZ3",oStFilhoZ3,"SZ3DETAIL")

  // Incrementar o campo de codigo (numera��o) automatico
  oView:AddIncrementField("SZ3DETAIL", "Z3_CODIGO") // Soma 1 ao campo de item
  // Bloquear edi��o do campo de codigo (numera��o)
  oStFilhoZ3:SetProperty("Z3_CODIGO", MVC_VIEW_CANCHANGE, .F.)

  // Criamos os BOX horizontais para cabe�alho e itens
  oView:CreateHorizontalBox("CABEC",60)
  oView:CreateHorizontalBox("GRID",40)

  // Amarrar as views
  oView:SetOwnerView("VIEWSZ2","CABEC")
  oView:SetOwnerView("VIEWSZ3","GRID")

  // Titulos personalizados
  oView:EnableTitleView("VIEWSZ2","Detalhes do Chamado/Cabe�alho")
  oView:EnableTitleView("VIEWSZ3","Detalhes do T�cnico")
Return oView

/*/{Protheus.doc} User Function SZ2LEGEND
  (SZ2LEGEND)
  @type  Function
  @author user
  @since 07/04/2022
  /*/
User Function SZ2LEG(param_name)  
  Local aLegenda := {}

  aAdd(aLegenda,{"BR_VERDE", "Chamado Aberto"})
  aAdd(aLegenda,{"BR_AMARELO", "Chamado em Andamento"})
  aAdd(aLegenda,{"BR_VERMELHO", "Chamado Finalizado"})

  BrwLegenda("Status dos Chamados",,aLegenda)
Return aLegenda

/*/{Protheus.doc} User Function SZ2SOBRE
  (SZ2SOBRE)
  @type  Function
  @author user
  @since 07/04/2022
  /*/
User Function SZ2SOBRE()
  Local cSobre

  cSobre := "Tela em MVC mod 3"

  MsgInfo(cSobre,"Sobre")
Return 
