trigger partTrigger_Sairam on compliancequest__SQX_Part__c(after insert, after update){
    if(trigger.isAfter && trigger.isInsert){
        partTriggerHandler_Sairam.whenPartIsInserted(trigger.new);
    }
    if(trigger.isAfter && trigger.isUpdate){
        partTriggerHandler_Sairam.whenPartIsUpdated(trigger.oldMap, trigger.newMap);
    }
}