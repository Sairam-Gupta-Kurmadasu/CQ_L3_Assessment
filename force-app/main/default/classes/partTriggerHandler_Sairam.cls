public class partTriggerHandler_Sairam{
    public static void whenPartIsInserted(List<compliancequest__SQX_Part__c>newParts){
        List<Task> newTasks = new List<Task>();
        if(newParts.size()>0){
            for(compliancequest__SQX_Part__c part : newParts){
                Task newTask = new Task();
                newTask.Subject = 'Review Part - '+part.compliancequest__Part_Number__c;
                newTask.ActivityDate = system.today()+7;
                newTask.OwnerId = part.ownerId;
                newTask.status = 'Not Started';
                newTask.WhatId = part.Id;
                newTasks.add(newTask);
            }
            if(newTasks.size()>0){
                insert newTasks;
            }
        }
    }

    public static void whenPartIsUpdated(Map<Id,compliancequest__SQX_Part__c>oldPartsMap, Map<Id,compliancequest__SQX_Part__c> newPartsMap){
        List<Task> oldTasks = [Select Id, status, WhatId, Subject, OwnerId, ActivityDate from Task where WhatId IN: newPartsMap.keyset() AND Subject like 'Review Part - %'];
        if(oldTasks.size()>0){
            for(Task updatedTask : oldTasks){
                if((oldPartsMap.get(updatedTask.whatId).compliancequest__Active__c != newPartsMap.get(updatedTask.whatId).compliancequest__Active__c) && newPartsMap.get(updatedTask.whatId).compliancequest__Active__c){
                    updatedTask.status = 'Completed';
                }
            }
            update oldTasks;
        }
    }
}