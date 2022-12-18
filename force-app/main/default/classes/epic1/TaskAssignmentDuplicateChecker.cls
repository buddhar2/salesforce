public with sharing class TaskAssignmentDuplicateChecker {

    static Boolean isRecursive = false;

    public static List<Task_Assignment__c> checkForDuplicateTaskAssignment(List<Task_Assignment__c> newTaskAssignments) {
        Set<Id> newTaskSet = new Set<Id>();
        Set<Id> newEmployeeSet = new Set<Id>();
        Set<TaskWrapperClass> queriedWrapperSet = new Set<TaskWrapperClass>();
        Set<TaskWrapperClass> newWrapperSet = new Set<TaskWrapperClass>();

        for(Task_Assignment__c newTaskAssignment : newTaskAssignments) {
            TaskWrapperClass iKey = new TaskWrapperClass(newTaskAssignment.Task_Name__c,
                                                        newTaskAssignment.Employee__c);
            if(newWrapperSet.contains(iKey)) {
                newTaskAssignment.addError('Duplicate in Task Assignments');
            }else {
                newTaskSet.add(newTaskAssignment.Task_Name__c);
                newEmployeeSet.add(newTaskAssignment.Employee__c);
                newWrapperSet.add(iKey);
            }
        }
        List<Task_Assignment__c> queriedTaskAssignments = [SELECT Id,Task_Name__c,Employee__c,Status__c,Submission_URL__c
                                                                FROM Task_Assignment__c 
                                                                WHERE Task_Name__c IN :newTaskSet 
                                                                OR Employee__c IN :newEmployeeSet];
        Map<TaskWrapperClass,Task_Assignment__c> taskMap = new Map<TaskWrapperClass,Task_Assignment__c>(); 
        
        for(Task_Assignment__c queriedTaskAssignment : queriedTaskAssignments) {
            queriedWrapperSet.add(new TaskWrapperClass(queriedTaskAssignment.Task_Name__c,
                                                    queriedTaskAssignment.Employee__c)); 
            taskMap.put(new TaskWrapperClass(queriedTaskAssignment.Task_Name__c,
            queriedTaskAssignment.Employee__c),queriedTaskAssignment);                                         
        }
        List<Task_Assignment__c> updatedTasks = new List<Task_Assignment__c>();
        for(Task_Assignment__c newTaskAssignment : newTaskAssignments) {
            TaskWrapperClass iKey = new TaskWrapperClass(newTaskAssignment.Task_Name__c,
                                                            newTaskAssignment.Employee__c);
            if(queriedWrapperSet.contains(iKey)) {
                newTaskAssignment.Status__c = taskMap.get(iKey).Status__c;
                newTaskAssignment.Submission_URL__c	 = taskMap.get(iKey).Submission_URL__c	;
                updatedTasks.add(newTaskAssignment);
            }else{
                updatedTasks.add(newTaskAssignment);
            }
        }
        return updatedTasks;
    }

    public static void updateForDuplicateTaskAssignment(List<Task_Assignment__c> updatedTaskAssignments) {
        
        if(isRecursive) {
            return;
        }

        Set<Id> newTaskList = new Set<Id>();
        Set<Id> employee = new Set<Id>();
        Map<Id,Task_Assignment__c> assignmentMap= new Map<Id,Task_Assignment__c>();
        Map<Id,Task_Assignment__c> taskMap= new Map<Id,Task_Assignment__c>();

        for(Task_Assignment__c updatedTaskAssignment : updatedTaskAssignments) {
            newTaskList.add(updatedTaskAssignment.Task_Name__c);
            employee.add(updatedTaskAssignment.Employee__c);
            assignmentMap.put(updatedTaskAssignment.Task_Name__c,updatedTaskAssignment);
            taskMap.put(updatedTaskAssignment.Id,updatedTaskAssignment);
        }

        List<Task_Assignment__c> queriedTaskAssignments = [SELECT Id,Task_Name__c,Employee__c,Status__c,Submission_URL__c
                                                                FROM Task_Assignment__c 
                                                                WHERE Task_Name__c IN :newTaskList 
                                                                AND Employee__c IN :employee];
    
        List<Task_Assignment__c> uniqueTaskList = new List<Task_Assignment__c>();
        if(queriedTaskAssignments.size() > 0){
            for(Task_Assignment__c queriedTaskAssignment : queriedTaskAssignments) {
                if(!taskMap.containsKey(queriedTaskAssignment.Id)){
                    uniqueTaskList.add(queriedTaskAssignment);
                }
            }  
        }

        List<Task_Assignment__c> updatedTasks = new List<Task_Assignment__c>();                                                         
        for(Task_Assignment__c uniqueTask : uniqueTaskList){
            if(assignmentMap.containsKey(uniqueTask.Task_Name__c)){
                uniqueTask.Status__c = assignmentMap.get(uniqueTask.Task_Name__c).Status__c;
                uniqueTask.Submission_URL__c = assignmentMap.get(uniqueTask.Task_Name__c).Submission_URL__c;
                updatedTasks.add(uniqueTask);
            }
        }

        isRecursive = true;
        try{
            update updatedTasks;
        }catch(DmlException e){
            throw new DmlException(e.getMessage());
        }
        isRecursive = false;
    }
}
