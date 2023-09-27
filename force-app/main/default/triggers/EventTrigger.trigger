trigger EventTrigger on Event (after insert) {

EventHandler.callutil(trigger.new);
}