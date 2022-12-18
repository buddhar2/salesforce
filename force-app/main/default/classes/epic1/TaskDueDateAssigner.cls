public with sharing class TaskDueDateAssigner {
    public TaskDueDateAssigner() {

    }

    public static void dueDateAssignment(List<Task_Assignment__c> newTaskAssignments) { 

        Set<Id> taskIds = new Set<Id>();
        for(Task_Assignment__c newTaskAssignment : newTaskAssignments) {
            if(newTaskAssignment.Program_Name__c == null){
                taskIds.add(newTaskAssignment.Task_Name__c);
            }
        }
        
        try{
            if(taskIds.size() > 0) {
                Map<Id,Training_Task__c> durationMap = new Map<Id,Training_Task__c> ([ SELECT Effort_In_Days__c
                                                    FROM Training_Task__c
                                                    WHERE Id IN :taskIds]);
                                                    
                for(Task_Assignment__c newTaskAssignment : newTaskAssignments) {
                    Decimal days = durationMap.get(newTaskAssignment.Task_Name__c).Effort_In_Days__c;
                    newTaskAssignment.Due_Date__c = newTaskAssignment.Start_Date__c.addDays(days.intValue());
                }
            } 
        }catch(DmlException e){
            throw new DmlException(e.getMessage());
        } 
    }

    public static void updateCompletedOnCompletion(List<Task_Assignment__c> updatedTaskAssignments,
                                                    Map<Id, Task_Assignment__c> oldTaskAssignments) {
        for(Task_Assignment__c updatedTaskAssignment : updatedTaskAssignments) {
            if(updatedTaskAssignment.Status__c == 'Completed'
                    && oldTaskAssignments.get(updatedTaskAssignment.Id).Status__c != 'Completed'){
                        updatedTaskAssignment.Completed_Date__c = Date.today();
            }else {
                updatedTaskAssignment.Completed_Date__c = null;
            }
        }  
    }
}