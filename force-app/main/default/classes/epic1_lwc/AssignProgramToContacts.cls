public with sharing class AssignProgramToContacts {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList(Id programId){
        try {
            List<Contact> contactList = [SELECT Name,Title
                                            FROM Contact]; 
            contactList = ProgramAssignmentDuplicateChecker.checkForDuplicateContacts(contactList,programId);                                                                                  
            return contactList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Program_Assignment__c> getProgramAssignments(Id programId){
        try {
            List<Program_Assignment__c> assignmnetList = [SELECT Employee__r.Name,Employee__r.Title
                                                            FROM Program_Assignment__c
                                                            WHERE Program_Name__c = :programId];                                                                                   
            return assignmnetList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void assignToMultipleContacts(List<Contact> selectedContactList, Id programId){
        System.debug(selectedContactList);
        try {
            List<Program_Assignment__c> programAssignmentList = new List<Program_Assignment__c>();
            for(Contact selectedContact: selectedContactList) {
                Program_Assignment__c assignment= new Program_Assignment__c();
                assignment.Program_Name__c = programId;
                assignment.Employee__c = selectedContact.Id;
                //assignment.Start_Date__c = Date.today();
                programAssignmentList.add(assignment);
            }
            insert programAssignmentList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteProgramAssignments(List<Program_Assignment__c> selectedAssignments){
        try {
            delete selectedAssignments;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}
