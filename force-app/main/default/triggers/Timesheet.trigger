trigger Timesheet on Timesheet__c (before update, before insert, after update, after insert) {
    if(Trigger.isBefore && Trigger.isUpdate) {
        TimesheetUpdateFields.updateRejectionCount(Trigger.new, Trigger.oldMap);
    }else if (Trigger.isBefore && Trigger.isInsert){
        TimesheetUpdateFields.updateProgramManager(Trigger.new);
    }else if(Trigger.isAfter && Trigger.isUpdate) {
        TimesheetUpdateFields.closeRelatedTasks(Trigger.new);
    }else if(Trigger.isAfter && Trigger.isInsert) {
        TaskGenerator.handleTimesheetReminders(Trigger.new);
    }
}