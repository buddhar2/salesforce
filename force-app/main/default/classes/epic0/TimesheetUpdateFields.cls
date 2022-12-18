public with sharing class TimesheetUpdateFields {
    public TimesheetUpdateFields() {

    }

    public static void updateRejectionCount(List<Timesheet__c> updatedTimesheets, 
                                            Map<Id, Timesheet__c> oldTimesheetValues) {
        for(Timesheet__c t : updatedTimesheets) {
            if(t.Timesheet_Status__c == 'Rejected'
                 && oldTimesheetValues.get(t.Id).Timesheet_Status__c != 'Rejected') {
                    if(t.Number_of_Times_Rejected__c == null) {
                        t.Number_of_Times_Rejected__c = 0;
                    }
                t.Reject_Count__c = t.Reject_Count__c + 1;
            }
        }
    }

    public static void updateProgramManager(List<Timesheet__c> newTimesheets) {
        List<Id> projectIds = new List<Id>();
        Map<Id,Timesheet__c> timesheetMap = new Map<Id,Timesheet__c>();
        for(Timesheet__c t : newTimesheets) {    
            if(t.Project__c != null) {
                projectIds.add(t.Project__c);
                timesheetMap.put(t.Project__c,t);
            }    
        }

        List<Project__c> queriedProjects = [ SELECT OwnerId 
                                                FROM Project__c
                                                WHERE Id IN :projectIds];

        for(Project__c project : queriedProjects) {
            if(timesheetMap.containsKey(project.Id)) {
                timesheetMap.get(project.Id).Project_Manager__c = project.OwnerId;
            }
        }                                    
    }

    public static void closeRelatedTasks(List<Timesheet__c> updatedTimesheets) {
        List<Id> finalizedTimecardIds = new List<Id>();
        for(Timesheet__c t : updatedTimesheets) {
            if(t.Timesheet_Status__c == 'Submitted'){
                finalizedTimecardIds.add(t.id);
            }
        }

        List<Task> relatedTasks = [ SELECT Status 
                                        FROM Task 
                                        WHERE WhatId IN :finalizedTimecardIds ];

        for(Task t : relatedTasks) {
            t.Status = 'Completed';
        }

        update relatedTasks;
    }
}

