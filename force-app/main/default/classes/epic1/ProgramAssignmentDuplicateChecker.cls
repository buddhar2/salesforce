public with sharing class ProgramAssignmentDuplicateChecker {
    
    public static Boolean checkForDuplicateProgramAssignment(List<Program_Assignment__c> newProgramAssignments) {
        Set<Id> newProgramSet = new Set<Id>();
        Set<Id> newEmployeeSet = new Set<Id>();
        Set<ProgramWrapperClass> queriedWrapperSet = new Set<ProgramWrapperClass>();
        Set<ProgramWrapperClass> newWrapperSet = new Set<ProgramWrapperClass>();

        for(Program_Assignment__c newProgramAssignment : newProgramAssignments) {
            ProgramWrapperClass iKey = new ProgramWrapperClass(
                                        newProgramAssignment.Program_Name__c,newProgramAssignment.Employee__c);
            if(newWrapperSet.contains(iKey)) {
                newProgramAssignment.addError('Duplicate in Program Assignments');
            }else {
                newProgramSet.add(newProgramAssignment.Program_Name__c);
                newEmployeeSet.add(newProgramAssignment.Employee__c);
                newWrapperSet.add(iKey);
            }
        }

        List<Program_Assignment__c> queriedProgramAssignments = [SELECT Id,Program_Name__c,Employee__c
                                                                    FROM Program_Assignment__c 
                                                                    WHERE Program_Name__c IN :newProgramSet 
                                                                    OR Employee__c IN :newEmployeeSet];
        
        for(Program_Assignment__c queriedProgramAssignment : queriedProgramAssignments) {
            queriedWrapperSet.add(new ProgramWrapperClass(queriedProgramAssignment.Program_Name__c,
                                                        queriedProgramAssignment.Employee__c));
        }
        
        for(Program_Assignment__c newProgramAssignment : newProgramAssignments) {
            ProgramWrapperClass iKey = new ProgramWrapperClass(
                                        newProgramAssignment.Program_Name__c,newProgramAssignment.Employee__c);
            if(queriedWrapperSet.contains(iKey)) {
                newProgramAssignment.addError('Program is already assigned to the Employee');
                return false;
            }
        }
        return true;
    }

    public static List<Contact> checkForDuplicateContacts(List<Contact> contactList,Id programId){

        List<Program_Assignment__c> queriedAssignments = [SELECT Id,Employee__c
                                                            FROM Program_Assignment__c 
                                                            WHERE Program_Name__c = :programId];
        
        if(queriedAssignments.size() > 0) {
            Set<Id> queriedEmployees = new Set<Id>();                                                            
            for(Program_Assignment__c queriedAssignment : queriedAssignments) {
                queriedEmployees.add(queriedAssignment.Employee__c);
            }

            List<Contact> uniqueContacts = new List<Contact>();
            for(Contact contact : contactList) {
                if(!queriedEmployees.contains(contact.Id)){
                    uniqueContacts.add(contact);
                }
            }
            return uniqueContacts;
        }
        return contactList;
    }
}
