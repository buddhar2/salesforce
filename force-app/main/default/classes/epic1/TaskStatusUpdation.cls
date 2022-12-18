public with sharing class TaskStatusUpdation {

    public static void updateTaskStatusOnCaseCreation(List<Case> newCases) {
        List<Id> taskAssignmentIds = new List<Id>();
        for(Case newCase : newCases) {
            taskAssignmentIds.add(newCase.Task_Assignment__c);
        }
        List<Task_Assignment__c> queriedTaskAssignments = [ SELECT Id, Status__c
                                                FROM Task_Assignment__c 
                                                WHERE Id IN :taskAssignmentIds];
        for(Task_Assignment__c queriedTaskAssignment : queriedTaskAssignments) {
            queriedTaskAssignment.Status__c = 'Blocked';
        }
        try{
            update queriedTaskAssignments;
        }catch(DmlException e){
            throw new DmlException(e.getMessage());
        }                                         
    }

    public static void updateTaskStatusOnCaseStatusUpdate(List<Case> updatedCases,Map<Id,Case> oldCaseValues) {
        List<Id> taskAssignmentIds = new List<Id>();
        for(Case updatedCase : updatedCases) {
            if(updatedCase.Status == 'Closed' && 
                    oldCaseValues.get(updatedCase.Id).Status != 'Closed'){
                taskAssignmentIds.add(updatedCase.Task_Assignment__c);
            }   
        }   

        if(!taskAssignmentIds.isEmpty()){
            List<Task_Assignment__c> queriedTaskAssignments = [ SELECT Id, Status__c
                                                    FROM Task_Assignment__c 
                                                    WHERE Id IN :taskAssignmentIds];

            for(Task_Assignment__c queriedTaskAssignment : queriedTaskAssignments) {
                queriedTaskAssignment.Status__c = 'In Progress';
            }
            try{
                update queriedTaskAssignments;
            }catch(DmlException e){
                throw new DmlException(e.getMessage());
            }                                                 
        }
    }
}
