import SpriteKit
import GameplayKit

class Map {
    
    private weak var gameScene : GameScene?
    private var screenWidth : CGFloat
    private var screenHeight : CGFloat
    
    private var lastPipeSpawnTime = TimeInterval()
    private var firstTouch = true
    private var scoreValue : UInt64 = 0
    
    private let bird : Bird
    private var pipes = [Pipe]()
    private var triggers = [Trigger]()
    private var currentScore = [Score]()
    private var groundSprites = [SKSpriteNode]()
    private var spriteAtlas = SKTextureAtlas(named: "Sprites")
    
    private var medalHolder : SKSpriteNode
    private var gameOverText : SKSpriteNode
    private var replayButton : SKSpriteNode
    private var pauseButton : SKSpriteNode
    private var darkOverlay : SKSpriteNode
    private var tutorial : SKSpriteNode
    private var getReadyText : SKSpriteNode
    var gameOverScore = [Score]()
    var bestScore = [Score]()
    
    init(gameScene: GameScene, screenWidth: CGFloat, screenHeight: CGFloat, birdColor: Int) {
        self.gameScene = gameScene
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight

        /* Score Init*/
        currentScore.append(Score(x: (screenWidth - spriteAtlas.textureNamed("zero").size().width) / 2, y: screenHeight - 100, textureType: scoreTexture.Normal))
        self.gameScene!.addChild(currentScore[0])
        
        /* Ground Init*/
        var startX = 0.0
        for _ in 0...4 {
            let groundSprite = SKSpriteNode(imageNamed: "ground")
            groundSprite.anchorPoint = CGPoint(x: 0, y: 0)
            groundSprite.position = CGPoint(x: startX, y: 0)
            groundSprite.zPosition = 2
            groundSprite.size = CGSize(width: screenWidth/2, height: groundSprite.size.height * 1.5)
            startX += groundSprite.size.width
            groundSprites.append(groundSprite)
            self.gameScene!.addChild(groundSprite)
        }
        
        /* Bird Init */
        self.bird = Bird(xPos: ((screenWidth / 2) - 80), yPos: screenHeight / 2, color: birdColor)
        self.bird.constraints = [SKConstraint.positionY(SKRange(lowerLimit: self.bird.position.y - 8, upperLimit: self.bird.position.y + 8))]
        self.gameScene!.addChild(bird)
        
        /* Tutorial Init */
        tutorial = SKSpriteNode(texture: spriteAtlas.textureNamed("tutorial"))
        tutorial.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tutorial.position = CGPoint(x: screenWidth / 2, y: ((screenHeight / 2)-8))
        tutorial.zPosition = 2
        tutorial.size *= 1.5
        self.gameScene!.addChild(tutorial)
        
        getReadyText = SKSpriteNode(texture: spriteAtlas.textureNamed("getReady"))
        getReadyText.anchorPoint = CGPoint(x: 0, y: 0)
        getReadyText.size *= 1.5
        getReadyText.position = CGPoint(x: (screenWidth / 2) - (getReadyText.size.width / 2), y: tutorial.frame.maxY + 20)
        getReadyText.zPosition = 2
        self.gameScene!.addChild(getReadyText)
        
        /* Medal Holder */
        medalHolder = SKSpriteNode(texture: spriteAtlas.textureNamed("medalHolder"))
        medalHolder.anchorPoint = CGPoint(x: 0, y: 0)
        medalHolder.zPosition = 1
        medalHolder.size *= 1.5
        
        /* Replay button */
        replayButton = SKSpriteNode(texture: spriteAtlas.textureNamed("playBig"))
        replayButton.anchorPoint = CGPoint(x: 0, y: 0)
        replayButton.size *= 1.5
        replayButton.position = CGPoint(x: (screenWidth / 2) - (replayButton.size.width / 2), y: groundSprites[0].frame.maxY)
        replayButton.zPosition = 2
        
        /* GameOver text */
        gameOverText = SKSpriteNode(texture: spriteAtlas.textureNamed("gameOver"))
        gameOverText.anchorPoint = CGPoint(x: 0, y: 0)
        gameOverText.size *= 1.5
        gameOverText.position = CGPoint(x: (screenWidth / 2) - (gameOverText.size.width / 2), y: groundSprites[0].frame.maxY)
        gameOverText.zPosition = 2
        
        /* Pause Button */
        pauseButton = SKSpriteNode(texture: spriteAtlas.textureNamed("pause_mini"))
        pauseButton.anchorPoint = CGPoint(x: 0, y: 0)
        pauseButton.size *= 1.5
        pauseButton.position = CGPoint(x: 140, y : screenHeight - 100)
        pauseButton.zPosition = 3
        
        /* Dark Overlay for Pause*/
        darkOverlay = SKSpriteNode()
        darkOverlay.color = UIColor.black
        darkOverlay.anchorPoint = CGPoint(x: 0, y: 0)
        darkOverlay.size = gameScene.size
        darkOverlay.alpha = 0.4
        darkOverlay.zPosition = 3
    }
    
    public func getBird() -> Bird{
        return self.bird
    }
    
    public func getPipeArray() -> [Pipe] {
        return self.pipes
    }
    
    public func getTriggerArray() -> [Trigger] {
        return self.triggers
    }
    
    public func getCurrentScoreArray() -> [Score] {
        return self.currentScore
    }
    
    public func getFirstTouch() -> Bool {
        return self.firstTouch
    }
    
    public func getGameScene() -> GameScene {
        return gameScene!
    }
    
    public func getScreenWidth() -> CGFloat {
        return screenWidth
    }
    
    public func getScreenHeight() -> CGFloat {
        return screenHeight
    }
    
    public func getScore() -> UInt64 {
        return scoreValue
    }
    
    public func getGroundSprites() -> [SKSpriteNode] {
        return groundSprites
    }
    
    public func getSpriteAtlas() -> SKTextureAtlas {
        return spriteAtlas
    }
    
    public func getMedalHolder() -> SKSpriteNode {
        return medalHolder
    }
    
    public func getReplayButton() -> SKSpriteNode {
        return replayButton
    }
    
    public func getGameOverText() -> SKSpriteNode {
        return gameOverText
    }
    
    public func getPauseButton() -> SKSpriteNode {
        return pauseButton
    }
    
    public func getDarkOverlay() -> SKSpriteNode {
        return darkOverlay
    }
    
    public func getTutorial() -> SKSpriteNode {
        return tutorial
    }
    
    public func getGetReadyText() -> SKSpriteNode {
        return getReadyText
    }
    
    public func setScoreArray(scoreArray: [Score]) {
        self.currentScore = scoreArray
    }
    
    public func setScore(value: UInt64) {
        scoreValue = value
    }
    
    public func setFirstTouch(firstTouch: Bool) {
        self.firstTouch = firstTouch
    }
    
    public func setPipeArray(pipeArray: [Pipe]) {
        self.pipes = pipeArray
    }
    
    public func setTriggerArray(triggerArray: [Trigger]) {
        self.triggers = triggerArray
    }
    
    
    
}
