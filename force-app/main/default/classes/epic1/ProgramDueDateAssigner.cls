public with sharing class ProgramDueDateAssigner {

    public static void updateDueDateOnCreation(List<Program_Assignment__c> newProgramAssignments) {

        Set<Id> programIds = new Set<Id>();
        for(Program_Assignment__c newProgramAssignment : newProgramAssignments) {
            programIds.add(newProgramAssignment.Program_Name__c);
        }
        
        Map<Id,Program__c> durationMap = new Map<Id,Program__c> ([ SELECT Program_Duration_In_Days__c
                                            FROM Program__c
                                            WHERE Id IN :programIds]);
        if(durationMap.size() > 0){
            for(Program_Assignment__c newProgramAssignment : newProgramAssignments) {
                Decimal days = durationMap.get(newProgramAssignment.Program_Name__c).Program_Duration_In_Days__c;
                newProgramAssignment.Due_Date__c = newProgramAssignment.Start_Date__c.addDays(days.intValue());
            }
        }                                    
        
    }

    public static void updateCompletedOnCompletion(List<Program_Assignment__c> updatedProgramAssignments,
                                                    Map<Id, Program_Assignment__c> oldProgramAssignments) {
        for(Program_Assignment__c updatedProgramAssignment : updatedProgramAssignments) {
            if(updatedProgramAssignment.Status__c == 'Completed'
                    && oldProgramAssignments.get(updatedProgramAssignment.Id).Status__c != 'Completed'){
                updatedProgramAssignment.Completed_Date__c = Date.today();
            }else {
                updatedProgramAssignment.Completed_Date__c = null;
            }
        }  
    }
}
