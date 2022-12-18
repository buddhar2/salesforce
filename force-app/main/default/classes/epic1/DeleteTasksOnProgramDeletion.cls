public with sharing class DeleteTasksOnProgramDeletion {
    public static void deleteTaskFromEmployees(Map<Id,Program_Assignment__c> programAssignments) {
        List<Task_Assignment__c> queriedTaskAssignments = [SELECT Id 
                                                            FROM Task_Assignment__c
                                                            WHERE Program_Assignment__c 
                                                            IN : programAssignments.keySet()];
        try{
            if(queriedTaskAssignments.size() > 0){
                delete queriedTaskAssignments;
            } 
        }catch(DmlException e){
            throw new DmlException(e.getMessage());
        }                                                                                                      
        
    }
}
