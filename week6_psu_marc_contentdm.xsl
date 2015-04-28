<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    MARCXML - CONTENTdm XSL Stylesheet
    Written October 2009 at Pennsylvania State University Libraries
    Some code taken without permission from the Library of Congress MARC-MODS Conversion Stylesheet.
    Released under a Creative Commons Attribution-Non-Commercial-ShareAlike license.
    
    Converts MARCXML-encoded XML files to comma-separated text for ingest into CONTENTdm repository.
    Contact:
        Kevin Clair, Metadata Librarian
        Pennsylvania State University Libraries
        kmc35@psu.edu
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:mods="http://www.loc.gov/mods/v3"
      xmlns:marc="http://www.loc.gov/MARC21/slim"
      exclude-result-prefixes="xs mods"
      version="2.0">
    
    <xsl:output indent="no" method="text" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <xsl:text>"Title"&#09;"Alternate Title"&#09;"Author"&#09;"Contributors"&#09;"Resource Type"&#09;"Genre"&#09;"Publisher"&#09;"Place of Publication"&#09;"Date of Publication"&#09;"Edition"&#09;"Series"&#09;"Language"&#09;"Form"&#09;"File Format"&#09;"Extent"&#09;"Digital Origin"&#09;"Description"&#09;"Notes"&#09;"Audience"&#09;"Subject"&#09;"Location"&#09;"Date Coverage"&#09;"Identifier"&#09;"ISBN"&#09;"Page Identifier"&#09;"Table of Contents"&#09;"Repository"&#09;"Rights Statement"&#09;"Access Restrictions"&#09;"Preferred Citation"&#09;"Collection"&#09;"Sub-collection"&#09;"Source"&#09;"Cataloger"&#09;"Date Cataloged"&#09;"Cataloging Notes"&#09;"Full Text"&#09;"Thumbnail"&#09;"Transcript"&#09;"OCLC Number"&#10;</xsl:text>
        <xsl:choose>
            <xsl:when test="marc:collection">
                <xsl:apply-templates select="marc:collection"/>
            </xsl:when>
            <xsl:when test="marc:record">
                <xsl:apply-templates select="marc:record"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="marc:collection">
        <xsl:apply-templates select="marc:record"/>
    </xsl:template>
    
    <xsl:template match="marc:record">
        <!-- declare variables -->
        <xsl:variable name="leader" select="marc:leader"/>
        <xsl:variable name="leader6" select="substring($leader,7,1)"/>
        <xsl:variable name="leader7" select="substring($leader,8,1)"/>
        <xsl:variable name="controlField008" select="marc:controlfield[@tag='008']"/>
        <xsl:variable name="typeOf008">
            <xsl:choose>
                <xsl:when test="$leader6='a'">
                    <xsl:choose>
                        <xsl:when
                            test="$leader7='a' or $leader7='c' or $leader7='d' or $leader7='m'">BK</xsl:when>
                        <xsl:when test="$leader7='b' or $leader7='i' or $leader7='s'">SE</xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$leader6='t'">BK</xsl:when>
                <xsl:when test="$leader6='p'">MM</xsl:when>
                <xsl:when test="$leader6='m'">CF</xsl:when>
                <xsl:when test="$leader6='e' or $leader6='f'">MP</xsl:when>
                <xsl:when test="$leader6='g' or $leader6='k' or $leader6='o' or $leader6='r'">VM</xsl:when>
                <xsl:when test="$leader6='c' or $leader6='d' or $leader6='i' or $leader6='j'">MU</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="oclc_number">
            <xsl:if test="marc:datafield[@tag='035']/marc:subfield[@code='a']">
                <xsl:for-each select="marc:datafield[@tag='035']/marc:subfield[@code='a']">
                    <xsl:analyze-string select="."
                        regex="^\(OCoLC\)(\d+)$">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:text></xsl:text>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:for-each>
            </xsl:if>
        </xsl:variable>
        
        <!-- [1] Title and [2] Alternate Title(s) -->
        <xsl:call-template name="titles"/>
        
        <!-- [3] Author and [4] Contributors -->
        <xsl:call-template name="names"/>
        
        <!-- [5] Resource Type -->
        <xsl:text>"</xsl:text>
        <xsl:choose>
            <xsl:when test="$leader6='a' or $leader6='t'">text</xsl:when>
            <xsl:when test="$leader6='e' or $leader6='f'">cartographic</xsl:when>
            <xsl:when test="$leader6='c' or $leader6='d'">notated music</xsl:when>
            <xsl:when test="$leader6='i'">sound recording-nonmusical</xsl:when>
            <xsl:when test="$leader6='j'">sound recording-musical</xsl:when>
            <xsl:when test="$leader6='k'">still image</xsl:when>
            <xsl:when test="$leader6='g'">moving image</xsl:when>
            <xsl:when test="$leader6='r'">three dimensional object</xsl:when>
            <xsl:when test="$leader6='m'">software, multimedia</xsl:when>
            <xsl:when test="$leader6='p'">mixed material</xsl:when>
        </xsl:choose>
        <xsl:text>"&#09;</xsl:text>

        <!-- [6] Genre -->
        
        <xsl:text>"</xsl:text>
        <xsl:if test="substring($controlField008,26,1)='d'">
			<xsl:text>globe</xsl:text>
		</xsl:if>
		<xsl:if
			test="marc:controlfield[@tag='007'][substring(text(),1,1)='a'][substring(text(),2,1)='r']">
			<xsl:text>remote-sensing image</xsl:text>
		</xsl:if>
		<xsl:if test="$typeOf008='MP'">
			<xsl:variable name="controlField008-25" select="substring($controlField008,26,1)"/>
			<xsl:choose>
				<xsl:when test="$controlField008-25='a' or $controlField008-25='b' or $controlField008-25='c' or marc:controlfield[@tag=007][substring(text(),1,1)='a'][substring(text(),2,1)='j']">
					<xsl:text>map</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-25='e' or marc:controlfield[@tag=007][substring(text(),1,1)='a'][substring(text(),2,1)='d']">
					<xsl:text>atlas</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="$typeOf008='SE'">
			<xsl:variable name="controlField008-21" select="substring($controlField008,22,1)"/>
			<xsl:choose>
				<xsl:when test="$controlField008-21='d'">
					<xsl:text>database</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-21='l'">
					<xsl:text>loose-leaf</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-21='m'">
					<xsl:text>series</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-21='n'">
					<xsl:text>newspaper</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-21='p'">
					<xsl:text>periodical</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-21='w'">
					<xsl:text>web site</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="$typeOf008='BK' or $typeOf008='SE'">
			<xsl:variable name="controlField008-24" select="substring($controlField008,25,4)"/>
			<xsl:choose>
				<xsl:when test="contains($controlField008-24,'a')">
					<xsl:text>abstract or summary</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'b')">
					<xsl:text>bibliography</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'c')">
					<xsl:text>catalog</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'d')">
					<xsl:text>dictionary</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'e')">
					<xsl:text>encyclopedia</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'f')">
					<xsl:text>handbook</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'g')">
					<xsl:text>legal article</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'i')">
					<xsl:text>index</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'k')">
					<xsl:text>discography</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'l')">
					<xsl:text>legislation</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'m')">
					<xsl:text>theses</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'n')">
					<xsl:text>survey of literature</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'o')">
					<xsl:text>review</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'p')">
					<xsl:text>programmed text</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'q')">
					<xsl:text>filmography</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'r')">
					<xsl:text>directory</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'s')">
					<xsl:text>statistics</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'t')">
					<xsl:text>technical report</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'v')">
					<xsl:text>legal case and case notes</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'w')">
					<xsl:text>law report or digest</xsl:text>
				</xsl:when>
				<xsl:when test="contains($controlField008-24,'z')">
					<xsl:text>treaty</xsl:text>
				</xsl:when>
			</xsl:choose>
			<xsl:variable name="controlField008-29" select="substring($controlField008,30,1)"/>
			<xsl:choose>
				<xsl:when test="$controlField008-29='1'">
					<xsl:text>conference publication</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="$typeOf008='CF'">
			<xsl:variable name="controlField008-26" select="substring($controlField008,27,1)"/>
			<xsl:choose>
				<xsl:when test="$controlField008-26='a'">
					<xsl:text>numeric data</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-26='e'">
					<xsl:text>database</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-26='f'">
					<xsl:text>font</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-26='g'">
					<xsl:text>game</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="$typeOf008='BK'">
			<xsl:if test="substring($controlField008,25,1)='j'">
				<xsl:text>patent</xsl:text>
			</xsl:if>
			<xsl:if test="substring($controlField008,25,1)='2'">
				<xsl:text>offprint</xsl:text>
			</xsl:if>
			<xsl:if test="substring($controlField008,31,1)='1'">
				<xsl:text>festschrift</xsl:text>
			</xsl:if>
			<xsl:variable name="controlField008-34" select="substring($controlField008,35,1)"/>
			<xsl:if
				test="$controlField008-34='a' or $controlField008-34='b' or $controlField008-34='c' or $controlField008-34='d'">
				<xsl:text>biography</xsl:text>
			</xsl:if>
			<xsl:variable name="controlField008-33" select="substring($controlField008,34,1)"/>
			<xsl:choose>
				<xsl:when test="$controlField008-33='e'">
					<xsl:text>essay</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='d'">
					<xsl:text>drama</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='c'">
					<xsl:text>comic strip</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='l'">
					<xsl:text>fiction</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='h'">
					<xsl:text>humor, satire</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='i'">
					<xsl:text>letter</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='f'">
					<xsl:text>novel</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='j'">
					<xsl:text>short story</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='s'">
					<xsl:text>speech</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="$typeOf008='MU'">
			<xsl:variable name="controlField008-30-31" select="substring($controlField008,31,2)"/>
			<xsl:if test="contains($controlField008-30-31,'b')">
				<xsl:text>biography</xsl:text>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'c')">
				<xsl:text>conference publication</xsl:text>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'d')">
				<xsl:text>drama</xsl:text>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'e')">
				<xsl:text>essay</xsl:text>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'f')">
				<xsl:text>fiction</xsl:text>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'o')">
				<xsl:text>folktale</xsl:text>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'h')">
				<xsl:text>history</xsl:text>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'k')">
				<xsl:text>humor, satire</xsl:text>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'m')">
				<xsl:text>memoir</xsl:text>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'p')">
				<xsl:text>poetry</xsl:text>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'r')">
				<xsl:text>rehearsal</xsl:text>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'g')">
				<xsl:text>reporting</xsl:text>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'s')">
				<xsl:text>sound</xsl:text>
			</xsl:if>
			<xsl:if test="contains($controlField008-30-31,'l')">
				<xsl:text>speech</xsl:text>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$typeOf008='VM'">
			<xsl:variable name="controlField008-33" select="substring($controlField008,34,1)"/>
			<xsl:choose>
				<xsl:when test="$controlField008-33='a'">
					<xsl:text>art original</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='b'">
					<xsl:text>kit</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='c'">
					<xsl:text>art reproduction</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='d'">
					<xsl:text>diorama</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='f'">
					<xsl:text>filmstrip</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='g'">
					<xsl:text>legal article</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='i'">
					<xsl:text>picture</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='k'">
					<xsl:text>graphic</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='l'">
					<xsl:text>technical drawing</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='m'">
					<xsl:text>motion picture</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='n'">
					<xsl:text>chart</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='o'">
					<xsl:text>flash card</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='p'">
					<xsl:text>microscope slide</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='q' or marc:controlfield[@tag=007][substring(text(),1,1)='a'][substring(text(),2,1)='q']">
					<xsl:text>model</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='r'">
					<xsl:text>realia</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='s'">
					<xsl:text>slide</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='t'">
					<xsl:text>transparency</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='v'">
					<xsl:text>videorecording</xsl:text>
				</xsl:when>
				<xsl:when test="$controlField008-33='w'">
					<xsl:text>toy</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
        <xsl:text>"&#09;</xsl:text>
        
        <!-- [7] Publisher; [8] Place; [9] Date; [10] Edition -->
        <xsl:call-template name="originInfo"/>
        
        <xsl:text>""&#09;</xsl:text> <!-- [11] Series -->
        
        <!-- [12] Language -->
        
        <xsl:text>"</xsl:text>
        <xsl:variable name="controlField008-35-37" select="normalize-space(translate(substring($controlField008,36,3),'|#',''))"/>
        <xsl:if test="$controlField008-35-37">
            <xsl:value-of select="substring($controlField008,36,3)"/>
        </xsl:if>
        <xsl:text>"&#09;</xsl:text>
        
        <!-- [13] Form and [14] File Format -->
        <xsl:text>"electronic"&#09;""&#09;</xsl:text>
        
        <!-- [15] Extent -->
        
        <xsl:text>"</xsl:text>
        <xsl:if test="marc:datafield[@tag='300']">
            <xsl:for-each select="marc:datafield[@tag='300']">
                <xsl:for-each select="marc:subfield">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:for-each>
                <xsl:if test="position() != last()">
                    <xsl:text> ; </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:text>"&#09;""&#09;</xsl:text> <!-- [16] Digital Origin -->
        
        <!-- [17] Description -->
        
        <xsl:text>"</xsl:text>
        <xsl:if test="marc:datafield[@tag='520']">
            <xsl:value-of select="marc:datafield[@tag='520']/marc:subfield[@code='a']"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="marc:datafield[@tag='520']/marc:subfield[@code='b']"/>
        </xsl:if>
        <xsl:text>"&#09;</xsl:text>
        
        <!-- [18] Notes -->
        
        <xsl:text>"</xsl:text>
        <xsl:for-each select="marc:datafield[@tag='245']/marc:subfield[@code='c']">
            <xsl:text>Statement of responsibility: </xsl:text>
            <xsl:value-of select="."/>
            <xsl:text> </xsl:text>
        </xsl:for-each>
        
        <xsl:for-each select="marc:datafield[@tag='500']">
            <xsl:variable name="note">
                <xsl:analyze-string select="marc:subfield[@code='a']"
                    regex="^&quot;\d+.*&quot;.*$">
                    <xsl:matching-substring>
                        <xsl:text></xsl:text>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:variable>
            <xsl:if test="$note != ''">
                <xsl:if test="position() != 1">
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="$note"/>
            </xsl:if>
        </xsl:for-each>
        
        <xsl:for-each select="marc:datafield[@tag='510']">
            <xsl:text>Citation: </xsl:text>
            <xsl:variable name="str">
                <xsl:for-each select="marc:subfield[@code!='6' or @code!='8']">
                    <xsl:value-of select="."/>
                    <xsl:text> </xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str,1,string-length($str)-1)"/>
            <xsl:text> </xsl:text>
        </xsl:for-each>
        
        <xsl:for-each select="marc:datafield[@tag='530']">
            <xsl:text>Add'l physical form: </xsl:text>
            <xsl:variable name="str">
                <xsl:for-each select="marc:subfield[@code!='6' or @code!='8']">
                    <xsl:value-of select="."/>
                    <xsl:text> </xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str,1,string-length($str)-1)"/>
            <xsl:text> </xsl:text>
        </xsl:for-each>
        
        <xsl:for-each select="marc:datafield[@tag='533']">
            <xsl:text>Reproduction: </xsl:text>
            <xsl:variable name="str">
                <xsl:for-each select="marc:subfield[@code!='6' or @code!='8']">
                    <xsl:value-of select="."/>
                    <xsl:text> </xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str,1,string-length($str)-1)"/>
            <xsl:text> </xsl:text>
        </xsl:for-each>
        
        <xsl:for-each select="marc:datafield[@tag='534']">
            <xsl:text>Original version: </xsl:text>
            <xsl:variable name="str">
                <xsl:for-each select="marc:subfield[@code!='6' or @code!='8']">
                    <xsl:value-of select="."/>
                    <xsl:text> </xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str,1,string-length($str)-1)"/>
            <xsl:text> </xsl:text>
        </xsl:for-each>
        
        <xsl:for-each select="marc:datafield[@tag='538']">
            <xsl:text>System details: </xsl:text>
            <xsl:variable name="str">
                <xsl:for-each select="marc:subfield[@code!='6' or @code!='8']">
                    <xsl:value-of select="."/>
                    <xsl:text> </xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str,1,string-length($str)-1)"/>
            <xsl:text> </xsl:text>
        </xsl:for-each>
        
        <xsl:for-each select="marc:datafield[@tag='501' or @tag='502' or @tag='504' or @tag='507' or @tag='508' or  @tag='513' or @tag='514' or @tag='515' or @tag='516' or @tag='522' or @tag='524' or @tag='525' or @tag='526' or @tag='535' or @tag='536' or @tag='540' or @tag='541' or @tag='544' or @tag='545' or @tag='546' or @tag='547' or @tag='550' or @tag='552' or @tag='555' or @tag='556' or @tag='561' or @tag='562' or @tag='565' or @tag='567' or @tag='580' or @tag='581' or @tag='584' or @tag='585' or @tag='586']">
            <xsl:variable name="str">
                <xsl:for-each select="marc:subfield[@code!='6' or @code!='8']">
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </xsl:variable>
            <!--<xsl:value-of select="substring($str,1,string-length($str)-1)"/>-->
            <xsl:value-of select="$str"/>
            <xsl:if test="position() != last()">
                <xsl:text> </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>"&#09;</xsl:text>
        
        <!-- [19] Audience -->
        
        <xsl:text>"</xsl:text>
        <xsl:if test="marc:datafield[@tag='521']">
            <xsl:value-of select="marc:datafield[@tag='521']/marc:subfield[@code='a']"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="marc:datafield[@tag='521']/marc:subfield[@code='b']"/>
        </xsl:if>
        <xsl:text>"&#09;</xsl:text>
        
        <!-- [20] Subject -->
        
        <xsl:text>"</xsl:text>
        <xsl:for-each select="marc:datafield[@tag='600' or @tag='650' or @tag='651' or @tag='655']">
            <xsl:if test="@tag='600'">
                <xsl:for-each select="marc:subfield">
                    <xsl:if test="@code='v' or @code='x' or @code='y' or @code='z'">
                        <xsl:text>--</xsl:text>
                    </xsl:if>
                    <xsl:if test="@code='t'">
                        <xsl:text> ; </xsl:text>
                    </xsl:if>
                    <xsl:if test="@code='c' or @code='d'">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="@tag='650' or @tag='651'">
                <xsl:for-each select="marc:subfield">
                    <xsl:variable name="topic">
                        <xsl:analyze-string select="."
                            regex="(.+)\.$">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)"/>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:value-of select="."/>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:variable>
                    <xsl:value-of select="$topic"/>
                    <xsl:if test="position() != last()">
                        <xsl:text>--</xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="@tag='655'">
                <xsl:for-each select="marc:subfield">
                    <xsl:if test="@code!='2'">
                        <xsl:if test="position() != 1">
                            <xsl:text>--</xsl:text>
                        </xsl:if>
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="position() != last()">
                <xsl:text> ; </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>"&#09;</xsl:text>
        
        <!-- [21] Location and [22] Date Coverage -->
        
        <xsl:text>""&#09;""&#09;</xsl:text>
        
        <!-- [23-25] Identifiers -->
        
        <xsl:text>""&#09;""&#09;""&#09;</xsl:text>
        
        <!-- Table of Contents -->
        <xsl:text>"</xsl:text>
        <xsl:if test="marc:datafield[@tag='505']">
            <xsl:for-each select="marc:datafield[@tag='505']">
                <xsl:if test="marc:subfield[@code='a']">
                    <xsl:value-of select="marc:subfield[@code='a']"/>
                </xsl:if>
                <xsl:if test="position() != last()">
                    <xsl:text>. </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:text>"&#09;</xsl:text>
        
        <xsl:text>"Pennsylvania State University Libraries"&#09;</xsl:text> <!-- [26] Repository -->
        
        <xsl:text>""&#09;""&#09;""&#09;""&#09;""&#09;""&#09;""&#09;""&#09;</xsl:text>
        <xsl:text>"Reformatted from the original MARC record."&#09;"full text"&#09;"thumbnail"&#09;""&#09;</xsl:text>
        
        <!-- OCLC Number -->
        
        <xsl:text>"</xsl:text>
        <xsl:value-of select="$oclc_number"/>
        <xsl:text>"&#10;</xsl:text>
        
    </xsl:template>
    
    <xsl:template name="titles">
        <xsl:text>"</xsl:text>
        <xsl:for-each select="marc:datafield[@tag='245']"> <!-- Title -->
            <xsl:call-template name="writeTitles"/>
        </xsl:for-each>
        <xsl:text>"&#09;"</xsl:text>
        <xsl:for-each select="marc:datafield[@tag='210']"> <!-- various alternative titles -->
            <xsl:call-template name="writeTitles">
                <xsl:with-param name="type" select="'abbreviated'"/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="marc:datafield[@tag='242']">
            <xsl:call-template name="writeTitles">
                <xsl:with-param name="type" select="'translated'"/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="marc:datafield[@tag='246']">
            <xsl:call-template name="writeTitles">
                <xsl:with-param name="type" select="'alternative'"/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:text>"&#09;</xsl:text>
    </xsl:template>
    
    <xsl:template name="writeTitles">
        <xsl:param name="type"/>
        <xsl:variable name="title">
            <xsl:analyze-string select="marc:subfield[@code='a']"
                regex="(.+)\s:|\s/$">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:value-of select="$title"/>
        <xsl:if test="marc:subfield[@code='b']">
            <xsl:text> : </xsl:text>
            <xsl:analyze-string select="marc:subfield[@code='b']"
                regex="(.+)\s/$">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:if>
        <xsl:if test="marc:subfield[@code='f']">
            <xsl:text> </xsl:text>
            <xsl:value-of select="marc:subfield[@code='f']"/>
        </xsl:if>
        <xsl:if test="$type">
            <xsl:text> [</xsl:text>
            <xsl:value-of select="$type"/>
            <xsl:text>]</xsl:text>
        </xsl:if>
        <xsl:if test="position() != last()">
            <xsl:text> ; </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="names">
        <xsl:text>"</xsl:text>
        <xsl:call-template name="writeNames"> <!-- Creator -->
            <xsl:with-param name="pers" select="'100'"/>
            <xsl:with-param name="corp" select="'110'"/>
            <xsl:with-param name="conf" select="'111'"/>
        </xsl:call-template>
        <xsl:text>"&#09;"</xsl:text>
        <xsl:call-template name="writeNames"> <!-- Contributors -->
            <xsl:with-param name="pers" select="'700'"/>
            <xsl:with-param name="corp" select="'710'"/>
            <xsl:with-param name="conf" select="'711'"/>
        </xsl:call-template>
        <xsl:text>"&#09;</xsl:text>
    </xsl:template>
    
    <xsl:template name="writeNames">
        <xsl:param name="pers"/>
        <xsl:param name="corp"/>
        <xsl:param name="conf"/>
        <xsl:variable name="personal">
            <xsl:for-each select="marc:datafield[@tag=$pers]">
                <xsl:for-each select="marc:subfield">
                    <xsl:if test="position() != 1">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="."/>
                </xsl:for-each>
                <xsl:if test="position() != last()">
                    <xsl:text> ; </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="corporate">
            <xsl:for-each select="marc:datafield[@tag=$corp]">
                <xsl:for-each select="marc:subfield">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="conference">
            <xsl:for-each select="marc:datafield[@tag=$conf]">
                <xsl:for-each select="marc:datafield[@tag=$corp]">
                    <xsl:for-each select="marc:subfield">
                        <xsl:value-of select="."/>
                        <xsl:if test="position() != last()">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="$personal">
            <xsl:value-of select="$personal"/>
        </xsl:if>
        <xsl:if test="$corporate">
            <xsl:value-of select="$corporate"/>
        </xsl:if>
        <xsl:if test="$conference">
            <xsl:value-of select="$conference"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="originInfo">
        <xsl:variable name="place">
            <xsl:if test="marc:datafield[@tag='260']/marc:subfield[@code='a']">
                <xsl:for-each select="marc:datafield[@tag='260']/marc:subfield[@code='a']">
                    <xsl:analyze-string select="."
                        regex="^(.+)(\s[:;]|,)$">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                    <xsl:if test="position() != last()">
                        <xsl:text> ; </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="publisher">
            <xsl:if test="marc:datafield[@tag='260']/marc:subfield[@code='b']">
                <xsl:for-each select="marc:datafield[@tag='260']/marc:subfield[@code='b']">
                    <xsl:analyze-string select="."
                        regex="^(.+),$">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                    <xsl:if test="position() != last()">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="date">
            <xsl:if test="marc:datafield[@tag='260']/marc:subfield[@code='c']">
                <xsl:analyze-string select="marc:datafield[@tag='260']/marc:subfield[@code='c']"
                    regex="^(.+)\.$">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:if>
        </xsl:variable>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="$publisher"/>
        <xsl:text>"&#09;"</xsl:text>
        <xsl:value-of select="$place"/>
        <xsl:text>"&#09;"</xsl:text>
        <xsl:value-of select="$date"/>
        <xsl:text>"&#09;"</xsl:text>
        <xsl:if test="marc:datafield[@tag='250']">
            <xsl:value-of select="marc:datafield[@tag='250']/marc:subfield[@code='a']"/>
        </xsl:if>
        <xsl:text>"&#09;</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>