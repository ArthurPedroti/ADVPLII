#include 'protheus.ch'
#include 'FWMVCDEF.ch'

/*/{Protheus.doc} User Function BRWSZ9
  BRWSZ9
  @type  Function
  @author arthurpedroti
  @since 09/12/2021
  @see https://tdn.totvs.com/pages/releaseview.action?pageId=62390842
  @see https://tdn.totvs.com/pages/viewpage.action?pageId=334340072
  @see https://tdn.totvs.com/pages/releaseview.action?pageId=62390842
  @see https://centraldeatendimento.totvs.com/hc/pt-br/articles/360029127091-Cross-Segmento-TOTVS-Backoffice-Linha-Protheus-ADVPL-Op%C3%A7%C3%B5es-de-cores-na-legenda-da-Classe-FWMBROWSE
  /*/
User Function MVCSZ9()
  Local aArea := GetNextAlias()
  Local oBrowseSZ9 // Variavel objeto que recebera o instaciamento da classe FwmBrose

  oBrowseSZ9 := FwmBrowse():New()// Variavel objeto que recebera o instaciamento da classe FwmBrose

  oBrowseSZ9 := FwmBrowse():New()

  oBrowseSZ9:SetAlias('SZ9')
  oBrowseSZ9:SetDescription('Tela de protheuzeiros SZ9')

  oBrowseSZ9:AddLegend("SZ9->Z9_STATUS == '1'", 'GREEN', 'Protheuzeiro Ativo')
  oBrowseSZ9:AddLegend("SZ9->Z9_STATUS == '2'", 'RED', 'Protheuzeiro Inativo')


  oBrowseSZ9:SetOnlyFields({'Z9_CODIGO', 'Z9_NOME', 'Z9_SEXO', 'Z9_STATUS'})

  oBrowseSZ9:SetFilterDefault("Z9_STATUS == '1'")

  oBrowseSZ9:DisableDetails()
  
  oBrowseSZ9:Activate()
  RestArea(aArea)
Return 

/*/{Protheus.doc} MenuDefinition BRWSZ9
  BRWSZ9
  @type Function
  @author user
  @since 09/12/2021
  @see link
/*/
Static Function MenuDef()
  Local aRotina := {}

  ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVCSZ9' OPERATION 2 ACCESS 0
  ADD OPTION aRotina TITLE 'Incluir' ACTION 'VIEWDEF.MVCSZ9' OPERATION 3 ACCESS 0
  ADD OPTION aRotina TITLE 'Alterar' ACTION 'VIEWDEF.MVCSZ9' OPERATION 4 ACCESS 0
  ADD OPTION aRotina TITLE 'Excluir' ACTION 'VIEWDEF.MVCSZ9' OPERATION 5 ACCESS 0

    //Adiciona o arrya do submenu a op��o do menu
	ADD OPTION aRotina TITLE 'SubMenu'    ACTION aSubMnu         OPERATION 9 ACCESS 0

    // adiciona op��es no submenu
	ADD OPTION aSubMnu TITLE 'Sub Menu 01'    ACTION 'Alert("Sub menu 01")'  OPERATION 4 ACCESS 0
	ADD OPTION aSubMnu TITLE 'Sub Menu 02'    ACTION 'Alert("Sub menu 02")'  OPERATION 4 ACCESS 0

  // 1- PESQUISAR
  // 2- VISUALIZAR
  // 3- INCLUIR
  // 4- ALTERAR
  // 5- EXCLUIR
  // 8- IMPRIMIR
  // 9- COPIAR


Return aRotina

/*/{Protheus.doc} ModelDefinition BRWSZ9
  MOdelDef
  @type Function
  @author arthurpedro
  @since 09/12/2021
  @version 1
  @see 
/*/
Static Function ModelDef()
  Local oModel := Nil

  Local oStructSZ9 := FWFormStruct(1, 'SZ9') // traz a estrutura dos campo

  oModel := MPFormModel():New('MVCSZ9M')

  oModel:AddFields('FORMSZ9', /*Owner*/, oStructSZ9)

  oModel:SetPrimaryKey({'Z9_FILIAL', 'Z9_CODIGO'}) // define a chabe primaria para a aplica��o

  oModel:SetDescription('Modelo de dados do cadastro de protheuzeiro')

  oModel:GetModel('FORMSZ9'):SetDescription('Formul�rio de cadastro de protheuzeiro')

Return oModel


/*/{Protheus.doc} ViewDef
  ViewDef
  @type  Function
  @author user
  @since 09/12/2021
  @see link
/*/
Static Function ViewDef()
  Local oView := Nil

  Local oModel := FWLoadModel('MVCSZ9')

  Local oStructSZ9 := FWFormStruct(2, 'SZ9') // traz a estrutura da SZ9

  oView := FWFormView():New() // contruindo a parte da vis�o dos dados

  oView:SetModel(oModel) // passando o modelo de dados

  oView:AddField('VIEWSZ9', oStructSZ9, 'FORMSZ9') // atribui��o da estrutura a camda de vis�o

  oView:CreateHorizontalBox('TELASZ9',100) // cria o container com o intedtificador TELA

  oView:EnableTitleView('VIEWSZ9', 'Visualiza��o dos protheuzeiros') // adiciona titulo ao formulario

  oView:SetCloseOnOk({||.T.}) // for�a ou bloqueia o fechamento da janela

  oView:SetOwnerView('VIEWSZ9', 'TELASZ9')
Return 
