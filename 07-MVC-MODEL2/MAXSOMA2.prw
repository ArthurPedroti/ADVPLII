#include 'Protheus.ch'
#include 'Totvs.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} ZA8LastSeq
Retorna a ultima sequência do pedido na tabela ZA8

@param cPedido String contendo o número do pedido na ZA8

@return cSeq String contendo a ultima sequência do pedido informado na ZA8
@author Daniel Mendes
@since   05/02/2020
@version 1.0

@return character com o próximo código disponível
/*/
//-------------------------------------------------------------------
static function ZA8LastSeq(cPedido)
local cQuery as char
local cSeq as char
local cAlias as char

//Guarda a workarea corrente
cAlias := Alias()

//Gera um alias aleatório somente para abrir a query
cQuery := GetNextAlias()

//Cria a query
BeginSQL alias cQuery
    SELECT MAX(ZA8_SEQUEN) SEQ_MAX
      FROM %table:ZA8%
     WHERE ZA8_FILIAL = %xfilial:ZA8%
       AND ZA8_PEDIDO = %exp:cPedido%
       AND %notDel%
EndSQL

//Se existir registro, retorna o mesmo
if !(cQuery)->(Eof())
    cSeq := (cQuery)->SEQ_MAX
else
    cSeq := ""
endif

//Fecha a query, boa prática, tudo que você abriu, você fecha... E também existem limites de workareas abertas no Protheus
(cQuery)->(DBCloseArea())

//Retorna a workarea corrente, protegido, pois um dbselectarea com valor vazio gera exceção
if !Empty(cAlias)
    DBSelectArea(cAlias)
endif

return cSeq
