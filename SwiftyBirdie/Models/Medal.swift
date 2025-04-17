import SpriteKit

class Medal : SKSpriteNode {
    
    private var _texture : SKTexture!
    private var s = SKTextureAtlas(named: "Sprites")
    private var dead = false
    
    init(xPos: Double, yPos: Double, score: Int) {

        switch (score) {
            case let p where p >= 10 && p < 20:
                _texture = s.textureNamed("copper_medal")
                break
            case let p where p >= 20 && p < 30:
                _texture = s.textureNamed("silver_medal")
                break
            case let p where p >= 30 && p < 40:
                _texture = s.textureNamed("gold_medal")
                break
            default:
                _texture = s.textureNamed("platinum_medal")
                break
        }
        
        super.init(texture: _texture, color: UIColor.white, size: CGSize(width: _texture.size().width, height: _texture.size().height))
        super.size *= 1.5
        super.position = CGPoint(x: xPos, y: yPos)
        super.zPosition = 2

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

