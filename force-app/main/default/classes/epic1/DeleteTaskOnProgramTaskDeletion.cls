public with sharing class DeleteTaskOnProgramTaskDeletion {

    public static void deleteTaskFromEmployees(List<Program_Task__c> programTasks) {

        List<Id> programIds = new List<Id>();
        for(Program_Task__c programTask : programTasks) {
            programIds.add(programTask.Program_Name__c);
        }
            List<Task_Assignment__c> queriedTaskAssignments = [SELECT Program_Name__c,Task_Name__c
                                                                FROM Task_Assignment__c
                                                                WHERE Program_Name__c IN :programIds];
                                                                                                                     
        List<Task_Assignment__c> deleteTaskList = new List<Task_Assignment__c>();
        if(queriedTaskAssignments.size() > 0){
            for(Program_Task__c programTask : programTasks){          
                for(Task_Assignment__c queriedTaskAssignment : queriedTaskAssignments) {
                    if(queriedTaskAssignment.Task_Name__c == programTask.Training_Task__c){
                        deleteTaskList.add(queriedTaskAssignment);
                    }
                }
            } 
            try{
                delete deleteTaskList;
            }catch(DmlException e){
                throw new DmlException(e.getMessage());
            }
        }   
    }
}
