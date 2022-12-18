public with sharing class AssignTasksOnProgramTaskCreation {

    public static void assignTaskToEmployees(List<Program_Task__c> newProgramTasks) {

        List<Id> programIds = new List<Id>();
        for(Program_Task__c newProgramTask : newProgramTasks) {
            programIds.add(newProgramTask.Program_Name__c);
        }

        List<Program_Assignment__c> queriedProgramAssignments = [SELECT Program_Name__c,Employee__c,Start_Date__c
                                                                    FROM Program_Assignment__c
                                                                    WHERE Program_Name__c IN :programIds];
        
        List<Task_Assignment__c> taskAssignments = new List<Task_Assignment__c>();
        if(queriedProgramAssignments.size() > 0) {
            for(Program_Task__c newProgramTask : newProgramTasks) {
                for(Program_Assignment__c queriedProgramAssignment : queriedProgramAssignments) {
                    if(newProgramTask.Program_Name__c == queriedProgramAssignment.Program_Name__c) {
                        Task_Assignment__c tasks = new Task_Assignment__c();
                        tasks.Program_Assignment__c = queriedProgramAssignment.Id; 
                        tasks.Employee__c = queriedProgramAssignment.Employee__c;
                        tasks.Start_Date__c = queriedProgramAssignment.Start_Date__c;
                        Decimal week = newProgramTask.Week_Due__c;
                        tasks.Due_Date__c = queriedProgramAssignment.Start_Date__c.addDays(week.intValue() * 7);
                        tasks.Task_Name__c = newProgramTask.Training_Task__c;
                        tasks.Program_Name__c = queriedProgramAssignment.Program_Name__c;
                        taskAssignments.add(tasks);
                    }
                }
            }
            taskAssignments = TaskAssignmentDuplicateChecker.checkForDuplicateTaskAssignment(taskAssignments); 
            try{
                insert taskAssignments;
            }catch(DmlException e){
                throw new DmlException(e.getMessage());
            }
            
        }                                               
    }
}
