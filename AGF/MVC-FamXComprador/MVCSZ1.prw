#include 'protheus.ch'
#include 'FWMVCDEF.ch'

/*/{Protheus.doc} User Function BRWSZ1
  BRWSZ1
  @type  Function
  @author arthurpedroti
  @since 09/12/2021
  @see https://tdn.totvs.com/pages/releaseview.action?pageId=62390842
  @see https://tdn.totvs.com/pages/viewpage.action?pageId=334340072
  @see https://tdn.totvs.com/pages/releaseview.action?pageId=62390842
  @see https://centraldeatendimento.totvs.com/hc/pt-br/articles/360029127091-Cross-Segmento-TOTVS-Backoffice-Linha-Protheus-ADVPL-Op%C3%A7%C3%B5es-de-cores-na-legenda-da-Classe-FWMBROWSE
  /*/
  
User Function MVCSZ1()
  Local aArea := GetNextAlias()
  Local oBrowseSZ1 // Variavel objeto que recebera o instaciamento da classe FwmBrose

  oBrowseSZ1 := FwmBrowse():New()// Variavel objeto que recebera o instaciamento da classe FwmBrose

  oBrowseSZ1 := FwmBrowse():New()

  oBrowseSZ1:SetAlias('SZ1')
  oBrowseSZ1:SetDescription('Tela de SubFamilias x Compradores')

  oBrowseSZ1:SetOnlyFields({'Z1_FAM', 'Z1_COMP'})

  oBrowseSZ1:DisableDetails()
  
  oBrowseSZ1:Activate()
  RestArea(aArea)
Return 

/*/{Protheus.doc} MenuDefinition BRWSZ1
  BRWSZ1
  @type Function
  @author user
  @since 09/12/2021
  @see link
/*/
Static Function MenuDef()
  // Local aRotina := {}
  Local aRotinaAut := FwMvcMenu('MVCSZ1') // recebe os menus automaticamente

  // Adicionar dentro do array aRotina os os menus automaticos
  // For n := 1 To Len(aRotinaAut)
  //   aAdd(aRotina, aRotinaAut[n])
  // Next n

Return aRotinaAut

/*/{Protheus.doc} ModelDefinition BRWSZ1
  MOdelDef
  @type Function
  @author arthurpedro
  @since 09/12/2021
  @version 1
  @see 
/*/
Static Function ModelDef()
  Local oModel := Nil

  Local oStructSZ1 := FWFormStruct(1, 'SZ1') // traz a estrutura dos campo

  oModel := MPFormModel():New('MVCSZ1M')

  oModel:AddFields('FORMSZ1', /*Owner*/, oStructSZ1)

  oModel:SetPrimaryKey({'Z1_FAM'}) // define a chabe primaria para a aplicação

  oModel:SetDescription('Modelo de dados da tabela de compradores por familia')

  oModel:GetModel('FORMSZ1'):SetDescription('Formulário da tabela de compradores por familia')

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

  Local oModel := FWLoadModel('MVCSZ1')

  Local oStructSZ1 := FWFormStruct(2, 'SZ1') // traz a estrutura da SZ1

  oView := FwFormView():New() // contruindo a parte da visão dos dados

  oView:SetModel(oModel) // passando o modelo de dados

  oView:AddField('VIEWSZ1', oStructSZ1, 'FORMSZ1') // atribuição da estrutura a camda de visão

  oView:CreateHorizontalBox('TELASZ1',100) // cria o container com o intedtificador TELA

  oView:EnableTitleView('VIEWSZ1', 'Visualização dos protheuzeiros') // adiciona titulo ao formulario

  oView:SetCloseOnOk({||.T.}) // força ou bloqueia o fechamento da janela

  oView:SetOwnerView('VIEWSZ1', 'TELASZ1') // relaciona a tela a view

Return oView
