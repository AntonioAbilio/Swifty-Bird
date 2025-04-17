import GameplayKit


class MapController: GameController<Map> {
    
    private var triggerController: TriggerController?
    private var pipeController: PipeController?
    private var birdController: BirdController?
    private var scoreController: ScoreController?
    
    private var oldScoreValue : UInt64 = 0
    
    private var gameOverState = 0
    
    private var groundSoundPlayed : Bool = false
    private let gameOverLimitTop : CGPoint
    private let gameOverLimitBottom : CGPoint
    private let medalHolderLimit : CGPoint
    private let birdRange: SKRange
    private var updateTimer: Timer?
    
    override init(model: Map) {
        triggerController = TriggerController(model: model)
        pipeController = PipeController(model: model)
        birdController = BirdController(model: model)
        scoreController = ScoreController(model: model)
        
        gameOverLimitTop = CGPoint(x: (model.getScreenWidth() / 2) - model.getGameOverText().texture!.size().width / 2, y: (model.getScreenHeight() + model.getMedalHolder().texture!.size().height) / 2 + model.getGameOverText().texture!.size().height + 65)
        gameOverLimitBottom = CGPoint(x: (model.getScreenWidth() / 2) - model.getGameOverText().texture!.size().width / 2, y: (model.getScreenHeight() + model.getMedalHolder().texture!.size().height) / 2 + model.getGameOverText().texture!.size().height + 50)
        medalHolderLimit = CGPoint(x: (model.getScreenWidth() / 2) - model.getMedalHolder().texture!.size().width / 2, y: (model.getScreenHeight() / 2) - model.getMedalHolder().texture!.size().height / 2)
        birdRange = SKRange(lowerLimit: model.getBird().position.y - 8, upperLimit: model.getBird().position.y + 8);
        
        super.init(model: model)
    }
    
    func cleanup() {
        scoreController = nil
        triggerController = nil
        pipeController = nil
        birdController = nil
        super.model = nil
        
        if (updateTimer != nil) {
            if (updateTimer!.isValid) {
                updateTimer!.invalidate()
            }
            
        }
    }
    
    public func setGroundSoundAsPlayed() {
        groundSoundPlayed = true
    }
    
    private func checkForGroundCollision(groundBox: CGRect) {
        
        if (model.getBird().frame.intersects(groundBox)) {
            model.getBird().setDeadState(value: true)
            
            if (!groundSoundPlayed) {
                groundSoundPlayed = true;
                GSAudio.sharedInstance.playSound(soundFileName: SoundFx.Death)
            }
        }
        
    }
    
    private func updateGroundSprites() {
        for ground in model.getGroundSprites() {
            if (!model.getBird().isDead()) {
                if (ground.frame.maxX <= 0) {
                    let valuesMaxX = model.getGroundSprites().map{ (sprite) in
                        return sprite.frame.maxX
                    }
                    ground.position.x = valuesMaxX.max()!
                }
                ground.position.x -= PIPE_VELOCITY * (1.0/FRAMERATE) // FIXME
            }
            checkForGroundCollision(groundBox: ground.frame)
        }
        
        if (model.getBird().isDead()) {
            var groundSprites: [SKSpriteNode] = model.getGroundSprites()
            groundSprites.sort {
                switch ($0, $1) {
                case let (sprite1, sprite2):
                    return sprite1.position.x < sprite2.position.x
                }
            }
            
            for index in 0...groundSprites.count {
                if (index + 1 >= groundSprites.count){
                    break
                }
                groundSprites[index+1].position.x = groundSprites[index].size.width + groundSprites[index].position.x
            }
        }
    }
    
    override func step(touch: Bool, time: TimeInterval) {
        updateGroundSprites()
        
        if(model.getFirstTouch()) {
            
            if (birdRange.upperLimit == model.getBird().position.y) {
                model.getBird().physicsBody?.velocity = CGVector(dx: 0, dy: -60)
            }
            
            if (birdRange.lowerLimit == model.getBird().position.y) {
                model.getBird().physicsBody?.velocity = CGVector(dx: 0, dy: 60)
            }
            
            
            if (touch) {
                model.getGameScene().addChild(model.getPauseButton())
                model.getBird().constraints = [SKConstraint.zRotation(SKRange(lowerLimit: -(CGFloat.pi / 2), upperLimit: (CGFloat.pi / 8))), SKConstraint.positionY(SKRange(lowerLimit: 0.0, upperLimit: model.getScreenHeight())), SKConstraint.positionX(SKRange(lowerLimit: model.getBird().position.x, upperLimit: model.getBird().position.y))]
                model.getBird().physicsBody?.affectedByGravity = true
                model.getBird().physicsBody?.allowsRotation = true
                model.getBird().physicsBody?.linearDamping = 0
                model.getBird().physicsBody?.velocity = CGVector(dx: 0, dy: 500)
                GSAudio.sharedInstance.playSound(soundFileName: SoundFx.Wing)
                model.getTutorial().run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.1), SKAction.removeFromParent()]))
                model.getGetReadyText().run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.1), SKAction.removeFromParent()]))
                model.setFirstTouch(firstTouch: false)
            }
        } else {
            let isDead = model.getBird().isDead()
            
            triggerController?.step(touch: touch, time: time)
            pipeController?.step(touch: touch, time: time)
            birdController?.step(touch: touch, time: time)

            // Update score in all cases.
            if (oldScoreValue != model.getScore()) {
                scoreController?.step(touch: touch, time: time)
                oldScoreValue = model.getScore()
            }
            
            if (isDead) {
                model.getBird().zRotation -= 20 * (1.0/FRAMERATE) // Rotate bird to make it face the ground
                switch (gameOverState) {
                    case 0: // Display gameOver text
                        model.getPauseButton().removeFromParent()
                    
                        let screenFlash = SKSpriteNode()
                        screenFlash.color = UIColor.white
                        screenFlash.anchorPoint = CGPoint(x: 0, y: 0)
                        screenFlash.size = model.getGameScene().size
                        screenFlash.zPosition = 3
                        model.getGameScene().addChild(screenFlash)
                    
                        screenFlash.run(SKAction.sequence([
                            SKAction.fadeIn(withDuration: 0.01),
                            SKAction.fadeOut(withDuration: 0.3)
                        ]))

                        GSAudio.sharedInstance.playSound(soundFileName: SoundFx.SceneChange)
                        model.getGameOverText().position = CGPoint(x: (model.getScreenWidth() - model.getGameOverText().size.width) / 2 , y: medalHolderLimit.y + model.getMedalHolder().size.height)
                        model.getGameScene().addChild(model.getGameOverText())
                        gameOverState += 1
                        break
                    
                    case 1: // Move the gameover text up
                        if (gameOverLimitTop.y >= model.getGameOverText().position.y) {
                            model.getGameOverText().position.y += 500 * (1.0/FRAMERATE)
                        } else {
                            gameOverState += 1
                        }
                        break
                    
                    case 2: // Move the gameover text down
                        if (gameOverLimitBottom.y <= model.getGameOverText().position.y) {
                            model.getGameOverText().position.y -= 500 * (1.0/FRAMERATE)
                        } else {
                            gameOverState += 1
                        }
                        
                        break
                    
                    case 3: // Display the Medal Holder
                        model.getMedalHolder().position = CGPoint(x: (model.getScreenWidth() - model.getMedalHolder().size.width) / 2 , y: 0 - model.getMedalHolder().size.height)
                        model.getGameScene().addChild(model.getMedalHolder())
                        gameOverState += 1
                        break
                    
                    case 4: // Start the movement of Medal Holder and place the replay button
                        if (medalHolderLimit.y >= model.getMedalHolder().position.y) {
                            model.getMedalHolder().position.y += 3500 * (1.0/FRAMERATE)
                        } else {
                            gameOverState += 1
                        }
                        break
                    
                    
                    case 5: // GameOver scores
                        GSAudio.sharedInstance.playSound(soundFileName: SoundFx.SceneChange)
                        
                        model.gameOverScore.append(Score(x: ((model.getScreenWidth() / 2.0) + 110.0), y: medalHolderLimit.y + 100, textureType: scoreTexture.Normal))
                        model.bestScore.append(Score(x: (model.getScreenWidth() / 2.0) + 110.0, y: medalHolderLimit.y + 40, textureType: scoreTexture.Normal))
                        
                        model.getGameScene().addChild(model.gameOverScore[0])
                        model.getGameScene().addChild(model.bestScore[0])

                        var gameOverScore = model.gameOverScore
                        var bestScoreArray = model.bestScore
                        var modified = false
                        var updateIndex = 0
                        
                        let userScore = model.getScore()
                        var bestScore = UInt64(Database.getInstance().oldScore)
                        
                        if (userScore > bestScore) {
                            let newHighScoreTag = SKSpriteNode(texture: model.getSpriteAtlas().textureNamed("newHighScore"))
                            newHighScoreTag.position.y = medalHolderLimit.y + 89
                            newHighScoreTag.position.x = medalHolderLimit.x + 170
                            newHighScoreTag.size *= 1.5
                            newHighScoreTag.zPosition = 2
                            model.getGameScene().addChild(newHighScoreTag)
                            Database.getInstance().setNewScore(newScore: userScore)
                            bestScore = userScore
                        }
                        
                        let totalUpdates = userScore + bestScore

                        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.009, repeats: true) { [self] timer in
                            guard updateIndex < totalUpdates else {
                                timer.invalidate()
                                return
                            }
                            
                            var xOffset = 230
                            
                            switch (updateIndex){
                            case let x where x >= 1000000:
                                xOffset -= 130
                                break
                            case let x where x >= 100000:
                                xOffset -= 110
                                break
                            case let x where x >= 10000:
                                xOffset -= 80
                                break
                            case let x where x >= 1000:
                                xOffset -= 50
                                break
                            case let x where x >= 100:
                                xOffset -= 30
                                break
                            default:
                                break
                            }

                            if (updateIndex < userScore) {
                                scoreController?.positionScore(scoreArray: &gameOverScore,
                                                              modified: &modified,
                                                              widthOfComponent: (model.getScreenWidth() + Double(xOffset)),
                                                              currentBegginingY: medalHolderLimit.y)
                           }
                            
                            if (updateIndex < bestScore) {
                                scoreController?.positionScore(scoreArray: &bestScoreArray, modified: &modified, widthOfComponent: (model.getScreenWidth() + Double(xOffset)), currentBegginingY: medalHolderLimit.y)
                            }
                           updateIndex += 1
                        }

                        if (model.getScore() > 9) {
                            model.getGameScene().addChild(Medal(xPos: model.getMedalHolder().position.x + 72.0, yPos: model.getMedalHolder().position.y + 74.0, score: Int(model.getScore())))
                        }
                        model.getGameScene().addChild(model.getReplayButton())
                        gameOverState += 1
                        break
                    
                    default: // Do nothing
                        break
                    
                }

            }
        }
        
                
    }
}
