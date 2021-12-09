#include 'protheus.ch'
#include 'FWMVCDEF.ch'

/*/{Protheus.doc} User Function BRWSZ9
  @type  Function
  @author arthurpedroti
  @since 09/12/2021
  @see https://tdn.totvs.com/pages/releaseview.action?pageId=62390842
  @see https://tdn.totvs.com/pages/viewpage.action?pageId=334340072
  @see https://tdn.totvs.com/pages/releaseview.action?pageId=62390842
  @see https://centraldeatendimento.totvs.com/hc/pt-br/articles/360029127091-Cross-Segmento-TOTVS-Backoffice-Linha-Protheus-ADVPL-Op%C3%A7%C3%B5es-de-cores-na-legenda-da-Classe-FWMBROWSE
  /*/
User Function BRWSZ9()
  Local aArea := GetNextAlias()
  Local oBrowseSZ9 // Variavel objeto que recebera o instaciamento da classe FwmBrose

  oBrowseSZ9 := FwmBrowse():New()// Variavel objeto que recebera o instaciamento da classe FwmBrose

  oBrowseSZ9 := FwmBrowse():New()

  oBrowseSZ9:SetAlias('SZ9')
  oBrowseSZ9:SetDescription('Tela de protheuzeiros SZ9')

  /* Legendas de ativo/inativo
  oBrowseSZ9:AddLegend("SZ9->Z9_STATUS == '1'", 'GREEN', 'Protheuzeiro Ativo')
  oBrowseSZ9:AddLegend("SZ9->Z9_STATUS == '2'", 'RED', 'Protheuzeiro Inativo')
  */

  oBrowseSZ9:AddLegend("SZ9->Z9_SEXO == '1'", 'BR_AZUL_CLARO' , 'Protheuzeiro')
  oBrowseSZ9:AddLegend("SZ9->Z9_SEXO == '2'", 'BR_VIOLETA' , 'Protheuzeira')

  oBrowseSZ9:SetOnlyFields({'Z9_CODIGO', 'Z9_NOME', 'Z9_SEXO', 'Z9_STATUS'})

  oBrowseSZ9:SetFilterDefault("Z9_STATUS == '1'")

  oBrowseSZ9:DisableDetails()
  
  oBrowseSZ9:Activate()
  RestArea(aArea)
Return 

