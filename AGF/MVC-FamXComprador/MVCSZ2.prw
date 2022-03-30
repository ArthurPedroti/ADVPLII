#include 'protheus.ch'
#include 'FWMVCDEF.ch'

/*/{Protheus.doc} User Function BRWSZ2
  BRWSZ2
  @type  Function
  @author arthurpedroti
  @since 09/12/2021
  @see https://tdn.totvs.com/pages/releaseview.action?pageId=62390842
  @see https://tdn.totvs.com/pages/viewpage.action?pageId=334340072
  @see https://tdn.totvs.com/pages/releaseview.action?pageId=62390842
  @see https://centraldeatendimento.totvs.com/hc/pt-br/articles/360029127091-Cross-Segmento-TOTVS-Backoffice-Linha-Protheus-ADVPL-Op%C3%A7%C3%B5es-de-cores-na-legenda-da-Classe-FWMBROWSE
  /*/
  
User Function MVCSZ2()
  Local aArea := GetArea()
  Local oBrowseSZ2 // Variavel objeto que recebera o instaciamento da classe FwmBrose

  oBrowseSZ2 := FwmBrowse():New()// Variavel objeto que recebera o instaciamento da classe FwmBrose

  oBrowseSZ2 := FwmBrowse():New()

  oBrowseSZ2:SetAlias('SZ2')
  oBrowseSZ2:SetDescription('Tela de SubFamilias x Compradores')

  oBrowseSZ2:SetOnlyFields({'Z2_FAM', 'Z2_COMP'})

  oBrowseSZ2:DisableDetails()
  
  oBrowseSZ2:Activate()
  RestArea(aArea)
Return 

/*/{Protheus.doc} MenuDefinition BRWSZ2
  BRWSZ2
  @type Function
  @author user
  @since 09/12/2021
  @see link
/*/
Static Function MenuDef()
  // Local aRotina := {}
  Local aRotinaAut := FwMvcMenu('MVCSZ2') // recebe os menus automaticamente

  // Adicionar dentro do array aRotina os os menus automaticos
  // For n := 1 To Len(aRotinaAut)
  //   aAdd(aRotina, aRotinaAut[n])
  // Next n

Return aRotinaAut

/*/{Protheus.doc} ModelDefinition BRWSZ2
  MOdelDef
  @type Function
  @author arthurpedro
  @since 09/12/2021
  @version 1
  @see 
/*/
Static Function ModelDef()
  Local oModel := Nil

  Local oStructSZ2 := FWFormStruct(1, 'SZ2') // traz a estrutura dos campo

  oModel := MPFormModel():New('MVCSZ2M')

  oModel:AddFields('FORMSZ2', /*Owner*/, oStructSZ2)

  oModel:SetPrimaryKey({'Z2_FAM'}) // define a chabe primaria para a aplicação

  oModel:SetDescription('Modelo de dados da tabela de compradores por familia')

  oModel:GetModel('FORMSZ2'):SetDescription('Formulário da tabela de compradores por familia')

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

  Local oModel := FWLoadModel('MVCSZ2')

  Local oStructSZ2 := FWFormStruct(2, 'SZ2') // traz a estrutura da SZ2

  oView := FwFormView():New() // contruindo a parte da visão dos dados

  oView:SetModel(oModel) // passando o modelo de dados

  oView:AddField('VIEWSZ2', oStructSZ2, 'FORMSZ2') // atribuição da estrutura a camda de visão

  oView:CreateHorizontalBox('TELASZ2',100) // cria o container com o intedtificador TELA

  oView:EnableTitleView('VIEWSZ2', 'Visualização dos protheuzeiros') // adiciona titulo ao formulario

  oView:SetCloseOnOk({||.T.}) // força ou bloqueia o fechamento da janela

  oView:SetOwnerView('VIEWSZ2', 'TELASZ2') // relaciona a tela a view

Return oView
