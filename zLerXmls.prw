*****************************************************************************
*+-------------------------------------------------------------------------+*
*|Funcao      | zLerXmlS| Autor |  Luiz Alfredo                            |*
*+------------+------------------------------------------------------------+*
*|Data        | 31-03-2023                                                 |*
*+------------+------------------------------------------------------------+*
*|Descricao   | Leitura do Xml para integrar no Protheus.                  |*
*+------------+------------------------------------------------------------+*
*|Descricao   | Produto e Clientes                                         |*
*+------------+------------------------------------------------------------+*
*|Solicitante |                                                            |*
*+------------+------------------------------------------------------------+*
*|Arquivos    |                                                            |*
*+------------+------------------------------------------------------------+*
*|             ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            |*
*+-------------------------------------------------------------------------+*
*| Programador       |   Data   | Motivo da alteracao                      |*
*+-------------------+----------+------------------------------------------+*
*|                   |          |                                          |*
*+-------------------+----------+------------------------------------------+*
*****************************************************************************

#Include "Rwmake.Ch"
#Include "protheus.Ch"
#Include "TopConn.Ch"
#Include "Fileio.ch"
#Include "Colors.ch"
#include "TBICONN.ch"
#include "TBICODE.ch"
#include 'parmtype.ch'
#INCLUDE "FWMVCDEF.CH"

//Constantes
#Define STR_PULA    Chr(13)+Chr(10)

*----------------------*
User Function zLerXmls()
*----------------------*
     Local   aSV_Area    := GetArea()
     Local   aArquivos
     Local   nAtual 
     Local   cPastaLoc := "C:\XML\HORUS\"

     Public  lCFXMLS01   := .T.

     
     Private _aLog       := {} //Log de Erros 
     
     Private cFunName    := "CFXMLS01"

     Private cCadastro     := "Leitura XML - NFs Saidas"
     
     Private cPathSaidas   := AllTrim(SuperGetMV("CF_XMLSSAI",.F.,"\XML\HORUS\SAIDAS\"))
     Private cPathSProc    := AllTrim(SuperGetMV("CF_XMLSPRO",.F.,"\XML\HORUS\SAIDAS\Processados\"))
     Private cPathSErr     := AllTrim(SuperGetMV("CF_XMLSERR",.F.,"\XML\HORUS\SAIDAS\Erro\"))
     Private cPathSCanc    := AllTrim(SuperGetMV("CF_XMLSCAN",.F.,"\XML\HORUS\SAIDAS\canceladas\"))
     Private cPathLog      := AllTrim(SuperGetMV("CF_XMLLOG" ,.F.,"\XML\HORUS\Log\"))
     Private cExtArqs      := "*.xml"

     Private lDebug        := SuperGetMV("CF_XMLSDBG",.F.,.t.)

     Private oNfe
     Private nHandle  := 0
     Private oFont1   := TFont():New('Arial Black', Nil, 30, Nil, .T., Nil, Nil, Nil, Nil, .F., .F.)
     Private oFont2   := TFont():New('Arial Black', Nil, 26, Nil, .T., Nil, Nil, Nil, Nil, .F., .F.)
     DelClassIntF()
     cPathSaidas  += If(Right(cPathSaidas,1)!="\","\","")
     cPathSProc   += If(Right(cPathSProc ,1)!="\","\","")
     cPathSErr    += If(Right(cPathSErr  ,1)!="\","\","")
     cPathSCanc   += If(Right(cPathSCanc ,1)!="\","\","")
     cPathLog     += If(Right(cPathLog   ,1)!="\","\","")
     
     If !lIsdir(cPathSaidas); MakeDir(cPathSaidas); EndIf
     If !lIsdir(cPathSProc ); MakeDir(cPathSProc ); EndIf
     If !lIsdir(cPathSErr  ); MakeDir(cPathSErr  ); EndIf
     If !lIsdir(cPathSCanc ); MakeDir(cPathSCanc ); EndIf

     If !lIsdir(cPathLog   ); MakeDir(cPathLog   ); EndIf
        
     //Busca todos os pdfs da pasta local
     aDir(cPastaLoc + "*.xml", aArquivos)

     //Percorre todos os arquivos
     For nAtual := 1 To Len(aArquivos)
        __CopyFile(cPastaLoc + aArquivos[nAtual],  cPathSaidas + aArquivos[nAtual])
     Next
     
     //__CopyFile("C:\XML\HORUS\*.xml", cPathSaidas,,,.F. )

     //CpyT2S("C:\XML\HORUS\*.xml", cPathSaidas , .F. )

     //FErase("C:\XML\HORUS\*.*")

     *------------------------------*
     * Busca xmls de nfs de Saidas  *
     *------------------------------*
     If ApMSgYesNo("Processa nfs de Saídas ?")
        aFiles := Directory(cPathSaidas+cExtArqs, Nil, Nil, .T. )
        Processa({|| fLeXml(aFiles,"1")},"Aguarde", "Lendo arquivos XML de Nfs de Saídas...")
     EndIf
     RestArea(aSV_Area)
     Return
     
