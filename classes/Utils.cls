public class Utils {


   /**
   * Returns a boolean depending if the Organization is an Sandbox
   */
    public static Boolean IsProductionOrg() {
        Organization org = [select IsSandbox from Organization where Id =:UserInfo.getOrganizationId()];
        return (org.IsSandbox == true) ? false : true;
    }


    /**
    * Returns a valid XML Document when contains an CDATA Structure inside of the XML Structure
    * @String xml Is the XML structure formed with the CDATA included
    */
    public static DOM.Document generateXMLWithCDATA(String xml) {
        xml = xml.replaceAll( '<!\\[CDATA\\[', 'XML_CDATA_START' ).replaceAll( ']]>', 'XML_CDATA_END' );
        Map<String, String> replacementMap = new Map<String, String>();
        Pattern myPattern = Pattern.compile( '(XML_CDATA_START)(.*?)(XML_CDATA_END)' );
        Matcher myMatcher = myPattern.matcher( xml );

        while ( myMatcher.find() ) {
            replacementMap.put( myMatcher.group(), myMatcher.group(2).escapeXML() );
        }

        for ( String key : replacementMap.keySet() ) {
            xml = xml.replace( key, replacementMap.get( key ) );
        }

        Dom.Document doc = new Dom.Document();
        doc.load( xml );
        return doc;
    }

}