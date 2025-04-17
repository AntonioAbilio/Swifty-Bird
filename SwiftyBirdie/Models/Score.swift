import SpriteKit

enum scoreTexture : CaseIterable {
    case Normal, Mini, Minier
}

class Score : SKSpriteNode{
    
    private var score: Int
    private var full: Bool
    private var typeOfTexture: scoreTexture
    private var spriteSize: CGSize
    static let spaceWidth: CGFloat = 10
    
    
    init(x: Double, y: Double, textureType: scoreTexture) {
        typeOfTexture = textureType
        score = 0
        full = false
        var textureScore: SKTexture!
        
        switch (typeOfTexture) {
            case .Normal:
                textureScore = SKTexture(imageNamed: "zero")
                break
            case .Mini:
                textureScore = SKTexture(imageNamed: "zero_mini")
                break
            case .Minier:
                textureScore = SKTexture(imageNamed: "zero_minier")
                break
        }
        
        spriteSize = textureScore.size()
        
        super.init(texture: textureScore, color: UIColor.white, size: CGSize(width: textureScore.size().width, height: textureScore.size().height))
        self.anchorPoint = CGPoint(x: 0, y: 0)
        super.position = CGPoint(x: x, y: y)
        super.zPosition = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        score = 0
        full = false
        typeOfTexture = scoreTexture.Normal
        switch (typeOfTexture) {
            case .Normal:
                spriteSize = SKTexture(imageNamed: "zero").size()
                break
            case .Mini:
                spriteSize = SKTexture(imageNamed: "zero_mini").size()
                break
            case .Minier:
                spriteSize = SKTexture(imageNamed: "zero_minier").size()
                break
        }
        super.init(coder: aDecoder)
    }
    
    private func changeTexture() {
        
        var sufix = ""
        
        switch (typeOfTexture) {
            case .Mini:
                sufix = "_mini"
                break
            case .Minier:
                sufix = "_minier"
                break
            default:
                break
        }
        
        switch score {
        case 1:
            self.texture = SKTexture(imageNamed: "one\(sufix)")
            break
        case 2:
            self.texture = SKTexture(imageNamed: "two\(sufix)")
            break
        case 3:
            self.texture = SKTexture(imageNamed: "three\(sufix)")
            break
        case 4:
            self.texture = SKTexture(imageNamed: "four\(sufix)")
            break
        case 5:
            self.texture = SKTexture(imageNamed: "five\(sufix)")
            break
        case 6:
            self.texture = SKTexture(imageNamed: "six\(sufix)")
            break
        case 7:
            self.texture = SKTexture(imageNamed: "seven\(sufix)")
            break
        case 8:
            self.texture = SKTexture(imageNamed: "eight\(sufix)")
            break
        case 9:
            self.texture = SKTexture(imageNamed: "nine\(sufix)")
            break
        default:
            break
        }
    }
    
    public func getFull() -> Bool {
        return full
    }
    
    public func setFullFalse() {
        full = false
        self.texture = SKTexture(imageNamed: "zero")
        score = 0
    }
    
    public func incrementScore() {
        if ((score + 1) >= 9) {
            full = true
        }
        score += 1
        changeTexture()
        
    }
    
    public func getScore() -> Int {
        return score
    }
    
    public func getTypeOfTexture() -> scoreTexture {
        return typeOfTexture
    }
    
    public func getSizeOfTexture() -> CGSize {
        return spriteSize
    }
}
