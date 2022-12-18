trigger TaskAssignment on Task_Assignment__c (before insert,before update) {
    if(Trigger.isBefore && Trigger.isInsert) {
        TaskDueDateAssigner.dueDateAssignment(Trigger.new);
    }else if (Trigger.isBefore && Trigger.isUpdate) {
        TaskAssignmentDuplicateChecker.updateForDuplicateTaskAssignment(Trigger.new);
        TaskDueDateAssigner.updateCompletedOnCompletion(Trigger.new, Trigger.oldMap);
    }
}