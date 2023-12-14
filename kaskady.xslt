<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template name="getURL">
        <xsl:param name="jménoElementu" />
        <xsl:variable name="text" select="$jménoElementu" />
        <xsl:analyze-string select="$text" regex="(https?://[^ )]+)">
            <xsl:matching-substring>
            <a href="{.}" target="_blank">
                <xsl:value-of select="." />
            </a>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
            <xsl:value-of select="." />
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <!--<xsl:template match="podmínkypřijetí/html_text">
        <xsl:param name="jménoElementu" />
        <xsl:variable name="text" select="//*[local-name() = $jménoElementu]" />
         <xsl:analyze-string select="$text" regex="(https?://[^ )]+)">
            <xsl:matching-substring>
            <a href="{.}" target="_blank">
                <xsl:value-of select="." />
            </a>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
            <xsl:value-of select="." />
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>   -->     

    <xsl:template match="součásti_szz">        
        <xsl:value-of select="." disable-output-escaping="yes" />        
    </xsl:template>

    <xsl:template name="generujRozsah">
        <xsl:param name="semestr" />
        <xsl:choose>
                <xsl:when test="$semestr = 'ZS'">
                    <xsl:for-each select="výuka/plán/*">
                        <xsl:choose>
                            <xsl:when test="self::*[paralelní_skupina]">
                                <xsl:for-each select="*[1]">
                                    <xsl:variable name="rozsah" select="specifikace_výuky/rozsah * 13" />    
                                    <xsl:value-of select="$rozsah" />         
                                    <xsl:choose>
                                        <xsl:when test="../self::cvičení">
                                            <xsl:text>c</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="../self::seminář">
                                            <xsl:text>s</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>p</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose> 
                                    <xsl:if test="position() &lt; last()">
                                        +
                                    </xsl:if>                                         
                                </xsl:for-each>
                            </xsl:when>            
                            <xsl:otherwise>                                    
                                <xsl:variable name="rozsah" select="specifikace_výuky/rozsah * 13" />                                   
                                <xsl:value-of select="$rozsah" />
                                <xsl:choose>
                                    <xsl:when test="self::cvičení">
                                    <xsl:text>c</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="self::seminář">
                                        <xsl:text>s</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                    <xsl:text>p</xsl:text>
                                    </xsl:otherwise> 
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="position() &lt; last()">
                                        +
                        </xsl:if>               
                    </xsl:for-each>   
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="výuka/plán/*">
                        <xsl:choose>
                            <xsl:when test="self::*[paralelní_skupina]">
                                <xsl:for-each select="*[1]">
                                    <xsl:variable name="rozsah" select="specifikace_výuky/rozsah * 14" />        
                                    <xsl:value-of select="$rozsah" />
                                    <xsl:choose>
                                        <xsl:when test="../self::cvičení">
                                            <xsl:text>c</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="../self::seminář">
                                            <xsl:text>s</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>p</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:if test="position() &lt; last()">
                                        +
                                    </xsl:if>                                        
                                </xsl:for-each>
                            </xsl:when>
    
                            <xsl:otherwise>                                    
                                <xsl:variable name="rozsah" select="/specifikace_výuky/rozsah * 14" />                                   
                                <xsl:value-of select="$rozsah" />
                                <xsl:choose>
                                    <xsl:when test="self::cvičení">
                                    <xsl:text>c</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="self::seminář">
                                        <xsl:text>s</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                    <xsl:text>p</xsl:text>
                                    </xsl:otherwise>  
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose> 
                        <xsl:if test="position() &lt; last()">
                                +
                            </xsl:if>           
                    </xsl:for-each>   
                </xsl:otherwise>
        </xsl:choose>         
    </xsl:template>

    <xsl:template name="getVyučující">
        <xsl:choose>
            <xsl:when test="self::*[paralelní_skupina]">           
                <xsl:for-each-group select="*" group-by="specifikace_výuky/vyučující_ref">
                    <xsl:variable name="vyučujícíId" select="specifikace_výuky/vyučující_ref" />
                    <xsl:variable name="jménoVyučujícího" select="//vyučující[@id = $vyučujícíId]/jméno_příjmení" />
                    <xsl:variable name="titulyVyučujícíhoPřed" select="//vyučující[@id = $vyučujícíId]/tituly_před" />  
                    <xsl:variable name="titulyVyučujícíhoZa" select="//vyučující[@id = $vyučujícíId]/tituly_za" />                    
                    <b><xsl:value-of select="$titulyVyučujícíhoPřed"/><xsl:text> </xsl:text><xsl:value-of select="$jménoVyučujícího" />
                    <xsl:if test="$titulyVyučujícíhoZa != ''">,
                        <xsl:value-of select="$titulyVyučujícíhoZa"/>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="../self::cvičení">
                            <xsl:text> (cvičící)</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> (přednášející)</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="position() &lt; last()">
                        <br/>
                    </xsl:if></b>
                </xsl:for-each-group>
            </xsl:when>

            <xsl:otherwise>                                    
                <xsl:variable name="vyučujícíId" select="specifikace_výuky/vyučující_ref" />
                <xsl:variable name="jménoVyučujícího" select="//vyučující[@id = $vyučujícíId]/jméno_příjmení" />
                <xsl:variable name="titulyVyučujícíhoPřed" select="//vyučující[@id = $vyučujícíId]/tituly_před" />  
                <xsl:variable name="titulyVyučujícíhoZa" select="//vyučující[@id = $vyučujícíId]/tituly_za" />                    
                <b><xsl:value-of select="$titulyVyučujícíhoPřed"/><xsl:text> </xsl:text><xsl:value-of select="$jménoVyučujícího" />
                    <xsl:if test="$titulyVyučujícíhoZa != ''">,
                        <xsl:value-of select="$titulyVyučujícíhoZa"/>
                    </xsl:if>
                    <xsl:choose>
                    <xsl:when test="self::cvičení">
                        <xsl:text> (cvičící)</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> (přednášející)</xsl:text>
                    </xsl:otherwise>
                </xsl:choose></b>
            </xsl:otherwise>
        </xsl:choose>   
    </xsl:template>

<!-- Příklad šablony pro výpis jednotlivých elementů HTML fragmentu -->
<xsl:template match="*">
  <!-- Zde můžete provádět zpracování elementů HTML -->
  <xsl:copy-of select="." />
</xsl:template>

    <xsl:template match="/">
        <html>
        <head>
            <link rel="stylesheet" type="text/css" href="styles.css" />
        </head>
        <body>
            <!--<xsl:text>Procesor: </xsl:text>
            <xsl:value-of select="system-property('xsl:vendor')" />
            <xsl:text> verze </xsl:text>
            <xsl:value-of select="system-property('xsl:version')" />-->
            
            <xsl:apply-templates select="//program"/> 
            <xsl:apply-templates select="//plány/plán"/> 
            <xsl:apply-templates select="//předměty/předmět"/> <!--| //šablony/předmět-->
            <xsl:apply-templates select="//učitelé/vyučující"/>
            <xsl:apply-templates select="//program/související_činnost"/> 
            <xsl:apply-templates select="//program/informační_zabezpečení"/> 
            <xsl:apply-templates select="//program/materiální_zabezpečení"/> 
            <xsl:apply-templates select="//program/finanční_zabezpečení"/> 
            <xsl:apply-templates select="//program/záměrrozvoje"/>            

        </body>
        </html>
    </xsl:template>   

    <xsl:template match="program">
        <div style="margin-bottom: 20px;">
            <table border="1">
                <tr style="background-color:#bdd6ee">
                    <td colspan="9"><b>A-I – Základní informace o žádosti o akreditaci
                    </b></td>            
                </tr>
            </table>
            <tr>
                <td><b>Název vysoké školy:
                </b></td><br/>
                <td><xsl:value-of select="názevvš" /></td>
            </tr>
            <br/>
            <tr>
                <td><b>Název součásti vysoké školy:
                </b></td><br/>
                <td><xsl:value-of select="názevsoučástivš" /></td>
            </tr>
            <br/>
            <tr>
                <td><b>Název spolupracující instituce dle § 81 nebo § 95 odst. 4 ZVŠ:
                </b></td><br/>
                <td><xsl:value-of select="spolupracujícíinstituce" /></td>
            </tr>
            <br/>
            <tr>
                <td><b>Název studijního programu:

                </b></td><br/>
                <td><xsl:value-of select="jméno" /></td>
            </tr>
            <br/>
            <tr>
                <td><b>Typ žádosti o akreditaci:
                </b></td><br/>
                <td>
                    <xsl:variable name="typ_žádosti" select="typžádosti" />                                   
                    
                    <xsl:choose>
                        <xsl:when test="$typ_žádosti = 'udělení'">
                            <xsl:text>udělení akreditace</xsl:text>
                        </xsl:when>
                        <xsl:when test="$typ_žádosti = 'prodloužení'">
                            <xsl:text>prodloužení platnosti akreditace</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>rozšíření akreditace
                            </xsl:text>
                        </xsl:otherwise>

                    </xsl:choose>

                </td>             
            </tr>
            <br/>
            <tr>
                <td><b>Schvalující orgán:
                </b></td><br/>
                <td><xsl:value-of select="schvalujícíorgán" /></td>
            </tr>
            <br/>
            <xsl:variable name="datum" select="datumschválenížádosti" />
            <tr>
                <td><b>Datum schválení žádosti:</b></td><br/>
                <td>
                    <xsl:value-of select="substring($datum, 9, 2)" /><xsl:text>.</xsl:text>
                    <xsl:value-of select="substring($datum, 6, 2)" /><xsl:text>.</xsl:text>
                    <xsl:value-of select="substring($datum, 1, 4)" />
                </td>
            </tr>
            <br/>
            <tr>
                <td><b>Odkaz na elektronickou podobu žádosti:
                </b></td><br/>
                <td>
                    <xsl:call-template name="getURL">
                        <xsl:with-param name="jménoElementu" select="elpodobažádosti" />
                    </xsl:call-template>
                </td>
            </tr>
            <br/>
            <tr>
                <td><b>Odkaz na studijní opory pro kombinovanou/distanční formu studia:
                </b></td><br/>
                <td>
                    <xsl:call-template name="getURL">
                        <xsl:with-param name="jménoElementu" select="studijníopory" />
                    </xsl:call-template>
                </td>
            </tr>
            <br/>
            <tr>
                <td><b>Odkaz na příklady smluv o zajištění odborné praxe:
                </b></td><br/>
                <td>
                    <xsl:call-template name="getURL">
                        <xsl:with-param name="jménoElementu" select="praxe_odkaz" />
                    </xsl:call-template>
                </td>
            </tr>
            <br/>
            <tr>
                <td><b>Odkazy na relevantní vnitřní předpisy:
                </b></td><br/>
                <td>
                    <xsl:call-template name="getURL">
                        <xsl:with-param name="jménoElementu" select="vnitřnípředpisy" />
                    </xsl:call-template>
                </td>
            </tr>
            <br/>
            <tr>
                <td><b>Odkaz na poslední zprávu o vnitřním hodnocení vysoké školy:
                </b></td><br/>
                <td>
                </td>
            </tr>
            <br/>
            <tr>
                <td><b>ISCED F a stručné zdůvodnění:
                </b></td><br/>
                <td>
                </td>
            </tr>
            <br/>
        </div>

        <div style="margin-bottom: 20px;">
            <table border="1">
                <tr style="background-color:#bdd6ee">
                    <td colspan="9"><b>B-I – Charakteristika studijního programu
                    </b></td>            
                </tr>
                <tr>
                    <td style="background-color: #f7caac "><b>Název studijního programu</b></td>
                    <td colspan="9" ><xsl:value-of select="jméno" /></td>               
                </tr> 
                <tr>
                    <td style="background-color: #f7caac "><b>Typ studijního programu</b></td>
                    <td colspan="9" ><xsl:value-of select="typprogramu" /></td>               
                </tr> 
                <tr>
                    <td style="background-color: #f7caac "><b>Profil studijního programu</b></td>
                    <td colspan="9" ><xsl:value-of select="profilprogramu" /></td>               
                </tr> 
                <tr>
                    <td style="background-color: #f7caac "><b>Forma studia</b></td>
                    <td colspan="9" ><xsl:value-of select="formastudia" /></td>               
                </tr> 
                <tr>
                    <td style="background-color: #f7caac "><b>Standardní doba studia
                    </b></td>
                    <td colspan="9" ><xsl:value-of select="dobastudia" /></td>               
                </tr> 
                <tr>
                    <td style="background-color: #f7caac "><b>Jazyk studia
                    </b></td>
                    <td colspan="9" >
                        <xsl:variable name="jazyk" select="jazyk" />
                        <xsl:choose>
                            <xsl:when test="$jazyk = 'cs'">
                                <xsl:text>čeština</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>angličtina</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>                    
                    </td>               
                </tr> 
                <tr>
                    <td style="background-color: #f7caac "><b>Udělovaný akademický titul
                    </b></td>
                    <td colspan="9" ><xsl:value-of select="titul" /></td>               
                </tr> 
                <tr>
                    <td style="background-color: #f7caac "><b>Rigorózní řízení
                    </b></td>
                    <td>
                        <xsl:variable name="rigoróznířízení"  select="rigoróznířízení" />
                        <xsl:choose>
                            <xsl:when test="$rigoróznířízení = 'false'">
                                <xsl:text>ne</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>ano</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>     
                    </td>            
                    <td style="background-color: #f7caac "><b>Udělovaný akademický titul
                    </b></td>
                    <td colspan="3"><xsl:value-of select="rigoróznířízení_titul" /></td>       
                </tr> 
                <tr>
                    <td style="background-color: #f7caac "><b>Garant studijního programu
                    </b></td>
                    <td colspan="9" >                       
                        <xsl:variable name="garantId" select="garant_ref" />
                        <xsl:variable name="jménoGaranta" select="//vyučující[@id = $garantId]/jméno_příjmení" />
                        <xsl:variable name="titulyGarantaPřed" select="//vyučující[@id = $garantId]/tituly_před" />    
                        <xsl:variable name="titulyGarantaZa" select="//vyučující[@id = $garantId]/tituly_za" />    

                        <xsl:value-of select="$titulyGarantaPřed"/><xsl:text> </xsl:text><xsl:value-of select="$jménoGaranta" />
                        <xsl:if test="$titulyGarantaZa != ''">,
                            <xsl:value-of select="$titulyGarantaZa"/>
                        </xsl:if>                  
                    </td>               
                </tr> 
                <tr>
                    <td style="background-color: #f7caac "><b>Zaměření na přípravu k výkonu
                        regulovaného povolání
                    </b></td>
                    <td colspan="9">
                        <xsl:variable name="zaměřenívýkonu"  select="zaměřenívýkonu" />
                        <xsl:choose>
                            <xsl:when test="$zaměřenívýkonu = 'false'">
                                <xsl:text>ne</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>ano</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>     
                    </td>              
                </tr> 
                <tr>
                    <td style="background-color: #f7caac "><b>Zaměření na přípravu odborníků
                        z oblasti bezpečnosti České
                        republiky
                    </b></td>
                    <td colspan="9">
                        <xsl:variable name="zaměřeníodborníků"  select="zaměřeníodborníků" />
                        <xsl:choose>
                            <xsl:when test="$zaměřeníodborníků = 'false'">
                                <xsl:text>ne</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>ano</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>     
                    </td>              
                </tr>
                <tr>
                    <td style="background-color: #f7caac "><b>Uznávací orgán
                    </b></td>
                    <td colspan="9" ><xsl:value-of select="uznávacíorgán" /></td>               
                </tr> 
                <tr>
                    <td colspan="9" style="background-color: #f7caac "><b>Oblast(i) vzdělávání a u kombinovaného studijního programu podíl jednotlivých oblastí vzdělávání v %

                    </b></td>                                  
                </tr>  
                <tr>
                    <td colspan="9" ><xsl:value-of select="oblastivzdělávání/oblast/@jméno_oblasti" />
                    <xsl:text> </xsl:text> 
                    <xsl:value-of select="oblastivzdělávání/oblast/@procentuálnost" />%</td> 
                </tr>
                <tr>
                    <td colspan="9" style="background-color: #f7caac "><b>Cíle studia ve studijním programu
                    </b></td>                                  
                </tr>  
                <tr>
                    <td colspan="9" >
                    <xsl:value-of select="cílestudia/html_text" disable-output-escaping="yes"/></td> 
                </tr>
                <tr>
                    <td colspan="9" style="background-color: #f7caac "><b>Profil absolventa
                    </b></td>                                  
                </tr>  
                <tr>
                    <td colspan="9" >
                    <xsl:value-of select="profilabsolventa/html_text" disable-output-escaping="yes"/></td> 
                </tr>
                <tr>
                    <td colspan="9" style="background-color: #f7caac "><b>Předpokládaná uplatnitelnost absolventů na trhu práce
                    </b></td>                                  
                </tr>  
                <tr>
                    <td colspan="9" >
                    <xsl:value-of select="uplatnitelnostabsolventů/html_text" disable-output-escaping="yes"/></td> 
                </tr>
                <tr>
                    <td colspan="9" style="background-color: #f7caac "><b>Pravidla a podmínky pro tvorbu studijních plánů
                    </b></td>                                  
                </tr>  
                <tr>
                    <td colspan="9" >
                    <xsl:value-of select="pravdidlapodmínkyprotvorbu/html_text" disable-output-escaping="yes"/></td> 
                </tr>
                <tr>
                    <td colspan="9" style="background-color: #f7caac "><b>Podmínky k přijetí ke studiu</b></td>                                  
                </tr>  
                <tr>
                    <td colspan="9" >
                        <xsl:call-template name="getURL">
                            <xsl:with-param name="jménoElementu" select="podmínkypřijetí/html_text" />
                        </xsl:call-template>                    
                    </td> 
                </tr>
                <tr>
                    <td colspan="9" style="background-color: #f7caac "><b>Předpokládaný počet uchazečů zapsaných ke studiu ve studijním programu
                    </b></td>                                  
                </tr>  
                <tr>
                    <td colspan="9" >
                    <xsl:value-of select="početuchazečů"/></td> 
                </tr>
                <tr>
                    <td colspan="9" style="background-color: #f7caac "><b>Návaznost na další typy studijních programů
                    </b></td>                                  
                </tr>  
                <tr>
                    <td colspan="9" >
                    <xsl:value-of select="návaznost"/></td> 
                </tr>
            </table>            
        </div>
    </xsl:template>

    <xsl:template match="plán">

        <div style="margin-bottom: 20px;">
            <table border="1">
                <tr style="background-color:#bdd6ee">
                    <td colspan="9"><b>B-II – Studijní plány a návrh témat prací (bakalářské a magisterské studijní programy)
                    </b></td>            
                </tr>
                <tr>
                    <td colspan="3" style="background-color: #f7caac "><b>Označení studijního plánu
                    </b></td>         
                    <td colspan="6"><xsl:value-of select="označení" /></td>      
                </tr>
                <tr>
                    <td colspan="9" style="background-color: #f7caac; text-align:center "><b>Povinné předměty
                    </b></td>                
                </tr>
                <tr>
                    <td style="background-color: #f7caac"><b>Název předmětu</b></td>      
                    <td style="background-color: #f7caac"><b>rozsah</b></td>     
                    <td style="background-color: #f7caac"><b>způsob ověř.</b></td>     
                    <td style="background-color: #f7caac"><b>počet kred.</b></td>     
                    <td style="background-color: #f7caac"><b>vyučující</b></td>     
                    <td style="background-color: #f7caac"><b>dop. roč./sem.</b></td>     
                    <td style="background-color: #f7caac"><b>profil. základ</b></td>     
                </tr>

                <!--<tr>
                    <td></td>      
                    <td></td>     
                    <td></td>     
                    <td></td>     
                    <td></td>     
                    <td></td>     
                    <td></td>     
                </tr>-->
              
                <xsl:for-each select="skupiny/*">
                    <xsl:variable name="skupinaId" select="." />
                    <xsl:variable name="povinnáSkupina" select="//skupiny_předmětů/skupina_předmětů[@id = $skupinaId][typ = 'pk']/předměty" />
                    <xsl:variable name="povinněVolitelnáSkupina" select="//skupina_předmětů[@id = $skupinaId][typ = 'pvk']/předměty" />
                    <xsl:variable name="podmínka" select="//skupina_předmětů[@id = $skupinaId][typ = 'pvk']/podmínky_splnění" />
                    <xsl:variable name="volitelnáSkupina" select="//skupina_předmětů[@id = $skupinaId][typ = 'vk']" />   

                    <xsl:for-each select="$povinnáSkupina/*">
                        <tr>
                            <xsl:variable name="předmětId" select="." />
                            <xsl:variable name="předmětObjekt" select="//předmět[@id = $předmětId]" />
                            <xsl:for-each select="$předmětObjekt">
                                <xsl:variable name="semestr" select="semestr" />
                                <td><xsl:value-of select="název" /></td>
                                <td>
                                <xsl:call-template name="generujRozsah">
                                    <xsl:with-param name="semestr" select="$semestr" />
                                </xsl:call-template>
                            </td>
                            <td><xsl:value-of select="ověření_výsledků"/></td>
                            <td><xsl:value-of select="počet_kreditů"/></td>
                            <td>
                                <xsl:for-each select="výuka/plán/*">
                                <!--<xsl:value-of select="name()" />-->  
                                    <xsl:call-template name="getVyučující" />     
                                    <br/>                    
                                </xsl:for-each>
                            </td>
                            <td><xsl:value-of select="ročník"/> / <xsl:value-of select="semestr"/> </td>
                            <td><xsl:value-of select="typ"/></td>
                            </xsl:for-each>
                        </tr>
                    </xsl:for-each> 
                    
                    <xsl:for-each select="$povinněVolitelnáSkupina/*">
                        <tr>
                            <td colspan="9" style="background-color: #f7caac; text-align:center"><b>Povinně volitelné předměty</b></td>
                        </tr>

                        <tr>
                            <xsl:variable name="předmětId" select="." />
                            <xsl:variable name="předmětObjekt" select="//předmět[@id = $předmětId]" />
                            <xsl:for-each select="$předmětObjekt">
                                <xsl:variable name="semestr" select="semestr" />
                                <td><xsl:value-of select="název" /></td>
                                <td>
                                <xsl:call-template name="generujRozsah">
                                    <xsl:with-param name="semestr" select="$semestr" />
                                </xsl:call-template>
                            </td>
                            <td><xsl:value-of select="ověření_výsledků"/></td>
                            <td><xsl:value-of select="počet_kreditů"/></td>
                            <td>
                                <xsl:for-each select="výuka/plán/*">
                                <!--<xsl:value-of select="name()" />-->  
                                    <xsl:call-template name="getVyučující" />            
                                <br/>                    
                            </xsl:for-each>
                            </td>
                            <td><xsl:value-of select="ročník"/> / <xsl:value-of select="semestr"/> </td>
                            <td><xsl:value-of select="typ"/></td>
                            </xsl:for-each>
                        </tr>
                        <tr>
                            <td colspan="9"><b>Podmínka pro splnění této skupiny předmětů: </b><xsl:value-of select="$podmínka"/></td>
                        </tr>
                    </xsl:for-each>

                </xsl:for-each>

                <tr>
                    <td colspan="3" style="background-color: #f7caac"><b>Součásti SZZ a jejich obsah
                    </b></td>      
                    <td  colspan="6"><xsl:apply-templates select="součásti_szz/html_text"/></td>
                </tr>
                <tr>
                    <td colspan="3" style="background-color: #f7caac"><b>Další studijní povinnosti
                    </b></td>      
                    <td  colspan="6"><xsl:value-of select="studijnípovinnosti" /></td>                         
                </tr>
                <tr>
                    <td colspan="3" style="background-color: #f7caac"><b>Návrh témat kvalifikačních prací
                        /témata obhájených prací a přístup
                        k obhájeným kvalifikačním pracím
                    </b></td>      
                    <td  colspan="6">
                            <xsl:for-each select="návrhtémat/téma">
                              <li><xsl:value-of select="." /></li>
                            </xsl:for-each>
                       </td>                         
                </tr>

                <tr>
                    <td colspan="3" style="background-color: #f7caac"><b>Návrh témat rigorózních prací /témata
                        obhájených prací a přístup
                        k obhájeným rigorózním pracím                        
                    </b></td>      
                    <td  colspan="6">
                        <ul>
                            <xsl:for-each select="návrhtémat_rigorózní/téma_rigorózní">
                              <li><xsl:value-of select="." /></li>
                            </xsl:for-each>
                        </ul>
                    </td>                       
                </tr>

                <tr>
                    <td colspan="3" style="background-color: #f7caac"><b>Součásti SRZ a jejich obsah
                    </b></td>      
                    <td  colspan="6"><xsl:value-of select="součásti_srz" /></td>                         
                </tr>
               
            </table>            
        </div>
    </xsl:template>

    <xsl:template match="předmět">
        <xsl:variable name="semestr" select="semestr" />

        <div style="margin-bottom: 20px;">
        <table border="1">
            <tr style="background-color:#bdd6ee">
                <td colspan="9"><b>B-III - Charakteristika předmětu</b></td>            
            </tr>
            <tr>
                <td style="background-color: #f7caac"><b>Název</b></td>
                <td colspan="5"><xsl:value-of select="název" /></td>
            </tr>
            <tr>
                <td style="background-color: #f7caac "><b>Typ</b></td>
                <td><xsl:value-of select="typ" /></td>
                <td colspan="2" style="background-color: #f7caac "><b>Doporučený ročník / semestr</b></td>
                <td colspan="2"><xsl:value-of select="ročník"/> / <xsl:value-of select="$semestr" />
                </td>
            </tr>
            <tr>
                <td style="background-color: #f7caac "><b>Rozsah studijního předmětu</b></td>
                <td>
                    <xsl:call-template name="generujRozsah">
                        <xsl:with-param name="semestr" select="$semestr" />
                    </xsl:call-template>                            
                </td>
                <td style="background-color: #f7caac "><b>hod.</b></td>
                <td><xsl:value-of select="rozsah" /></td>
                <td style="background-color: #f7caac "><b>kreditů</b></td>
                <td><xsl:value-of select="počet_kreditů" /></td>
            </tr>             
            <tr>
                <td style="background-color: #f7caac"><b>Prerekvizity, korekvizity, ekvivalence</b></td>
                <td colspan="5">
                    <xsl:variable name="předmětId" select="prerekvizity" />
                    <xsl:variable name="názevPředmětu" select="//předmět[@id = $předmětId]/název" />
                    <xsl:value-of select="$názevPředmětu" />

                </td>
            </tr>       
            <tr>
                <td style="background-color: #f7caac "><b>Způsob ověření studijních výsledků</b></td>
                <td ><xsl:value-of select="ověření_výsledků" /></td>
                <td style="background-color: #f7caac "><b>Forma výuky</b></td>
                <td colspan="3">
                    <xsl:for-each select="výuka/plán/*">
                        <xsl:value-of select="concat(translate(substring(name(), 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), substring(name(), 2))" />
                        <xsl:if test="position() &lt; last()">,
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>   
            <tr>
                <td style="background-color: #f7caac "><b>Forma způsobu ověření studijních výsledků a další požadavky na studenta</b></td>
                <td colspan="5"><xsl:value-of select="forma_ověření" /></td>               
            </tr> 
            <tr>
                <td style="background-color: #f7caac "><b>Garant předmětu</b></td>
                <td colspan="5">
                    <xsl:variable name="garantId" select="garant_ref" />
                    <xsl:variable name="jménoGaranta" select="//vyučující[@id = $garantId]/jméno_příjmení" />
                    <xsl:variable name="titulyGarantaPřed" select="//vyučující[@id = $garantId]/tituly_před" />    
                        <xsl:variable name="titulyGarantaZa" select="//vyučující[@id = $garantId]/tituly_za" />    

                        <xsl:value-of select="$titulyGarantaPřed"/><xsl:text> </xsl:text><xsl:value-of select="$jménoGaranta" />
                        <xsl:if test="$titulyGarantaZa != ''">,
                            <xsl:value-of select="$titulyGarantaZa"/>
                        </xsl:if>                  
                </td>               
            </tr>     
            <tr>
                <td style="background-color: #f7caac "><b>Zapojení garanta do výuky předmětu</b></td>
                <td colspan="5">
                    <xsl:variable name="garantId" select="garant_ref" />
                    <xsl:variable name="jménoGaranta" select="//vyučující[@id = $garantId]/jméno_příjmení" />
                    <xsl:variable name="titulyGarantaPřed" select="//vyučující[@id = $garantId]/tituly_před" />    
                    <xsl:variable name="titulyGarantaZa" select="//vyučující[@id = $garantId]/tituly_za" />    
            
                    <xsl:variable name="prednasky" select="výuka/plán/*[self::přednáška or self::seminář]//specifikace_výuky/vyučující_ref" />

                    <xsl:variable name="cviceni" select="výuka/plán/cvičení//specifikace_výuky/vyučující_ref" />
            
                    <xsl:choose>
                        <xsl:when test="$garantId = $prednasky">
                               <xsl:value-of select="$titulyGarantaPřed"/><xsl:text> </xsl:text><xsl:value-of select="$jménoGaranta" />
                        <xsl:if test="$titulyGarantaZa != ''">,
                            <xsl:value-of select="$titulyGarantaZa"/>
                        </xsl:if>                  
                            (<xsl:text>přednášející</xsl:text>)
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="$garantId =  $cviceni">
                                       <xsl:value-of select="$titulyGarantaPřed"/><xsl:text> </xsl:text><xsl:value-of select="$jménoGaranta" />
                        <xsl:if test="$titulyGarantaZa != ''">,
                            <xsl:value-of select="$titulyGarantaZa"/>
                        </xsl:if>                  
                                    (<xsl:text>cvičící</xsl:text>)
                                </xsl:when>
                                <xsl:otherwise>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
            
                    <xsl:if test="zapojení_garanta">
                        <xsl:value-of select="zapojení_garanta/@podíl"/>
                    </xsl:if>
                </td>
            </tr>            
            <tr>
                <td style="background-color: #f7caac "><b>Vyučující</b></td>
                <td colspan="5">
                    
                <xsl:for-each select="výuka/plán/*">
                    <!--<xsl:value-of select="name()" />-->  
                        <xsl:call-template name="getVyučující" />   
                    <br/>                         
                </xsl:for-each>
                </td>
            </tr>
            <tr>
                <td style="background-color: #f7caac "><b>Stručná anotace předmětu</b></td>
                <td colspan="5"><xsl:value-of select="anotace/html_text" disable-output-escaping="yes" /></td>
            </tr>
            <tr>
                <td style="background-color: #f7caac "><b>Studijní literatura a studijní pomůcky</b></td>                
                <td colspan="5">
                    <xsl:call-template name="getURL">
                        <xsl:with-param name="jménoElementu" select="studijníliteratura" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td colspan="9" style="text-align: center; background-color: #f7caac "><b>Informace ke kombinované nebo distanční formě</b></td>               
            </tr>
            <tr>
                <td  style="text-align: center; background-color: #f7caac "><b>Rozsah konzultací (soustředění)</b></td>    
                <td ><xsl:value-of select="konzultace/rozsah" /></td>     
                <td colspan="5" style="text-align: center; background-color: #f7caac "><b>hodin</b></td>       
            </tr>
            <tr>
                <td colspan="9" style="text-align: center; background-color: #f7caac "><b>Informace o způsobu kontaktu s vyučujícím</b></td>               
            </tr>
            <tr>
                <td colspan="9"><xsl:value-of select="konzultace/info" /></td>               
            </tr>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="vyučující">

        <xsl:variable name="vyučujícíId" select="@id"></xsl:variable>

        <div style="margin-bottom: 20px;">
            <table border="1">
                <tr style="background-color:#bdd6ee">
                    <td colspan="9"><b>C-I – Personální zabezpečení</b></td>            
                </tr>
                <tr>
                    <td style="background-color: #f7caac"><b>Vysoká škola
                    </b></td>
                    <td colspan="9"><xsl:value-of select="../../názevvš" /></td>
                </tr>
                <tr>
                    <td style="background-color: #f7caac"><b>Součást vysoké školy                        
                    </b></td>
                    <td colspan="9"><xsl:value-of select="../../názevsoučástivš" /></td>
                </tr>               
                <tr>
                    <td style="background-color: #f7caac"><b>Název studijního programu
                    </b></td>
                    <td colspan="9"><xsl:value-of select="../../jméno" /></td>
                </tr>                
                <tr>
                    <td style="background-color: #f7caac"><b>Jméno a příjmení</b></td>
                    <td  colspan="4" ><xsl:value-of select="jméno_příjmení" /></td>
                    <td style="background-color: #f7caac"><b>Tituly</b></td>
                    <td colspan="2"><xsl:value-of select="tituly" /></td>
                </tr>
                <tr>
                    <td style="background-color: #f7caac"><b>Rok narození</b></td>
                    <td ><xsl:value-of select="rok_narození" /></td>
                    <td style="background-color: #f7caac"><b>typ vztahu k VŠ</b></td>
                    <td ><xsl:value-of select="typ_vztahu" /></td>
                    <td style="background-color: #f7caac"><b>rozsah</b></td>
                    <td ><xsl:value-of select="vš_vztah/rozsah" /></td>
                    <td style="background-color: #f7caac"><b>dokdy</b></td>
                    <td ><xsl:value-of select="vš_vztah/dokdy" /></td>
                </tr>
                <tr>
                    <td colspan="3" style="background-color: #f7caac"><b>Typ vztahu na součásti VŠ, která uskutečňuje st.
                        program
                        </b></td>                    
                    <td ><xsl:value-of select="součástvš_vztah/typ_vztahu" /></td>
                    <td style="background-color: #f7caac"><b>rozsah</b></td>
                    <td ><xsl:value-of select="součástvš_vztah/rozsah" /></td>
                    <td style="background-color: #f7caac"><b>dokdy</b></td>
                    <td ><xsl:value-of select="součástvš_vztah/dokdy" /></td>
                </tr>
                <tr>
                    <td colspan="4" style="background-color: #f7caac"><b>Další současná působení jako akademický pracovník na jiných VŠ </b></td>
                    
                    <td colspan="2" style="background-color: #f7caac"><b>typ prac. vztahu</b></td>
                    <td colspan="2" style="background-color: #f7caac"><b>rozsah</b></td>                   
                </tr>
                
                <xsl:choose>
                    <xsl:when test="jiné_vš">
                        <xsl:for-each select="jiné_vš">
                            <tr>
                                <td colspan="4" ><xsl:value-of select="název_sídlo"/></td>
                                <td colspan="2"><xsl:value-of select="typ_vztahu"/></td>
                                <td colspan="2" ><xsl:value-of select="rozsah"/> hod./týden</td>   
                            </tr>                     
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
                            <td colspan="4" ></td>
                            <td colspan="2"></td>
                            <td colspan="2" ></td>   
                        </tr>   
                    </xsl:otherwise>
                </xsl:choose>
                <tr>
                    <td colspan="9" style="background-color: #f7caac"><b>Předměty příslušného studijního programu a způsob zapojení do jejich výuky, příp. další zapojení do
                        uskutečňování studijního programu</b></td>                                
                </tr>
                <tr>
                    <td colspan="9">
                        
                    </td>                                
                </tr>
                <tr>
                    <td colspan="9" style="background-color: #f7caac"><b>Zapojení do výuky v dalších studijních programech na téže vysoké škole (pouze u garantů ZT a PZ předmětů)
                    </b></td>                                
                </tr>  
                <tr>
                    <td colspan="2"><b>Název studijního předmětu</b></td>
                    <td colspan="2"><b>Název studijního
                        programu</b></td>
                    <td><b>Sem.</b></td>
                    <td><b>Role ve výuce daného
                        předmětu</b></td>
                    <td colspan="2"><b><i>(nepovinný údaj)</i>
                        Počet hodin za
                        semestr</b></td>
                </tr>                  
                <xsl:choose>
                    <xsl:when test="jiné_programy">
                        <xsl:for-each select="jiné_programy">
                            <tr>
                                <td colspan="2" ><xsl:value-of select="jiný_předmět"/></td>
                                <td colspan="2"><xsl:value-of select="jiný_program"/></td>
                                <td><xsl:value-of select="semestr"/></td>   
                                <td><xsl:value-of select="role"/></td>  
                                <td colspan="2"><xsl:value-of select="počet_hodin"/></td>  
                            </tr>                     
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
                            <td colspan="2" ></td>
                            <td colspan="2"></td>
                            <td colspan="" ></td>  
                            <td colspan="" ></td> 
                            <td colspan="2" ></td>  
                        </tr>   
                    </xsl:otherwise>
                </xsl:choose>
                <tr>
                    <td colspan="9" style="background-color: #f7caac"><b>Údaje o vzdělání na VŠ 
                    </b></td>                                
                </tr>        
                <tr>
                    <td><b>od</b></td>
                    <td><b>do</b></td>
                    <td colspan="3"><b>zkratka názvu absolvované VŠ a fakulty </b></td>
                    <td colspan="3"><b>studijní program a obor</b></td>
                </tr>    
               
                <xsl:for-each select="vzdělání/studium">
                    <xsl:sort select="od" data-type="number" order="descending" />
                    <tr>
                        <td><xsl:value-of select="od"/></td>
                        <td><xsl:value-of select="do"/></td>
                        <td colspan="3"><xsl:value-of select="vš_fakulta"/></td>
                        <td colspan="3"><xsl:value-of select="studijní_program"/>

                            <xsl:if test="string(obor)">
                                <!-- Pokud element 'od' existuje a není prázdný -->
                                , obor <xsl:value-of select="obor"/>
                            </xsl:if>
                            (<xsl:value-of select="max_vzdělání"/>)
                        
                        </td>
                    </tr> 
                </xsl:for-each>
                <tr>
                    <td colspan="9" style="background-color: #f7caac"><b>Údaje o odborném působení od absolvování VŠ
                    </b></td>                                
                </tr>
                <tr>
                    <td colspan="2"><b>Stručný název zaměstnavatele</b></td>
                    <td colspan="2"><b>Zastávaná pozice</b></td>
                    <td><b>Rok počátku působení</b></td>
                    <td><b>Rok
                        konce působení </b></td>
                    <td colspan="2"><b>Typ pracovně-právního vztahu</b></td>
                </tr>           
                <xsl:choose>
                    <xsl:when test="odborné_působení">
                        <xsl:for-each select="odborné_působení/působení">
                            <xsl:sort select="od" data-type="number" order="descending" />
                            <tr>
                                <td colspan="2" ><xsl:value-of select="zaměstnavatel"/></td>
                                <td colspan="2"><xsl:value-of select="pozice"/></td>
                                <td><xsl:value-of select="od"/></td>   
                                <td><xsl:value-of select="do"/></td>  
                                <td colspan="2"><xsl:value-of select="typ_vztahu"/></td>  
                            </tr>                     
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
                            <td colspan="2" ></td>
                            <td colspan="2"></td>
                            <td colspan="" ></td>  
                            <td colspan="" ></td> 
                            <td colspan="2" ></td>  
                        </tr>   
                    </xsl:otherwise>
                </xsl:choose>  
                <tr>
                    <td colspan="9" style="background-color: #f7caac"><b>Zkušenosti s vedením kvalifikačních a rigorózních prací
                    </b></td>                                
                </tr>    
                <tr>
                    <td colspan="9">
                        <xsl:for-each select="zkušenosti/*">
                            <xsl:value-of select="name()" /> práce - <xsl:value-of select="." /><br />
                        </xsl:for-each>
                    </td>                                
                </tr>      
                <tr>
                    <td colspan="2" style="background-color: #f7caac"><b>Obor habilitačního řízení </b></td>     
                    <td style="background-color: #f7caac"><b>Rok udělení hodnosti</b></td>   
                    <td colspan="2" style="background-color: #f7caac"><b>Řízení konáno na VŠ</b></td>   
                    <td colspan="3" style="background-color: #f7caac; text-align: center;"><b>Ohlasy publikací</b></td>                              
                </tr>                  
                <tr>
                    <xsl:choose>
                        <xsl:when test="habilitační_řízení">
                            <xsl:for-each select="habilitační_řízení/*">
                                <tr>
                                    <td colspan="2" ><xsl:value-of select="obor"/></td>     
                                    <td ><xsl:value-of select="rok"/></td>   
                                    <td colspan="2"><xsl:value-of select="vš"/></td>  
                                    <td style="background-color: #f7caac"><b>WoS</b></td>   
                                    <td style="background-color: #f7caac"><b>Scopus</b></td>   
                                    <td style="background-color: #f7caac"><b>ostatní</b></td>   
                                </tr>                     
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <tr>
                                <td colspan="2"></td>
                                <td></td>
                                <td colspan="2"></td>   
                                <td style="background-color: #f7caac"><b>WoS</b></td>   
                                <td style="background-color: #f7caac"><b>Scopus</b></td>   
                                <td style="background-color: #f7caac"><b>ostatní</b></td>   
                            </tr>   
                        </xsl:otherwise>
                    </xsl:choose>                                         
                </tr>
                <tr>
                    <td colspan="2" style="background-color: #f7caac"><b>Obor jmenovacího řízení </b></td>     
                    <td style="background-color: #f7caac"><b>Rok udělení hodnosti</b></td>   
                    <td colspan="2" style="background-color: #f7caac"><b>Řízení konáno na VŠ</b></td>   
                    <xsl:choose>
                        <xsl:when test="ohlasy">
                                                        
                            <td ><xsl:value-of select="ohlasy/wos"/></td>     
                            <td ><xsl:value-of select="ohlasy/scopus"/></td>   
                            <td ><xsl:value-of select="ohlasy/ostatní"/></td>                                            
                           
                        </xsl:when>
                        <xsl:otherwise>                           
                                <td></td>
                                <td></td>
                                <td></td>                        
                        </xsl:otherwise>
                    </xsl:choose>   
                </tr>    
                <tr>
                    <xsl:choose>
                        <xsl:when test="jmenovací_řízení">
                            <xsl:for-each select="jmenovací_řízení/*">
                                <tr>
                                    <td colspan="2" ><xsl:value-of select="obor"/></td>     
                                    <td ><xsl:value-of select="rok"/></td>   
                                    <td colspan="2"><xsl:value-of select="vš"/></td>  
                                    <td colspan="2" style="background-color: #f7caac"><b>H-index
                                        WoS/Scopus</b></td>                                      
                                    <td></td>   
                                </tr>                     
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <tr>
                                <td colspan="2"></td>
                                <td></td>
                                <td colspan="2"></td>   
                                <td colspan="2" style="background-color: #f7caac"><b>H-index
                                    WoS/Scopus</b></td>                                      
                                <td></td>    
                            </tr>   
                        </xsl:otherwise>
                    </xsl:choose>                                         
                </tr> 
                <tr>
                    <td colspan="9" style="background-color: #f7caac"><b>Přehled o nejvýznamnější publikační a další tvůrčí činnosti nebo další profesní činnosti u odborníků z praxe
                        vztahující se k zabezpečovaným předmětům 
                    </b></td>                                
                </tr>       
                <tr>                    
                    <xsl:choose>
                        <xsl:when test="publikační_činnost">                        
                            <td colspan="9"><xsl:value-of select="publikační_činnost"/></td>                                              
                        </xsl:when>
                        <xsl:otherwise>                               
                            <td colspan="9"></td>                                    
                        </xsl:otherwise>
                    </xsl:choose>                                              
                </tr>     
                <tr>
                    <td colspan="9" style="background-color: #f7caac"><b>Působení v zahraničí
                    </b></td>                                
                </tr>       
                <tr>                    
                    <xsl:choose>
                        <xsl:when test="publikační_činnost">                        
                            <td colspan="9"><xsl:value-of select="zahraničí"/></td>                                              
                        </xsl:when>
                        <xsl:otherwise>                               
                            <td colspan="9"></td>                                    
                        </xsl:otherwise>
                    </xsl:choose>                                              
                </tr>       
                <tr>
                    <td colspan="2" style="background-color: #f7caac"><b>Podpis
                    </b></td>    
                    <td colspan="3" ></td>         
                    <td style="background-color: #f7caac"><b>Datum
                    </b></td>   
                    <td colspan="2"></td>                         
                </tr>      
                       
            </table>
        </div>
    </xsl:template>

    <xsl:template match="související_činnost">
        <!-- Zde můžete provést transformaci pro element "program" -->
        <div style="margin-bottom: 20px;">
            <table border="1">
                <tr style="background-color:#bdd6ee">
                    <td colspan="9"><b>C-II – Související tvůrčí, resp. vědecká a umělecká činnost
                    </b></td>            
                </tr>
                <tr>
                    <td  colspan="9" style="background-color: #f7caac "><b>Přehled řešených grantů a projektů u akademicky zaměřeného bakalářského studijního programu
                        a u magisterského a doktorského studijního programu
                    </b></td>                          
                </tr>     
                <tr>
                    <td style="background-color: #f7caac"><b>Řešitel/spoluřešitel </b></td>                    
                    <td style="background-color: #f7caac"><b>Názvy grantů a projektů získaných pro vědeckou, výzkumnou,
                        uměleckou a další tvůrčí činnost v příslušné oblasti vzdělávání</b></td>
                    <td style="background-color: #f7caac"><b>Zdroj</b></td>  
                    <td style="background-color: #f7caac"><b>Období</b></td>            
                </tr> 
                <xsl:choose>
                    <xsl:when test="akademicky">
                        <xsl:for-each select="akademicky">
                            <tr>
                                <td ><xsl:value-of select="řešitel"/></td>
                                <td><xsl:value-of select="název"/></td>
                                <td><xsl:value-of select="zdroj"/></td>   
                                <td><xsl:value-of select="od"/> - <xsl:value-of select="do"/> </td>   
                            </tr>                     
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr>
                            <td></td>
                            <td ></td>
                            <td ></td>   
                            <td ></td>   
                        </tr>   
                    </xsl:otherwise>
                </xsl:choose>
                <tr>
                    <td  colspan="9" style="background-color: #f7caac "><b>Přehled řešených projektů a dalších aktivit v rámci spolupráce s praxí u profesně zaměřeného bakalářského
                        a magisterského studijního programu                        
                    </b></td>                          
                </tr> 
                <tr>
                    <td style="background-color: #f7caac"><b>Pracoviště praxe </b></td>                    
                    <td style="background-color: #f7caac"><b>Název či popis projektu uskutečňovaného ve spolupráci s praxí</b></td>
                    <td colspan="2" style="background-color: #f7caac"><b>Období</b></td>                              
                </tr>
                <xsl:choose>
                    <xsl:when test="profesně">
                        <xsl:for-each select="profesně">
                            <tr>
                                <td ><xsl:value-of select="pracoviště"/></td>
                                <td><xsl:value-of select="název"/></td>                                   
                                <td colspan="2" ><xsl:value-of select="od"/> - <xsl:value-of select="do"/> </td>   
                            </tr>                     
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>                        
                        <tr>
                            <td></td>
                            <td></td>
                            <td ></td>   
                            <td colspan="2" ></td>   
                        </tr>   
                    </xsl:otherwise>
                </xsl:choose>
                <tr>
                    <td  colspan="9" style="background-color: #f7caac "><b>Odborné aktivity vztahující se k tvůrčí, resp. vědecké a umělecké činnosti vysoké školy, která souvisí se studijním
                        programem        
                    </b></td>                          
                </tr>          
                <tr>
                    <td colspan="9"><xsl:value-of select="odborné_aktivity"/></td>
                </tr>  
                <tr>
                    <td  colspan="9" style="background-color: #f7caac "><b>Informace o spolupráci s praxí vztahující se ke studijnímu programu 
                    </b></td>                          
                </tr>          
                <tr>
                    <td colspan="9"><xsl:value-of select="praxe_spolupráce"/></td>
                </tr>          
            </table>            
        </div>        
    </xsl:template>

    <xsl:template match="informační_zabezpečení">
        <!-- Zde můžete provést transformaci pro element "program" -->
        <div style="margin-bottom: 20px;">
            <table border="1">
                <tr style="background-color:#bdd6ee">
                    <td colspan="9"><b>C-III – Informační zabezpečení studijního programu
                    </b></td>            
                </tr>
                <tr>
                    <td colspan="9" style="background-color: #f7caac "><b>Název a stručný popis studijního informačního systému 
                    </b></td>                          
                </tr>
                <tr style="min-height: 150px">
                    <td colspan="9"><xsl:value-of select="název_popis" /></td>           
                </tr>
                <tr>
                    <td colspan="9" style="background-color: #f7caac "><b>Přístup ke studijní literatuře
                    </b></td>                  
                </tr>
                <tr style="min-height: 150px">
                    <td colspan="9">                   
                     <xsl:call-template name="getURL">
                        <xsl:with-param name="jménoElementu" select="literatura" />
                    </xsl:call-template>
                    </td>       
                </tr>
                <tr>
                    <td colspan="9" style="background-color: #f7caac "><b>Přehled zpřístupněných databází
                    </b></td>                          
                </tr>
                <tr style="min-height: 150px">
                    <td colspan="9">
                    <xsl:call-template name="getURL">
                        <xsl:with-param name="jménoElementu" select="databáze" />
                    </xsl:call-template>
                    </td>           
                </tr>
                <tr>
                    <td colspan="9" style="background-color: #f7caac "><b>Název a stručný popis používaného antiplagiátorského systému
                    </b></td>                  
                </tr>
                <tr style="min-height: 150px">
                    <td colspan="9">
                    <xsl:call-template name="getURL">
                        <xsl:with-param name="jménoElementu" select="antiplag_systém" />
                    </xsl:call-template>
                    </td>       
                </tr>
            </table>            
        </div>
    </xsl:template>

    <xsl:template match="materiální_zabezpečení">
        <!-- Zde můžete provést transformaci pro element "program" -->
        <div style="margin-bottom: 20px;">
            <table border="1">
                <tr style="background-color:#bdd6ee">
                    <td colspan="9"><b>C-IV – Materiální zabezpečení studijního programu
                    </b></td>            
                </tr>
                <tr>
                    <td colspan="4" style="background-color: #f7caac "><b>Místo uskutečňování studijního
                        programu 
                    </b></td>         
                    <td colspan="9"><xsl:value-of select="místo" /></td>                   
                </tr>
                <xsl:for-each select="výukové_místnosti/specifikace_kapacit">
                    <tr>
                        <td colspan="9" style="background-color: #f7caac "><b>Kapacita výukových místností pro teoretickou výuku</b></td>
                    </tr>       
                    <tr>
                        <td colspan="9"><xsl:value-of select="učebna_kapacita/@název" /> - <xsl:value-of select="učebna_kapacita/@kapacita" /></td>           
                    </tr>  
                    <tr>
                        <td colspan="4" style="background-color: #f7caac "><b>Z toho kapacita v prostorách
                            v nájmu</b></td>   
                        <td><xsl:value-of select="pronájem" /></td> 
                        <td colspan="3" style="background-color: #f7caac "><b>Doba platnosti nájmu</b></td>   
                        <td><xsl:value-of select="platnost_nájmu" /></td> 
                    </tr>             
                </xsl:for-each>               
                <xsl:for-each select="odborné_učebny/specifikace_kapacit">
                    <tr>
                        <td colspan="9" style="background-color: #f7caac "><b>Kapacita a popis odborné učebny</b></td>
                    </tr>       
                    <tr>
                        <td colspan="9"><xsl:value-of select="učebna_kapacita/@název" /> - <xsl:value-of select="učebna_kapacita/@kapacita" /></td>           
                    </tr>  
                    <tr>
                        <td colspan="4" style="background-color: #f7caac "><b>Z toho kapacita v prostorách
                            v nájmu</b></td>   
                        <td><xsl:value-of select="pronájem" /></td> 
                        <td colspan="3" style="background-color: #f7caac "><b>Doba platnosti nájmu</b></td>   
                        <td><xsl:value-of select="platnost_nájmu" /></td> 
                    </tr>             
                </xsl:for-each>                           
            </table>            
        </div>
    </xsl:template>

    <xsl:template match="finanční_zabezpečení">
        <!-- Zde můžete provést transformaci pro element "program" -->
        <div style="margin-bottom: 20px;">
            <table border="1">
                <tr style="background-color:#bdd6ee">
                    <td colspan="9"><b>C-V – Finanční zabezpečení studijního programu
                    </b></td>            
                </tr>
                <tr>
                    <td  style="background-color: #f7caac "><b>Vzdělávací činnost vysoké školy financovaná ze
                        státního rozpočtu
                    </b></td>
                    <td colspan="2">
                        <xsl:variable name="státní_rozpočet" select="@státní_rozpočet" />
                        <xsl:choose>
                            <xsl:when test="$státní_rozpočet = 'true'">
                                <xsl:text>ano</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>ne</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>                    
                    </td>                             
                </tr>                
                <tr>
                    <td colspan="9" style="background-color: #f7caac "><b>Zhodnocení předpokládaných nákladů a zdrojů na uskutečňování studijního programu
                    </b></td>                  
                </tr>
                <tr style="min-height: 150px">
                    <td colspan="9"><xsl:value-of select="zhodnocení" /></td>          
                </tr>
            </table>            
        </div>
    </xsl:template>

    <xsl:template match="záměrrozvoje">
        <!-- Zde můžete provést transformaci pro element "program" -->
        <div style="margin-bottom: 20px;">
            <table border="1">
                <tr style="background-color:#bdd6ee">
                    <td colspan="9"><b>D-I – Záměr rozvoje studijního programu a další údaje ke studijnímu programu
                    </b></td>            
                </tr>
                <tr>
                    <td  style="background-color: #f7caac "><b>Záměr rozvoje studijního programu a jeho odůvodnění
                    </b></td>                          
                </tr>
                <tr style="min-height: 150px">
                    <td colspan="9"><xsl:value-of select="text()" /></td>           
                </tr>
                <tr>
                    <td  style="background-color: #f7caac "><b>Systém výuky v distanční a kombinované formě studia
                    </b></td>                  
                </tr>
                <tr style="min-height: 150px">
                    <td colspan="9"><xsl:value-of select="../systémvýuky" /></td>      
                </tr>
            </table>            
        </div>
    </xsl:template>
</xsl:stylesheet>
