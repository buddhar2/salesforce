public with sharing class TaskGenerator {

    public static void handleTimesheetReminders(List<Timesheet__c> insertedTimesheets) {
        List<Id> timesheetIds = new List<Id>();
        for(Timesheet__c t : insertedTimesheets ) {
            timesheetIds.add(t.Id);
        }
        generateTimesheetReminders(timesheetIds);
        //createFutureTask(timesheetIds);
    }

    @future
    public static void generateTimesheetReminders(List<Id> timesheetIds ) {
        List<Task> timesheetReminders = new List<Task>();
        for(Id i : timesheetIds) {
            Task reminder = new Task();
            reminder.WhatId = i;
            reminder.Subject = 'Submit your timesheet';
            reminder.ActivityDate = Date.today().addDays(7);
            timesheetReminders.add(reminder);
        }

        insert timesheetReminders;
    }
}
