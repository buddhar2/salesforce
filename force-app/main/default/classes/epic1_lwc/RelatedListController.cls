public with sharing class RelatedListController {
  
        @AuraEnabled(cacheable=true)  
        public static List<sObject> fetchRecords( String listValues )  {  
           
            List<String> strList = listValues.split( '@' );    

            for(String str : strList){
                System.debug(str);
            }
              
            if ( strList.size() == 7 ) {  
              
                String recordId = strList.get( 0 );  
                String objectName = strList.get( 1 );  
                String parentFieldAPIName = strList.get( 2 );  
                String fieldName = strList.get( 3 );  
                String fieldValue = strList.get( 4 );  
                String filterType = strList.get( 5 );  
                String operator = strList.get( 6 );                
                String strSOQL = 'SELECT Id FROM ' + objectName + ' WHERE ' + parentFieldAPIName + ' = \'' +  recordId + '\' AND ';
                if ( filterType == 'String'){
                    strSOQL += fieldName + ' = \'' + fieldValue + '\'' ;
                } else if ( filterType == 'Boolean' ){
                    strSOQL += fieldName + ' = ' + fieldValue;  
                } else if(filterType == 'Multiple') {
                    strSOQL += fieldName + ' ' + operator + ' ' + '(' + fieldValue + ')'; 
                } else {
                    strSOQL += fieldName + '' + operator + '' + fieldValue; 
                } 
                strSOQL += ' LIMIT 10'; 
                System.debug('strSOQL :' + strSOQL);     
                return Database.query( strSOQL );  
            }else {
                return null;
            }
        }
}
