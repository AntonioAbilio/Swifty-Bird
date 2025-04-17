import GameplayKit

class BirdController: GameController<Map> {
    override func step(touch: Bool, time: TimeInterval) {
        
        if (model.getBird().zRotation < 0) {
            if (model.getBird().action(forKey: "wingFlap") != nil) {
                model.getBird().removeAction(forKey: "wingFlap")
                model.getBird().setTexture(textureString: "middle")
            }
        } else {
            if (model.getBird().action(forKey: "wingFlap") == nil) {
                model.getBird().run(model.getBird().getWingAnimation(), withKey: "wingFlap")
            }
        }
        
        if (model.getBird().isDead()) {
            return
        }
        
        if (touch) {
            GSAudio.sharedInstance.playSound(soundFileName: SoundFx.Wing)
            model.getBird().physicsBody?.velocity = CGVector(dx: 0, dy: 530)               
        }
        
        if (model.getBird().position.y > (model.getScreenHeight() - 10)) {
            model.getBird().physicsBody?.angularVelocity = -6.8
            model.getBird().physicsBody?.velocity = CGVector(dx: 0, dy: -140)
        }
        
        if ((model.getBird().physicsBody?.velocity.dy ?? 0) <= -250) {
            
            if (model.getBird().zRotation <= -(CGFloat.pi / 2)) {
                model.getBird().physicsBody?.angularVelocity = 0
            } else {
                model.getBird().physicsBody?.angularVelocity = -6.8
            }
            
        } else {
            model.getBird().physicsBody?.angularVelocity = 9.8
        }
        

    }
}
