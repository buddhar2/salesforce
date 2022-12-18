public with sharing class ScheduledTaskGenerator implements Schedulable{

    public void execute(SchedulableContext SC) {
        List<Timesheet__c> timesheetNeedingTasks = new List<Timesheet__c>();
        timesheetNeedingTasks = [SELECT Id
                                    FROM Timesheet__c
                                    WHERE CreatedDate = :Date.today().addDays(-7)];
        
        List<Task> generatedTasks = new List<Task>();
        for(Timesheet__c t : timesheetNeedingTasks) {
            Task reminder = new Task();
            reminder.WhatId = t.Id;
            reminder.Subject = 'Submit your timesheet';
            reminder.ActivityDate = Date.today().addDays(1);
            generatedTasks.add(reminder);
        }                
        insert generatedTasks;                          
    }


}
