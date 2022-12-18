public with sharing class AssignTasksOnProgramAssignment {

    public static void assignTaskToEmployees(List<Program_Assignment__c> newProgramAssignment) {
        List<Id> programs = new List<Id>();
        for(Program_Assignment__c pa : newProgramAssignment) {
            programs.add(pa.Program_Name__c);
        }

            List<Program_Task__c> programTasks = [ SELECT Program_Name__c, Training_Task__c, Week_Due__c
                                                    FROM Program_Task__c
                                                    WHERE Program_Name__c IN :programs];

        List<Task_Assignment__c> taskAssignments = new List<Task_Assignment__c>();
        if(programTasks.size() > 0){
            for(Program_Assignment__c pa : newProgramAssignment) {                     
                for(Program_Task__c tt : programTasks) {
                    if(pa.Program_Name__c == tt.Program_Name__c){
                        Task_Assignment__c tasks = new Task_Assignment__c();
                        tasks.Program_Assignment__c = pa.Id;
                        tasks.Employee__c = pa.Employee__c;
                        tasks.Task_Name__c = tt.Training_Task__c;
                        tasks.Start_Date__c = pa.Start_Date__c;
                        Decimal week = tt.Week_Due__c;
                        tasks.Due_Date__c = pa.Start_Date__c.addDays(week.intValue() * 7);
                        tasks.Program_Name__c = pa.Program_Name__c;
                        taskAssignments.add(tasks);
                    }                   
                }
            }  
            taskAssignments = TaskAssignmentDuplicateChecker.checkForDuplicateTaskAssignment(taskAssignments);
            try{
                insert taskAssignments; 
            }catch(DmlException e) {
                throw new DmlException(e.getMessage());
            }
            
        }                                  
    }
}

