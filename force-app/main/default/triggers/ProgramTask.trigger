trigger ProgramTask on Program_Task__c (after insert, after delete) {
    if (Trigger.isAfter && Trigger.isInsert) {
        AssignTasksOnProgramTaskCreation.assignTaskToEmployees(Trigger.new);
    }else if(Trigger.isAfter && Trigger.isDelete) {
        DeleteTaskOnProgramTaskDeletion.deleteTaskFromEmployees(Trigger.old);
    }
}