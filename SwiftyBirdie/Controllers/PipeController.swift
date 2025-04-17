import GameplayKit

class PipeController: GameController<Map> {
    
    static var lastPipeSpawnTime = 0.0
    
    override func step(touch: Bool, time: TimeInterval) {
        
        if (model.getBird().isDead()) {
            
            model.getPipeArray().forEach{pipe in
                pipe.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            }
            
            return
        }
        
        
        if (model.getFirstTouch()) {
            PipeController.lastPipeSpawnTime = time
        } else {
            
            model.getPipeArray().forEach { pipe in
                if (pipe.frame.maxX <= 0) {
                    pipe.removeFromParent()
                    
                    var pipeArray = model.getPipeArray()
                    pipeArray.removeAll(where: {$0 == pipe})
                    model.setPipeArray(pipeArray: pipeArray)
                }
            }
            
            if ((time - PipeController.lastPipeSpawnTime) >= PIPE_COOLDOWN) {
                let (latestPipeUP, latestPipeDown) = createNewPipe(windowWidth: model.getScreenWidth())

                model.setPipeArray(pipeArray: model.getPipeArray() + [latestPipeUP, latestPipeDown])

                let newTrigger = Trigger(rectangleSize: CGSize(width: 1.0, height: (latestPipeUP.frame.minY - latestPipeDown.frame.maxY)), posX: latestPipeDown.frame.maxX - (latestPipeDown.size.width/2), posY: latestPipeDown.frame.maxY, associatedPipe: latestPipeDown)

                latestPipeUP.physicsBody?.velocity = CGVector(dx: -PIPE_VELOCITY, dy: 0)
                latestPipeDown.physicsBody?.velocity = CGVector(dx: -PIPE_VELOCITY , dy: 0)
                
                model.setTriggerArray(triggerArray: model.getTriggerArray() + [newTrigger])
                
                model.getGameScene().addChild(latestPipeUP)
                model.getGameScene().addChild(latestPipeDown)
                model.getGameScene().addChild(newTrigger)
                
                PipeController.lastPipeSpawnTime = time

            }
        }
    }
}

