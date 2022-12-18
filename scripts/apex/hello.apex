// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

List<Program_Assignment__c> completed = [SELECT Id
                                            FROM Program_Assignment__c 
                                            WHERE Id = 'a057c000003dPKyAAM'];

// SendSurveyInvitation.createSurveyInv(completed);
DeleteTasksOnProgramDeletion.deleteTaskFromEmployees(completed);

List<Task_Assignment__c> completed = [SELECT Id, Name, Program_Name__c, Employee__c,Task_Name__c,Due_Date__c
                                                       FROM Task_Assignment__c WHERE Id IN ('a067c000009XQUZAA4','a067c000009XQUaAAO','a067c000009XQUfAAO','a037c00000DPyVqAAL')] ;

System.debug(completed);

UpdateTaskCompletionCount.updateCompletionCount(completed);

List<Contact> project = [SELECT Name,Title,Account.Name FROM Contact];
System.debug(project);

List<Training_Task__c> tasks = [SELECT Id,Name
                FROM Training_Task__c
                WHERE Category__c includes(:project.Category__c)];
System.debug(tasks.size());

String recordId = '0037c000015eFmHAAU';  
String objectName = 'Task_Assignment__c';  
String parentFieldAPIName = 'Employee__c';  
String fieldName = 'Status__c';  
String fieldValue = '\'Overdue\', \'Completed\'';  
String filterType = 'Multiple';  
String operator = 'NOT IN';
String strSOQL = 'SELECT Id FROM ' + objectName + ' WHERE ' + parentFieldAPIName + ' = \'' +  recordId + '\' AND ';
                if ( filterType == 'String'){
                    strSOQL += fieldName + ' = \'' + fieldValue + '\'' ;
                } else if ( filterType == 'Boolean' ){
                    strSOQL += fieldName + ' = ' + fieldValue;  
                } else if(filterType == 'Multiple') {
                    strSOQL += fieldName + ' ' + operator + ' ' + '(' + fieldValue + ')'; 
                }else {
                    strSOQL += fieldName + '' + operator + '' + fieldValue; 
                } 
                strSOQL += ' LIMIT 10';

System.debug(strSOQL);

List<Task_Assignment__c> pt = Database.query( strSOQL );
System.debug(pt);

