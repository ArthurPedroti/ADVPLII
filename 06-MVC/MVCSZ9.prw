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


  // oBrowseSZ9:SetOnlyFields({'Z9_CODIGO', 'Z9_NOME', 'Z9_SEXO', 'Z9_STATUS'})

  // oBrowseSZ9:SetFilterDefault("Z9_STATUS == '1'")

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
  Local aRotinaAut := FwMvcMenu('MVCSZ9') // recebe os menus automaticamente

  // Popular a variavel aRotina
  ADD OPTION aRotina TITLE 'Legenda' ACTION 'u_SZ9LEG' OPERATION 6 ACCESS 0
  ADD OPTION aRotina TITLE 'Sobre' ACTION 'u_SZ9SOBRE' OPERATION 6 ACCESS 0

  // Adicionar dentro do array aRotina os os menus automaticos
  For n := 1 To Len(aRotinaAut)
    aAdd(aRotina, aRotinaAut[n])
  Next n

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

  oModel:SetPrimaryKey({'Z9_FILIAL', 'Z9_CODIGO'}) // define a chabe primaria para a aplicação

  oModel:SetDescription('Modelo de dados do cadastro de protheuzeiro')

  oModel:GetModel('FORMSZ9'):SetDescription('Formulário de cadastro de protheuzeiro')

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

  oStructSZ9:RemoveField('Z9_ESTCIV')

  oView := FwFormView():New() // contruindo a parte da visão dos dados

  oView:SetModel(oModel) // passando o modelo de dados

  oView:AddField('VIEWSZ9', oStructSZ9, 'FORMSZ9') // atribuição da estrutura a camda de visão

  oView:CreateHorizontalBox('TELASZ9',100) // cria o container com o intedtificador TELA

  oView:EnableTitleView('VIEWSZ9', 'Visualização dos protheuzeiros') // adiciona titulo ao formulario

  oView:SetCloseOnOk({||.T.}) // força ou bloqueia o fechamento da janela

  oView:SetOwnerView('VIEWSZ9', 'TELASZ9') // relaciona a tela a view

Return oView

User Function SZ9LEG()
Local aLegenda := {}

aAdd(aLegenda, {'BR_VERDE'    , 'Ativo'})
aAdd(aLegenda, {'BR_VERMELHO' , 'Inativo'})

BrwLegenda('Protheuzeiros', 'Ativos/Inativos', aLegenda)

Return aLegenda

/*/{Protheus.doc} User Function SZ9SOBRE
  (long_description)
  @type  Function
  @author user
  @since 18/03/2022
  @version version
  @param param_name, param_type, param_descr
  @return return_var, return_type, return_description
  @example
  (examples)
  @see (links_or_references)
  /*/
User Function SZ9SOBRE()
  Local cSobre

  cSobre := '-<b>Minha priemira tela em MVP modelo 1'
  MsgInfo(cSobre)
Return
