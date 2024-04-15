@isTest
public class partTriggerHandler_Sairam_TC{
    @TestSetup
    static void creatingUser(){
        List<Profile> profiles = [SELECT Id, Name from Profile where Name = 'Standard User'];
        User newUser = new User();
        newUser.LastName = 'sairam';
        newUser.Alias = 'tst';
        newUser.UserName = 'SairamTest@CQDev.com';
        newUser.Email = 'SairamTest@gmail.com';
        newUser.CompanyName = 'test';
        newUser.Division = 'test';
        newUser.Department = 'Technology';
        newUser.Street = 'test street';
        newUser.City = 'test city';
        newUser.State = 'test state';
        newUser.PostalCode = '123abc';
        newUser.Country = 'IND';
        newUser.Phone = '1111111111';
        newUser.MobilePhone = '1234567890';
        newUser.ProfileId = profiles[0].Id;
        newUser.TimeZoneSidKey = 'America/Los_Angeles';
        newUser.LocaleSidKey = 'en_US';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LanguageLocaleKey = 'en_US';
        insert newUser;
    }
    @isTest
    public static void CheckingTaskCreationWhilePartCreation(){
        compliancequest__SQX_Part_Family__c partFamily = new compliancequest__SQX_Part_Family__c();
        partFamily.Name = 'test Part Family';
        insert partFamily;
        
        compliancequest__SQX_Part__c part = new compliancequest__SQX_Part__c();
        part.Name = 'test sairam';
        part.compliancequest__Active__c = false;
        part.compliancequest__Part_Family__c = partFamily.Id;
        part.compliancequest__Part_Risk_Level__c = 2;
        part.compliancequest__Part_Number__c = '154242024000000000';
        insert part;
        
        List<Task> CreatedTasks = [Select Id, whatId, Subject, Status, ownerId,ActivityDate from Task where whatId=: part.Id AND Subject like 'Review Part - %'];
        system.assert(CreatedTasks.size()>0, 'Task was not created');
        system.assert(CreatedTasks[0].ActivityDate == system.today()+7, 'Task Due date must be in after week');
        system.assert(CreatedTasks[0].Subject.contains('Review Part - '+part.compliancequest__Part_Number__c),'Task subject doesnt contains their related part number');
        system.assert(CreatedTasks[0].Status=='Not Started', 'Task Status must be Not Started');
        
    }
    
    @isTest
    public static void CheckingTaskUpdationWhilePartUpdation(){
        
        
        
        User newUser = [Select Id, UserName from User where UserName = 'SairamTest@CQDev.com'];
        List<PermissionSet> CQpermissionSet = [Select Id, Name from PermissionSet where Name = 'CQ_Admin_Permission_Set_Sairam'];
        PermissionSetAssignment permissionAssign = new PermissionSetAssignment();
        permissionAssign.AssigneeId = newUser.Id;
        permissionAssign.PermissionSetId = CQpermissionSet[0].Id;
        insert permissionAssign;
        
        system.runAs(newUser){
            compliancequest__SQX_Part_Family__c partFamily = new compliancequest__SQX_Part_Family__c();
            partFamily.Name = 'test Part Family';
            insert partFamily;
            
            compliancequest__SQX_Part__c part = new compliancequest__SQX_Part__c();
            part.Name = 'test sairam';
            part.compliancequest__Active__c = false;
            part.compliancequest__Part_Family__c = partFamily.Id;
            part.compliancequest__Part_Risk_Level__c = 2;
            part.compliancequest__Part_Number__c = '154242024000000000';
            insert part;
            
            part.compliancequest__Active__c = true;
            part.compliancequest__Reason_For_Change__c = 'test sairam';
            update part;
            
            List<Task> partTasks = [Select Id,Status,WhatId,Subject from Task where WhatId=: part.Id AND Subject like 'Review Part - %'];
            system.assert(partTasks[0].Status == 'Completed', 'Task Must be Completed, when after Part is Activated');
        }
    }
}