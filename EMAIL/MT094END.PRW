#Include 'Protheus.ch'

/*https://tdn.totvs.com/display/public/PROT/TUMXYE_DT_PONTO_ENTRADA_MT094END#
PARAMIXB[1]	Caracter	Número do Documento	
PARAMIXB[2]	Caracter	Tipo do documento (PC, NF, SA, IP, AE)	
PARAMIXB[3]	Numérico	Operação a ser executada (1-Aprovar, 2-Estornar, 3-Aprovar pelo Superior, 4-Transferir para Superior, 5-Rejeitar, 6-Bloquear)	
PARAMIXB[4]	Caracter	Filial do documento
*/

User Function MT094END()

Local cDocto  := PARAMIXB[1]
Local cTipo   := PARAMIXB[2]
Local nOpc    := PARAMIXB[3]
Local cFilDoc := PARAMIXB[4]

 // Validações do usuário.
	IF cTipo == "PC" 
		If nOpc == 1
			//If MsgYesNo( 'Deseja enviar email para o fornecedor e ao comprador responsavel?', 'Alerta' )
				MsgRun("Enviando e-mail...", "Aguarde...", {|| U_PUMA008(xFilial('SC7')+cDocto) })
			//Endif
		Endif
	Endif

Return
