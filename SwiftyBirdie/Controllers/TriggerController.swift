import GameplayKit

class TriggerController: GameController<Map> {
    
    override func step(touch: Bool, time: TimeInterval) {

        if (model.getBird().isDead()) {
            return
        }
        
        model.getTriggerArray().forEach { trigger in
            
            if (trigger.frame.maxX <= 0) {
                trigger.removeFromParent()
                
                var triggerArray = model.getTriggerArray()
                triggerArray.removeAll(where: {$0 == trigger})
                model.setTriggerArray(triggerArray: triggerArray)
            }
            
            trigger.position.x = trigger.getAssociatedPipe().frame.maxX - (trigger.getAssociatedPipe().size.width/2)
            
            if (!trigger.wasUsed()) {
                if (trigger.frame.intersects(model.getBird().frame)) {
                    model.setScore(value: model.getScore() + 1)
                    trigger.setAsUsed()
                    
                }
            }
            
            
        }
        
        
    }
}
