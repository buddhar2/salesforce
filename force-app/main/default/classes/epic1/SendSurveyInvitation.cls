public with sharing class SendSurveyInvitation {

    public static void createSurveyInv(List<Program_Assignment__c> completedProgramAssignments) {
        List<Id> programIds = new List<Id>();
        for(Program_Assignment__c pa : completedProgramAssignments) {
            programIds.add(pa.Program_Name__c);
        }


        Map<Id, Program__c> queriedProgramMap = new Map<Id, Program__c>(
                                        [SELECT Id, Survey_Name__c
                                            FROM Program__c
                                            WHERE Id IN :programIds]);
                                    
        List<SurveyInvitation> surveyInvitationList = new List<SurveyInvitation>();    
        
        String communityId = [SELECT Id FROM Network where Name = 'Customer Community'].Id;

        for(Program_Assignment__c pa : completedProgramAssignments) {
            SurveyInvitation surveyInvitation = New SurveyInvitation();
            surveyInvitation.Employee_Email__c = pa.Employee_Email__c;
            surveyInvitation.CommunityId = communityId;
            surveyInvitation.Contact__c = pa.Employee__c;
            surveyInvitation.Name = pa.Name;
            surveyInvitation.OptionsCollectAnonymousResponse = true;
            surveyInvitation.OptionsAllowGuestUserResponse = true;
            surveyInvitation.SurveyId = queriedProgramMap.get(pa.Program_Name__c).Survey_Name__c;
            surveyInvitationList.add(surveyInvitation);
        }
    
        System.debug( Database.insert(surveyInvitationList));
    }
}
  
