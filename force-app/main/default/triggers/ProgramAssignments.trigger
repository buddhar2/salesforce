trigger ProgramAssignments on Program_Assignment__c (before insert,after insert, before delete, before update) {

    if (Trigger.isBefore && Trigger.isInsert){
        if(ProgramAssignmentDuplicateChecker.checkForDuplicateProgramAssignment(Trigger.new)) {
            ProgramDueDateAssigner.updateDueDateOnCreation(Trigger.new);
        }
    }else if(Trigger.isAfter && Trigger.isInsert){
        AssignTasksOnProgramAssignment.assignTaskToEmployees(Trigger.new);
    }else if(Trigger.isBefore && Trigger.isDelete){
        DeleteTasksOnProgramDeletion.deleteTaskFromEmployees(Trigger.oldMap);
    }else if(Trigger.isBefore && Trigger.isUpdate){
        ProgramDueDateAssigner.updateCompletedOnCompletion(Trigger.new,Trigger.oldMap);
    }
}