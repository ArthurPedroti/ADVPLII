#include 'Protheus.ch'
#include 'FwMvcDef.ch'

/*/{Protheus.doc} User Function MVCSZ75
  FunÃ§Ã£o principal para criÃ§aÃµ de MVC Model 2
  @type  Function
  @author arthurpedroti
  @since 18/03/2022
  @version 1
  /*/
User Function MVCSZ7()
  Local aArea := GetArea()
  // FarÃ¡ o instanciamento doa classe FwmBrowse, passando para o Browse
  // a possibilidade de executar todos os mÃ©todos da classe
  Local oBrowse := FwmBrowse():New()

  oBrowse:SetAlias('SZ7')
  oBrowse:SetDescription('SolicitaÃ§Ã£o de Compras')

  oBrowse:Activate()

  RestArea(aArea)
Return

/*/{Protheus.doc} User Function MenuDef
  MenuDef
  @type  Function
  @author arthurpedroti
  @since 18/03/2022
  @version 1
/*/
Static Function MenuDef()
  Local aRotina := FwMvcMenu("MVCSZ7")
Return aRotina

/*/{Protheus.doc} ModelDefinition MVCSZ75
  ModelDef SZ7
  @type Function
  @author arthurpedroti
  @since 18/03/2022
  @see https://tdn.totvs.com/display/framework/FWFormModelStruct
  @see https://tdn.totvs.com/display/framework/FWFormStruct
  @see https://tdn.totvs.com/display/framework/MPFormModel
  @see https://tdn.totvs.com/display/framework/FWBuildFeature    
  @see https://tdn.totvs.com/display/framework/FWFormGridModel
/*/
Static Function ModelDef()
  // Objeto responsavel pela criaÃ§Ã£o da estrutura temporaria do cabeÃ§alho
  Local oStCabec := FWFormModelStruct():New()

  // Objeto responsavel pela estrutura dos itens
  Local oStItens := FwFormStruct(1, 'SZ7')

  Local bVldPos := {|| u_VldSZ7()} // Valição para inclusão antes da inserção no bd

  Local bVldCom := {|| u_GrvSZ7()} // chama da user function que validara a INCLUSAO/ALTERACAO/EXCLUSAO dos itens

  // Objeto principal do dev em MVC Model2, eletras as caracteristicas
  // do dicionario de dados, estrutura de tabelas, campos e registros
  Local oModel := MPFormModel():New('MVCSZ7m',/*bPre*/, bVldPos, bVldCom /*bCommit*/,/*bCancel*/)

  // Variaveis que armazenarão a estrutura da trigger dos campos quantidade e preço,
  // que gerara o conteudo do campo TOTAL automaticamente
  Local aTrigQuant := {}
  Local aTrigPreco := {}

  // CriaÃ§Ã£o da tabela temporÃ¡ria que serÃ¡ utilizada no cabeÃ§alho
  oStCabec:AddTable('SZ7', {'Z7_FILIAL', 'Z7_NUM', 'Z7_ITEM'}, 'CabeÃ§alho SZ7')

  // CriaÃ§Ã£o dos campos da tabela temporÃ¡ria
  oStCabec:AddField(;
    "Filial",;                                                                                  // [01]  C   Titulo do campo
    "Filial",;                                                                                  // [02]  C   ToolTip do campo
    "Z7_FILIAL",;                                                                               // [03]  C   Id do Field
    "C",;                                                                                       // [04]  C   Tipo do campo
    TamSX3("Z7_FILIAL")[1],;                                                                    // [05]  N   Tamanho do campo
    0,;                                                                                         // [06]  N   Decimal do campo
    Nil,;                                                                                       // [07]  B   Code-block de validaÃ§Ã£o do campo
    Nil,;                                                                                       // [08]  B   Code-block de validaÃ§Ã£o When do campo
    {},;                                                                                        // [09]  A   Lista de valores permitido do campo
    .F.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatÃ³rio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_FILIAL,FWxFilial('SZ7'))" ),;   // [11]  B   Code-block de inicializacao do campo
    .T.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operaÃ§Ã£o de update.
    .F.)      
  
  oStCabec:AddField(;
    "Pedido",;                                                                                  // [01]  C   Titulo do campo
    "Pedido",;                                                                                  // [02]  C   ToolTip do campo
    "Z7_NUM",;                                                                                  // [03]  C   Id do Field
    "C",;                                                                                       // [04]  C   Tipo do campo
    TamSX3("Z7_NUM")[1],;                                                                       // [05]  N   Tamanho do campo
    0,;                                                                                         // [06]  N   Decimal do campo
    Nil,;                                                                                       // [07]  B   Code-block de validaÃ§Ã£o do campo
    Nil,;                                                                                       // [08]  B   Code-block de validaÃ§Ã£o When do campo
    {},;                                                                                        // [09]  A   Lista de valores permitido do campo
    .F.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatÃ³rio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, 'Iif(!INCLUI,SZ7->Z7_NUM,NEXTNUMERO("SZ7",1,"Z7_NUM",.T.))' ),;                    // [11]  B   Code-block de inicializacao do campo
    .T.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operaÃ§Ã£o de update.
    .F.)  

  oStCabec:AddField(;
    "Emissao",;                                                                     // [01]  C   Titulo do campo
    "Emissao",;                                                                     // [02]  C   ToolTip do campo
    "Z7_EMISSAO",;                                                                  // [03]  C   Id do Field
    "D",;                                                                           // [04]  C   Tipo do campo
    TamSX3("Z7_EMISSAO")[1],;                                                       // [05]  N   Tamanho do campo
    0,;                                                                             // [06]  N   Decimal do campo
    Nil,;                                                                           // [07]  B   Code-block de validaÃ§Ã£o do campo
    Nil,;                                                                           // [08]  B   Code-block de validaÃ§Ã£o When do campo
    {},;                                                                            // [09]  A   Lista de valores permitido do campo
    .T.,;                                                                           // [10]  L   Indica se o campo tem preenchimento obrigatÃ³rio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_EMISSAO,dDataBase)" ),;    // [11]  B   Code-block de inicializacao do campo
    .T.,;                                                                           // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                           // [13]  L   Indica se o campo pode receber valor em uma operaÃ§Ã£o de update.
    .F.)

  oStCabec:AddField(;
    "Fornecedor",;                                                              // [01]  C   Titulo do campo
    "Fornecedor",;                                                              // [02]  C   ToolTip do campo
    "Z7_FORNECE",;                                                              // [03]  C   Id do Field
    "C",;                                                                       // [04]  C   Tipo do campo
    TamSX3("Z7_FORNECE")[1],;                                                   // [05]  N   Tamanho do campo
    0,;                                                                         // [06]  N   Decimal do campo
    Nil,;                                                                       // [07]  B   Code-block de validaÃ§Ã£o do campo
    Nil,;                                                                       // [08]  B   Code-block de validaÃ§Ã£o When do campo
    {},;                                                                        // [09]  A   Lista de valores permitido do campo
    .T.,;                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatÃ³rio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_FORNECE,'')" ),;// [11]  B   Code-block de inicializacao do campo
    .F.,;                                                                       // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                       // [13]  L   Indica se o campo pode receber valor em uma operaÃ§Ã£o de update.
    .F.)    

  oStCabec:AddField(;
    "Loja",;                                                                      // [01]  C   Titulo do campo
    "Loja",;                                                                      // [02]  C   ToolTip do campo
    "Z7_LOJA",;                                                                   // [03]  C   Id do Field
    "C",;                                                                         // [04]  C   Tipo do campo
    TamSX3("Z7_LOJA")[1],;                                                        // [05]  N   Tamanho do campo
    0,;                                                                           // [06]  N   Decimal do campo
    Nil,;                                                                         // [07]  B   Code-block de validaÃ§Ã£o do campo
    Nil,;                                                                         // [08]  B   Code-block de validaÃ§Ã£o When do campo
    {},;                                                                          // [09]  A   Lista de valores permitido do campo
    .T.,;                                                                         // [10]  L   Indica se o campo tem preenchimento obrigatÃ³rio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_LOJA,'')" ),;     // [11]  B   Code-block de inicializacao do campo
    .F.,;                                                                         // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                         // [13]  L   Indica se o campo pode receber valor em uma operaÃ§Ã£o de update.
    .F.)                                                                          // [14]  L   Indica se o campo Ã© virtual

oStCabec:AddField(;
    "Usuario",;                                                                     // [01]  C   Titulo do campo
    "Usuario",;                                                                     // [02]  C   ToolTip do campo
    "Z7_USER",;                                                                     // [03]  C   Id do Field
    "C",;                                                                           // [04]  C   Tipo do campo
    TamSX3("Z7_USER")[1],;                                                          // [05]  N   Tamanho do campo
    0,;                                                                             // [06]  N   Decimal do campo
    Nil,;                                                                           // [07]  B   Code-block de validaÃ§Ã£o do campo
    Nil,;                                                                           // [08]  B   Code-block de validaÃ§Ã£o When do campo
    {},;                                                                            // [09]  A   Lista de valores permitido do campo
    .T.,;                                                                           // [10]  L   Indica se o campo tem preenchimento obrigatÃ³rio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_USER,__cuserid)" ),;// [11]  B   Code-block de inicializacao do campo
    .F.,;                                                                           // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                           // [13]  L   Indica se o campo pode receber valor em uma operaÃ§Ã£o de update.
    .F.)                                                                            // [14]  L   Indica se o campo Ã© virtual

  // Modificando inicializadores padrão, para não dar mensagem de coluna vazia
  oStItens:SetProperty("Z7_NUM", MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))
  oStItens:SetProperty("Z7_USER", MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '__cUserId')) // trazer o usuario automatico
  oStItens:SetProperty("Z7_EMISSAO", MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, 'dDatabase')) // trazer a data automatico
  oStItens:SetProperty("Z7_FORNECE", MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))
  oStItens:SetProperty("Z7_LOJA", MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))

  // Chamar a função para o bloco de codigo da trigger
  aTrigQuant := FwStruTrigger(;
  "Z7_QUANT",; // campo que ira disparar o gatilho/trigger
  "Z7_TOTAL",; // campo que ira receber o conteudo disparado
  "M->Z7_QUANT * M->Z7_PRECO",; // conteudo que irá para o campo Z7_TOTAL
  .F.)

  aTrigPreco := FwStruTrigger(;
  "Z7_PRECO",; // campo que ira disparar o gatilho/trigger
  "Z7_TOTAL",; // campo que ira receber o conteudo disparado
  "M->Z7_QUANT * M->Z7_PRECO",; // conteudo que irá para o campo Z7_TOTAL
  .F.)

  // Adiciono a trigger a minha estrutura de itens
  oStItens:AddTrigger(;
    aTrigQuant[1],;
    aTrigQuant[2],;
    aTrigQuant[3],;
    aTrigQuant[4];
  )

  oStItens:AddTrigger(;
    aTrigPreco[1],;
    aTrigPreco[2],;
    aTrigPreco[3],;
    aTrigPreco[4];
  )

  /*A partir de agora, eu faço a união das estruturas, vinculando o cabeçalho com os itens
  também faço a vinculação da Estrutura de dados dos itens, ao modelo
  */

  oModel:AddFields("SZ7MASTER",,oStCabec) // Faço a vinculação com o oStCabec(cabeçalhjo de iten temporarios)
  oModel:AddGrid("SZ7DETAIL","SZ7MASTER",oStItens,,,,,) // Faço a vinculação com o oStItens(itens temporarios)

  /*ADICIONANDO MODEL DE TOTALIZADORES Á APLICAÇÃO*/
           /*       IDMODELO       MASTER         DETALHE       CAMPOCALCULADO   NOMEPERSONALIZADO DO CAMPO      OPERACAO   NOMETOTALIZADOR   */
  oModel:AddCalc("SZ7TOTAIS",     "SZ7MASTER",   "SZ7DETAIL",  "Z7_PRODUTO",    "QTDITENS",                    "COUNT",,, "Número de Produtos")
  oModel:AddCalc("SZ7TOTAIS",     "SZ7MASTER",   "SZ7DETAIL",  "Z7_QUANT",      "QTDTOTAL",                    "SUM"  ,,, "Total de Itens")
  oModel:AddCalc("SZ7TOTAIS",     "SZ7MASTER",   "SZ7DETAIL",  "Z7_TOTAL",      "PRCTOTAL",                    "SUM"  ,,, "Preço total da Solicitação de Compras")

  // Seta uma relação entre o cabeçalho e itens, neste ponto, eu digo atráves de qual/quais campos o grid está vinculado com o cabeçalho
  aRelations := {}
  aAdd(aRelations,{"Z7_FILIAL",'Iif(!INCLUI, SZ7->Z7_FILIAL, FWxFilial("SZ7"))'})
  aAdd(aRelations,{"Z7_NUM","SZ7->Z7_NUM"})
  oModel:SetRelation("SZ7DETAIL",aRelations,SZ7->(IndexKey(1)))

  // forma em uma linha: oModel:SetRelation('SZ7DETAIL',{{'Z7_FILIAL','Iif(!INCLUI, SZ7->Z7_FILIAL, FWxFilial("SZ7"))'},{'Z7_NUM','SZ7->Z7_NUM'}},SZ7->(IndexKey(1)))

  // Seta a chave primaria, lembrando que, se ela estiver definida no X2_UNICO, faz valer o que está no X2_UNICO
  oModel:SetPrimaryKey({})

  oModel:GetModel("SZ7DETAIL"):SetUniqueline({"Z7_ITEM"}) // o intuito é que este campo não se repita

  // Setamos a descrição/título que aparecerá no cabeçalho e no GRID
  oModel:GetModel("SZ7MASTER"):SetDescription("CABEÇALHO DA SOLICITAÇÃO DE COMPRAS")
  // Setamos a descrição/título que aparecerá no cabeçalho e no GRID
  oModel:GetModel("SZ7DETAIL"):SetDescription("ITENS DA SOLICITAÇÃO DE COMPRAS")

  //Finalizamos a função model
  oModel:GetModel("SZ7DETAIL"):SetUseOldGrid(.T.) //Finalizo setando o modelo antigo de Grid, que permite pegar aHeader e aCols

Return oModel

/*/{Protheus.doc} Static Function ViewDef
  ViewDef
  @type  Function
  @author arthurpedroti
  @since 18/03/2022
  @version 1
/*/
Static Function ViewDef()
  Local oView := Nil

  /*Faço o Load do Movel referente à função/fonte MVCSZ7, sendo assim se este Model
  estivesse em um outro fonte eu poderia pegar de lá, sem ter que copiar tudooo de novo
  */
  Local oModel        := FwLoadModel("MVCSZ7")

  //Objeto encarregado de montar a estrutura temporária do cabeçalho da View
  Local oStCabec      := FwFormViewStruct():New()

  /* Objeto responsável por montar a parte de estrutura dos itens/grid
  Como estou usando FwFormStruct, ele traz a estrutura de TODOS OS CAMPOS, sendo assim
  caso eu não queira que algum campo, apareça na minha grid, eu devo remover este campo com RemoveField
  */
  Local oStItens      := FwFormStruct(2,"SZ7") //1 para model 2 para view

  // criar estrutura para totalizadores
  Local oStTotais := FwCalcStruct(oModel:GetModel('SZ7TOTAIS'))

  oStCabec:AddField(;
    "Z7_NUM",;                  // [01]  C   Nome do Campo
    "01",;                      // [02]  C   Ordem
    "Pedido",;                  // [03]  C   Titulo do campo
    X3Descric('Z7_NUM'),;       // [04]  C   Descricao do campo
    Nil,;                       // [05]  A   Array com Help
    "C",;                       // [06]  C   Tipo do campo
    X3Picture("Z7_NUM"),;       // [07]  C   Picture
    Nil,;                       // [08]  B   Bloco de PictTre Var
    Nil,;                       // [09]  C   Consulta F3
    .F.,;    	// [10]  L   Indica se o campo é alteravel
    Nil,;                       // [11]  C   Pasta do campo
    Nil,;                       // [12]  C   Agrupamento do campo
    Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
    Nil,;                       // [15]  C   Inicializador de Browse
    Nil,;                       // [16]  L   Indica se o campo é virtual
    Nil,;                       // [17]  C   Picture Variavel
    Nil)                        // [18]  L   Indica pulo de linha após o campo

  oStCabec:AddField(;
    "Z7_EMISSAO",;                // [01]  C   Nome do Campo
    "02",;                      // [02]  C   Ordem
    "Emissao",;                  // [03]  C   Titulo do campo
    X3Descric('Z7_EMISSAO'),;    // [04]  C   Descricao do campo
    Nil,;                       // [05]  A   Array com Help
    "D",;                       // [06]  C   Tipo do campo
    X3Picture("Z7_EMISSAO"),;    // [07]  C   Picture
    Nil,;                       // [08]  B   Bloco de PictTre Var
    Nil,;                       // [09]  C   Consulta F3
    Iif(INCLUI, .T., .F.),;     // [10]  L   Indica se o campo é alteravel
    Nil,;                       // [11]  C   Pasta do campo
    Nil,;                       // [12]  C   Agrupamento do campo
    Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
    Nil,;                       // [15]  C   Inicializador de Browse
    Nil,;                       // [16]  L   Indica se o campo é virtual
    Nil,;                       // [17]  C   Picture Variavel
    Nil)  

  oStCabec:AddField(;
    "Z7_FORNECE",;                  // [01]  C   Nome do Campo
    "03",;                          // [02]  C   Ordem
    "Fornecedor",;                  // [03]  C   Titulo do campo
    X3Descric('Z7_FORNECE'),;       // [04]  C   Descricao do campo
    Nil,;                           // [05]  A   Array com Help
    "C",;                           // [06]  C   Tipo do campo
    X3Picture("Z7_FORNECE"),;       // [07]  C   Picture
    Nil,;                           // [08]  B   Bloco de PictTre Var
    "SA2",;                         // [09]  C   Consulta F3
    Iif(INCLUI, .T., .F.),;         // [10]  L   Indica se o campo é alteravel
    Nil,;                           // [11]  C   Pasta do campo
    Nil,;                           // [12]  C   Agrupamento do campo
    Nil,;                           // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                           // [14]  N   Tamanho maximo da maior opção do combo
    Nil,;                           // [15]  C   Inicializador de Browse
    Nil,;                           // [16]  L   Indica se o campo é virtual
    Nil,;                           // [17]  C   Picture Variavel
    Nil) 

  oStCabec:AddField(;
    "Z7_LOJA",;                 // [01]  C   Nome do Campo
    "04",;                      // [02]  C   Ordem
    "Loja",;                    // [03]  C   Titulo do campo
    X3Descric('Z7_LOJA'),;      // [04]  C   Descricao do campo
    Nil,;                       // [05]  A   Array com Help
    "C",;                       // [06]  C   Tipo do campo
    X3Picture("Z7_LOJA"),;      // [07]  C   Picture
    Nil,;                       // [08]  B   Bloco de PictTre Var
    Nil,;                       // [09]  C   Consulta F3
    Iif(INCLUI, .T., .F.),;     // [10]  L   Indica se o campo é alteravel
    Nil,;                       // [11]  C   Pasta do campo
    Nil,;                       // [12]  C   Agrupamento do campo
    Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
    Nil,;                       // [15]  C   Inicializador de Browse
    Nil,;                       // [16]  L   Indica se o campo é virtual
    Nil,;                       // [17]  C   Picture Variavel
    Nil)

  oStCabec:AddField(;
    "Z7_USER",;                 // [01]  C   Nome do Campo
    "05",;                      // [02]  C   Ordem
    "Usuário",;                 // [03]  C   Titulo do campo
    X3Descric('Z7_USER'),;      // [04]  C   Descricao do campo
    Nil,;                       // [05]  A   Array com Help
    "C",;                       // [06]  C   Tipo do campo
    X3Picture("Z7_USER"),;      // [07]  C   Picture
    Nil,;                       // [08]  B   Bloco de PictTre Var
    Nil,;                       // [09]  C   Consulta F3
    .F.,;                       // [10]  L   Indica se o campo é alteravel
    Nil,;                       // [11]  C   Pasta do campo
    Nil,;                       // [12]  C   Agrupamento do campo
    Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
    Nil,;                       // [15]  C   Inicializador de Browse
    Nil,;                       // [16]  L   Indica se o campo é virtual
    Nil,;                       // [17]  C   Picture Variavel
    Nil) 

  oStItens:RemoveField("Z7_NUM")
  oStItens:RemoveField("Z7_EMISSAO")
  oStItens:RemoveField("Z7_FORNECE")            
  oStItens:RemoveField("Z7_LOJA")      
  oStItens:RemoveField("Z7_USER") 

  oStItens:SetProperty("Z7_ITEM", MVC_VIEW_CANCHANGE, .F.)
  oStItens:SetProperty("Z7_TOTAL", MVC_VIEW_CANCHANGE, .F.)

  // Instanciar a classe FwFormView para o objeto view
  oView := FwFormView():New()

  // Passo para o objeto View o modelo de dados que quero atrelar a ele Modelo + Visualização
  oView:SetModel(oModel)

  // Monto a estrutura de visualização do master e do detail (cabeçalho e itens)
  oView:AddField("VIEW_SZ7M",oStCabec,"SZ7MASTER") // Cabeçalho
  oView:AddGrid("VIEW_SZ7D",oStItens,"SZ7DETAIL") // Itens
  oView:AddField("VIEW_TOTAL",oStTotais,"SZ7TOTAIS") // Totais

  // Deixando o campo item da solicitação incremental
  oView:AddIncrementField("SZ7DETAIL", "Z7_ITEM") // soma 1 ao compa de item

  // Criamos a telinha, dividindo proporcionalmente o tamanho do cabeçalho e da grid
  oView:CreateHorizontalBox("CABEC",20)
  oView:CreateHorizontalBox("GRID",50)
  oView:CreateHorizontalBox("TOTAL",30)

  // Associar cada view para cada box criado
  oView:SetOwnerView("VIEW_SZ7M", "CABEC")
  oView:SetOwnerView("VIEW_SZ7D", "GRID")
  oView:SetOwnerView("VIEW_TOTAL", "TOTAL")

  //Ativar os títulos de cada VIEW/Box criado
  oView:EnableTitleView("VIEW_SZ7M","Cabeçalho Solicitação de Compras")
  oView:EnableTitleView("VIEW_SZ7D","Itens de Solicitação de Compras")
  oView:EnableTitleView("VIEW_TOTAL","Totais de Solicitação de Compras")

  /*Metodo que seta um bloco de código para verificar se a janela deve ou não
  ser fechada após a execução do botão OK.
  */
  oView:SetCloseOnOk({|| .T.})

Return oView

/*/{Protheus.doc} User Function GrvSZ7
  GrvSZ7
  @type  Function
  @author arthurpedroti
  @since 18/03/2022
  @version 1
/*/
User Function GrvSZ7()
  Local aArea := GetArea()

  //Variável de controle da gravação, por enquanto está TRUE mas poderá ser FALSE
  Local lRet      := .T.

  //Capturo o modelo ativo da nossa aplicação
  Local oModel := FwModelActive()

  // Criar modelo de dados MASTER/CABEÇALHO com base no model geral que foi capturado acima
  Local oModelCabec := oModel:GetModel("SZ7MASTER")

  // Criar modelo de dados MASTER/ITENS com base no model geral que foi capturado acima
  // Esse modelo será responsavel pela estrutura do aHeader aCols da Grid
  Local oModelItem := oModel:GetModel("SZ7DETAIL")

  // Capturo o valor que estão no cabeçalho, atra´ves do metodo get value
  // Carrega os valores dentro de variaveis para utilizar no que foi digitado na tela
  Local cFilSZ7 := oModelCabec:GetValue("Z7_FILIAL")
  Local cNum := oModelCabec:GetValue("Z7_NUM")
  Local dEmissao := oModelCabec:GetValue("Z7_EMISSAO")
  Local cFornece := oModelCabec:GetValue("Z7_FORNECE")
  Local cLoja := oModelCabec:GetValue("Z7_LOJA")
  Local cUser := oModelCabec:GetValue("Z7_USER")

  // Variaveis que farão a captura dos dados com base no aHeader e no aCols
  Local aHeaderAux := oModelItem:aHeader
  Local aColsAux := oModelItem:aCols

  // Pegar as posições de cada campo do grid
  Local nPosItem      :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_ITEM")})
  Local nPosProd      :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_PRODUTO")})
  Local nPosQtd       :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_QUANT")})
  Local nPosPrc       :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_PRECO")})
  Local nPosTotal     :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_TOTAL")})

  // Pegar a linha atual que o usuário está posicionado
  Local nLinAtu := 0

  // Identificar qual o tipo de operação que o usuário está fazendo(inclusão/alteração/exclusão)
  Local cOption := oModelCabec:GetOperation()

  /*Fazemos a seleção da nossa área que será manipulada, ou seja, 
  colocamos a tabela SZ7, em evidência juntamente com um índice de ordenação

  OU SEJA...->>> VOCÊ FALA PAR A O PROTHEUS O SEGUINTE: 
  "-E aí cara a partir de agora eu vou modificar a SZ7"=
  */

  DbSelectArea("SZ7")
  SZ7->(DbSetOrder(1)) // indice filial+num

  IF cOption == MODEL_OPERATION_INSERT
    For nLinAtu := 1 to Len(aColsAux) // Mede o tamnho do aCols, quanto itens existem na grid
    // Antes de tentar inserir, verificar se a linah está deletada  
      IF !aColsAux[nLinAtu][Len(aHeaderAux)+1] // expressão para verificar se uma linha está excluida no aCols
        RecLock("SZ7", .T.) // .T. para inclusão, .F. para alter/exclusão
          //DADOS DO CABEÇALHO
          Z7_FILIAL       :=  cFilSZ7 //Variável com o dado da filial no cabeçalho
          Z7_NUM          :=  cNum   //variável com o dado do numero do pedido no cabeçalho
          Z7_EMISSAO      :=  dEmissao
          Z7_FORNECE      :=  cFornece
          Z7_LOJA         :=  cLoja
          Z7_USER         :=  cUser
          //DADOS DO GRID
          Z7_ITEM         :=  aColsAux[nLinAtu,nPosItem] //array acols, posicionado na linha atual
          Z7_PRODUTO      :=  aColsAux[nLinAtu,nPosProd]
          Z7_QUANT        :=  aColsAux[nLinAtu,nPosQtd]
          Z7_PRECO        :=  aColsAux[nLinAtu,nPosPrc]
          Z7_TOTAL        :=  aColsAux[nLinAtu,nPosTotal] 
        SZ7->(MSUNLOCK())
      ENDIF
    Next n // incremento da linha For

  ELSEIF cOption == MODEL_OPERATION_UPDATE
    For nLinAtu := 1 to Len(aColsAux) // Mede o tamnho do aCols, quanto itens existem na grid
    // Antes de tentar inserir, verificar se a linah está deletada  
      IF aColsAux[nLinAtu][Len(aHeaderAux)+1] // expressão para verificar se uma linha está excluida no aCols
        SZ7->(DbSetOrder(2)) // indice filial+num+item
        // Faz a busca, se encontrar, ele deleta do banco
        IF SZ7->(DbSeek(cFilSZ7 + cNum + aColsAux[nLinAtu,nPosItem])) 
          RecLock("SZ7", .F.)
            DbDelete() 
          SZ7->(MSUNLOCK())
        ENDIF
        // Não faz nada, pois a linha está deletada
      ELSE // SE A LINHA NÃO ESTIVER EXCLUÍDA, FAÇO A ALTERAÇÃO
      /* Embora seja uma alteraçao, eu posso ter novos itens inclusos no meu pedido
      sendo assim, preciso validar se estes itens existem no banco de dados ou não
      caso ele não existam, eu faço um inclusão */
        SZ7->(DbSetOrder(2)) // indice filial+num+item
        // Faz a busca, se encontrar, ele altera do banco
        IF SZ7->(DbSeek(cFilSZ7 + cNum + aColsAux[nLinAtu,nPosItem])) 
          RecLock("SZ7", .F.) // .T. para inclusão, .F. para alter/exclusão
          //DADOS DO CABEÇALHO
          Z7_FILIAL       :=  cFilSZ7 //Variável com o dado da filial no cabeçalho
          Z7_NUM          :=  cNum   //variável com o dado do numero do pedido no cabeçalho
          Z7_EMISSAO      :=  dEmissao
          Z7_FORNECE      :=  cFornece
          Z7_LOJA         :=  cLoja
          Z7_USER         :=  cUser
          //DADOS DO GRID
          Z7_ITEM         :=  aColsAux[nLinAtu,nPosItem] //array acols, posicionado na linha atual
          Z7_PRODUTO      :=  aColsAux[nLinAtu,nPosProd]
          Z7_QUANT        :=  aColsAux[nLinAtu,nPosQtd]
          Z7_PRECO        :=  aColsAux[nLinAtu,nPosPrc]
          Z7_TOTAL        :=  aColsAux[nLinAtu,nPosTotal] 
          SZ7->(MSUNLOCK())
        ELSE // se ele não achar, é porque o item não existe ainda na base de dados, logo ele irá incluir
          RecLock("SZ7", .T.) // .T. para inclusão, .F. para alter/exclusão
          //DADOS DO CABEÇALHO
          Z7_FILIAL       :=  cFilSZ7 //Variável com o dado da filial no cabeçalho
          Z7_NUM          :=  cNum   //variável com o dado do numero do pedido no cabeçalho
          Z7_EMISSAO      :=  dEmissao
          Z7_FORNECE      :=  cFornece
          Z7_LOJA         :=  cLoja
          Z7_USER         :=  cUser
          //DADOS DO GRID
          Z7_ITEM         :=  aColsAux[nLinAtu,nPosItem] //array acols, posicionado na linha atual
          Z7_PRODUTO      :=  aColsAux[nLinAtu,nPosProd]
          Z7_QUANT        :=  aColsAux[nLinAtu,nPosQtd]
          Z7_PRECO        :=  aColsAux[nLinAtu,nPosPrc]
          Z7_TOTAL        :=  aColsAux[nLinAtu,nPosTotal] 
          SZ7->(MSUNLOCK())
        ENDIF
      ENDIF
    Next n // incremento da linha For
  ELSEIF cOption == MODEL_OPERATION_DELETE
    SZ7->(DbSetOrder(1)) // indice filial+num
    /* Ele vai percorrer toda a tabela, e enquanto a filial for igual a do pedido e
    o numero do pedido for igual ao numero que está posicionando para excluir
    ele fará a exclusão do itens */
    WHILE !SZ7->(EOF()) .AND. SZ7->Z7_FILIAL = cFilSZ7 .AND. SZ7->Z7_NUM = cNum 
      RecLock("SZ7", .F.)
        DbDelete()
      SZ7->(MSUNLOCK())
    SZ7->(dbSkip())
    ENDDO

    /* OUTRA FORMA DE EXCLUSÃO COM BASE NO QUE ESTÁ NO GRID.
      SZ7->(dbSetOrder(2))
      For nLinAtu := 1 to Len(aColsAux)
          //Regrinha para verificar se a linha estÃ¡ excluÃ­da, se nÃ£o tiver irÃ¡ incluir
          IF SZ7->(DbSeek(cFilSZ7+cNum+aColsAux[nLinAtu][nPosItem]))
              RECLOCK("SZ7",.F.)
                  DbDelete()
              SZ7->(MsUnlock())
          Endif
      Next nLinAtu
    */	
  ENDIF

  RestArea(aArea)
Return lRet

/*/{Protheus.doc} User Function VldSZ7(cFilSZ7, cNum, dEmissao, cFornece, cLoja, cUser, cOption, aCols, aHeader, aArea)
  VldSZ7
  @type  Function
  @author arthurpedroti
  @since 18/03/2022
  @version 1
  /*/
User Function VldSZ7()
  Local lRet := .T.
  Local aArea := GetArea()

  // Instanciar os models para capturar os dados do cabeçalho
  Local oModel := FwModelActive()

  Local oModelCabec := oModel:GetModel("SZ7MASTER")

  Local cFilSZ7 := oModelCabec:GetValue("Z7_FILIAL")
  Local cNum := oModelCabec:GetValue("Z7_NUM")

  Local cOption := oModelCabec:GetOperation()

  IF cOption == MODEL_OPERATION_INSERT
    DbSelectArea("SZ7")
    SZ7->(DbSetOrder(1)) // filial+num
      // Se ele encontrar o numero do pedido na tabela, a variavel lRet retornara false,
      // e impedira a inserção na tabela
      IF SZ7->(DbSeek(cFilSZ7+cNum))
        lRet := .F.
        // Use o HELP, pois usando o alert e msginfo, ele aparece um mensagem de erro
        Help(Nil, Nil, "Escolha outro numero de pedido", Nil, "O numero do pedido informado ja existe na base de dados.", 1, 0, Nil, Nil, Nil, Nil, Nil, {"ATENÇÃO"})
      ENDIF
  ENDIF

  RestArea(aArea)
Return lRet
