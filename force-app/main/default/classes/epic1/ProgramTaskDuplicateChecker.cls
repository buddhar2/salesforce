public with sharing class ProgramTaskDuplicateChecker {
    public static List<Training_Task__c> checkForDuplicateProgramTask(List<Training_Task__c> taskList, Id programId) {

        try{
            List<Program_Task__c> queriedProgramTasks = [SELECT Id,Training_Task__c
                                                        FROM Program_Task__c 
                                                        WHERE Program_Name__c = :programId ];
            if(queriedProgramTasks.size() > 0) {
                Set<Id> queriedTasks = new Set<Id>();                                                            
                for(Program_Task__c queriedProgramTask : queriedProgramTasks) {
                    queriedTasks.add(queriedProgramTask.Training_Task__c);
                }                                                            

                List<Training_Task__c> uniqueTasks = new List<Training_Task__c>();
                for(Training_Task__c task : taskList) {
                    if(!queriedTasks.contains(task.Id)){
                        uniqueTasks.add(task);
                    }
                }
                return uniqueTasks;
            }   
            return taskList;
        }catch(DmlException e){
            throw new DmlException(e.getMessage());
        }
        
    }
}
