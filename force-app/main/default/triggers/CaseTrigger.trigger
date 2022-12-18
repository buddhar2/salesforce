trigger CaseTrigger on Case (before insert, after insert, after update) {
    if(Trigger.isBefore && Trigger.isInsert) {
        CaseFieldsUpdation.updateTheCaseFileds(Trigger.new);
    }else if(Trigger.isAfter && Trigger.isInsert) {
        TaskStatusUpdation.updateTaskStatusOnCaseCreation(Trigger.new);
    }else if(Trigger.isAfter && Trigger.isUpdate) {
        TaskStatusUpdation.updateTaskStatusOnCaseStatusUpdate(Trigger.new, Trigger.oldMap);
    }
}