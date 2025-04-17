import SpriteKit

class Trigger : SKSpriteNode {
    
    private var alreadyUsed: Bool = false
    private var associatedPipe: Pipe?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(rectangleSize: CGSize, posX: Double, posY: Double, associatedPipe: Pipe) {
        let textureScore = SKTexture(imageNamed: "zero")
        super.init(texture: textureScore, color: UIColor.red, size: rectangleSize)
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.position = CGPoint(x: posX, y: posY)
        self.alpha = 0.0
        self.associatedPipe = associatedPipe
    }
    
    func wasUsed() -> Bool {
        return alreadyUsed
    }
    
    func setAsUsed() {
        GSAudio.sharedInstance.playSound(soundFileName: SoundFx.Point)
        alreadyUsed = true
    }
    
    func getAssociatedPipe() -> Pipe {
        return associatedPipe!
    }

}
