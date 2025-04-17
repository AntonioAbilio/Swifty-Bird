import SpriteKit

class Pipe : SKSpriteNode {
    
    let pipeType: String
    
    init(xPos: Double, yPos: Double, type: String) {
        pipeType = type
        
        var texture = SKTexture(imageNamed: "pipe_down")
        
        if (type == "up") {
            texture = SKTexture(imageNamed: "pipe_up")
        }

        super.init(texture: texture, color: UIColor.white, size: texture.size())

        super.position = CGPoint(x: xPos, y: yPos)
        super.size = CGSize(width: super.size.width * 2, height: super.size.height * 2)
                
        super.physicsBody = SKPhysicsBody(rectangleOf: super.size)
        super.physicsBody?.isDynamic = true
        super.physicsBody?.affectedByGravity = false
        super.physicsBody?.linearDamping = 0.0
        super.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        pipeType = "up"
        super.init(coder: aDecoder)
    }
    
    func moveLeft() {
        self.position = CGPoint(x: self.position.x - 1.0, y: self.position.y)
    }
    
    func stopMoving() {
        self.physicsBody!.isDynamic = false
    }
    
    func startMoving() {
        self.physicsBody!.isDynamic = true
        self.physicsBody!.velocity = CGVector(dx: -PIPE_VELOCITY , dy: 0)
    }
    
    func getPipeType() -> String {
        return pipeType
    }
    
}
