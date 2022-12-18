@isTest
private class TimesheetUpdateFiledsTest {

    @isTest
    static void updateRejectionCount_givenRejectedTimecard_shouldIncrement(){
        Project__c testProject = new Project__c();
        testProject.Name = 'Unit Test Project';
        insert testProject;
        
        Timesheet__c testTimesheet = new Timesheet__c();
        testTimesheet.Project__c = testProject.Id;
        testTimesheet.Timesheet_Status__c = 'Draft';
        testTimesheet.Employee__c = '0037c000015eFmHAAU';
        insert testTimesheet;

        Test.startTest();

        testTimesheet.Timesheet_Status__c = 'Rejected';
        update testTimesheet;

        Test.stopTest();

        List<Timesheet__c> updatedTimesheets = [ SELECT Reject_Count__c FROM Timesheet__c ];
        System.assertEquals(1, updatedTimesheets[0].Reject_Count__c, 
                                'Rejection Number should have been incremented');
    }

    @isTest
    static void updateRejectionCount_givenSubmittedTimecard_shouldNotIncrement(){
        Project__c testProject = new Project__c();
        testProject.Name = 'Unit Test Project';
        insert testProject;
        
        Timesheet__c testTimesheet = new Timesheet__c();
        testTimesheet.Project__c = testProject.Id;
        testTimesheet.Timesheet_Status__c = 'Draft';
        testTimesheet.Employee__c = '0037c000015eFmHAAU';
        insert testTimesheet;

        Test.startTest();

        testTimesheet.Timesheet_Status__c = 'Submitted';
        update testTimesheet;

        Test.stopTest();

        List<Timesheet__c> updatedTimesheets = [ SELECT Reject_Count__c FROM Timesheet__c ];
        System.assertEquals(0, updatedTimesheets[0].Reject_Count__c, 
                                'Rejection Number should not have been incremented');
    }

    @isTest
    static void updateRejectionCount_givenAlreadyRejectedTimecard_shouldNotIncrementAgain(){
        Project__c testProject = new Project__c();
        testProject.Name = 'Unit Test Project';
        insert testProject;
        
        Timesheet__c testTimesheet = new Timesheet__c();
        testTimesheet.Project__c = testProject.Id;
        testTimesheet.Timesheet_Status__c = 'Draft';
        testTimesheet.Employee__c = '0037c000015eFmHAAU';
        insert testTimesheet;

        testTimesheet.Timesheet_Status__c = 'Rejected';
        update testTimesheet;

        Test.startTest();
        
        update testTimesheet;

        Test.stopTest();

        List<Timesheet__c> updatedTimesheets = [ SELECT Reject_Count__c FROM Timesheet__c ];
        System.assertEquals(1, updatedTimesheets[0].Reject_Count__c, 
                                'Rejection Number should not have been incremented more than once');
    }

    @isTest
    static void updateProgramManager_givenNewlyCreatedTimesheet_shouldUpdateProjectManager(){
        Project__c testProject = new Project__c();
        testProject.Name = 'Unit Test Project';
        insert testProject;
        
        Timesheet__c testTimesheet = new Timesheet__c();
        testTimesheet.Project__c = testProject.Id;
        testTimesheet.Timesheet_Status__c = 'Draft';
        testTimesheet.Employee__c = UserInfo.getUserId();

        Test.startTest();      
        insert testTimesheet;
        Test.stopTest();

        List<Timesheet__c> updatedTimesheets = [ SELECT Project_Manager__c FROM Timesheet__c ];
        System.assertNotEquals(null, updatedTimesheets[0].Project_Manager__c, 
                                'Project Manager is not null');
    }
}

