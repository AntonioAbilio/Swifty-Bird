import Foundation
import SpriteKit

class Bird : SKSpriteNode {
    
    private var textures = [SKTexture]()
    private var s = SKTextureAtlas(named: "Sprites")
    private var dead = false
    private var wingAnimation: SKAction!
    
    init(xPos: Double, yPos: Double, color: Int) {
        // Create a texture with the given color and size

        switch (color) {
            case 3:
                textures.append(s.textureNamed("bird_red_up"))
                textures.append(s.textureNamed("bird_red_flat"))
                textures.append(s.textureNamed("bird_red_down"))
                break
            case 2:
                textures.append(s.textureNamed("bird_blue_up"))
                textures.append(s.textureNamed("bird_blue_flat"))
                textures.append(s.textureNamed("bird_blue_down"))
                break
            default:
                textures.append(s.textureNamed("bird_up"))
                textures.append(s.textureNamed("bird_flat"))
                textures.append(s.textureNamed("bird_down"))
                break
        }
        
        self.wingAnimation = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1314))
        super.init(texture: textures[0], color: UIColor.white, size: CGSize(width: textures[0].size().width * 1.5, height: textures[0].size().height * 1.5))
        super.position = CGPoint(x: xPos, y: yPos)
        super.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: textures[0].size().width * 1.1, height: textures[0].size().height * 1.1))
        super.physicsBody?.isDynamic = false
        super.physicsBody?.allowsRotation = true
        super.physicsBody?.restitution = 0
        super.physicsBody?.node!.run(wingAnimation, withKey: "wingFlap")
        super.physicsBody?.affectedByGravity = false;
        super.physicsBody?.isDynamic = true;
        super.physicsBody?.velocity = CGVector(dx: 0, dy: 50)
        super.physicsBody?.linearDamping = 1
        super.physicsBody?.categoryBitMask = BIRD_CATEGORY
        super.physicsBody?.collisionBitMask = PIPE_CATEGORY
        super.physicsBody?.contactTestBitMask = PIPE_CATEGORY
        super.zPosition = 1

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startFlying() {
        super.physicsBody?.isDynamic = true
    }
    
    func stopFlying() {
        super.physicsBody?.isDynamic = false
    }
    
    func setDeadState(value: Bool) {
        self.dead = value
    }
    
    func isDead() -> Bool {
        return self.dead
    }
    
    func setTexture(textureString: String) {
        switch (textureString) {
        case "up":
            self.texture = textures[0]
            break
        case "down":
            self.texture = textures[2]
            break
        default:
            self.texture = textures[1]
            break
        }
    }
    
    func getWingAnimation() -> SKAction {
        return wingAnimation
    }

}
