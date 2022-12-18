public with sharing class AssignProgramTasksContainer {
    @AuraEnabled(cacheable=true)
    public static List<Training_Task__c> getSuggestedTasks(Id programId){
        try {
            Program__c program = [SELECT Id,Category__c
                                    FROM Program__c
                                    WHERE Id = :programId];
            
            List<Training_Task__c> taskList = [SELECT Id,Name,Effort_In_Days__c,Task_URL__c,Description__c,Category__c
                                                FROM Training_Task__c
                                                WHERE Category__c includes(:program.Category__c)]; 
            taskList = ProgramTaskDuplicateChecker.checkForDuplicateProgramTask(taskList,programId);                                                           
            return taskList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Training_Task__c> getOtherTasks(Id programId){
        try {
            Program__c program = [SELECT Id,Category__c
                                    FROM Program__c
                                    WHERE Id = :programId];
            
            List<Training_Task__c> taskList = [SELECT Id,Name,Effort_In_Days__c,Task_URL__c,Description__c,Category__c
                                                FROM Training_Task__c
                                                WHERE Category__c excludes(:program.Category__c)]; 
            taskList = ProgramTaskDuplicateChecker.checkForDuplicateProgramTask(taskList,programId);                                                           
            return taskList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void addMultipleProgramTasks(List<Training_Task__c> selectedTaskIds,Id programId){
        try {
            List<Program_Task__c> programTaskList = new List<Program_Task__c>();
            Decimal i=1;
            for(Training_Task__c selectedTaskId : selectedTaskIds) {
                Program_Task__c programTask = new Program_Task__c();
                programTask.Program_Name__c = programId;
                programTask.Training_Task__c = selectedTaskId.Id;
                programTask.Week_Due__c = i;
                programTaskList.add(programTask);
            }
            insert programTaskList;     
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void addProgramTask(Id taskId,Id programId){
        try {
            Decimal i=1;
            Program_Task__c programTask = new Program_Task__c();
            programTask.Program_Name__c = programId;
            programTask.Training_Task__c = taskId;
            programTask.Week_Due__c = i;
            insert programTask;     
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}
 