public with sharing class CaseFieldsUpdation {

    public static void updateTheCaseFileds(List<Case> newCases) {

        List<Id> taskAssignmentIds = new List<Id>();
        for(Case newCase : newCases) {
            taskAssignmentIds.add(newCase.Task_Assignment__c);
        }
        
        Map<Id,Task_Assignment__c> taskMap = new Map<Id,Task_Assignment__c>
                                            ([ SELECT Employee__c,Task_Name__c
                                                FROM Task_Assignment__c 
                                                WHERE Id IN :taskAssignmentIds]);
        if(taskMap.size() > 0){
            for(Case newCase : newCases){
                if(taskMap.containsKey(newCase.Task_Assignment__c)) {
                    newCase.ContactId = taskMap.get(newCase.Task_Assignment__c).Employee__c;
                    newCase.Training_Task__c = taskMap.get(newCase.Task_Assignment__c).Task_Name__c;
                }
            } 
        }                                        

                                                    
    }
}
