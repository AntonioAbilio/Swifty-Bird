import GameplayKit

// TODO: Define the zPositions inside the nodes.

class MainMenuScene: SKScene {
    
    private let bg = SKSpriteNode(imageNamed: "day");
    //private let logo = SKSpriteNode(imageNamed: "");
    private let startButton = SKSpriteNode(imageNamed: "playBig");
    private var canMoveUp = false;
    private var finishedLoading = false;
    private let bird = Bird(xPos: 0, yPos: 0, color: 1);
    private var birdRange: SKRange? = nil;
    private var groundSprites = [SKSpriteNode]();
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0, y: 0);
        let screenWidth = self.size.width;
        let screenHeight = self.size.height;
        
        /* Background init */
        bg.anchorPoint = CGPoint(x: 0, y: 0);
        bg.position = CGPoint(x: 0, y: 0);
        bg.size = self.size;
        addChild(bg)
        
        /* Logo init */
        //logo.zPosition = 2;
        //logo.anchorPoint = CGPoint(x: 0, y: 0);
        //logo.size *= 1.5;
        //logo.position = CGPoint(x: (screenWidth / 2) - (logo.size.width / 2), y: (screenHeight / 2) + (screenHeight * 0.10));
        //logo.zPosition = 2;
        //addChild(logo)
        
        /* Ground Sprites init */
        var startX = 0.0;
        for _ in 0...4 {
            let groundSprite = SKSpriteNode(imageNamed: "ground");
            groundSprite.anchorPoint = CGPoint(x: 0, y: 0);
            groundSprite.position = CGPoint(x: startX, y: 0.0);
            groundSprite.zPosition = 2;
            groundSprite.size = CGSize(width: screenWidth/2, height: groundSprite.size.height * 1.5);
            startX += groundSprite.size.width;
        

            groundSprite.zPosition = 2;
            groundSprites.append(groundSprite);
            addChild(groundSprite);
        }
        
        /* Bird init */
        bird.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2);
        birdRange = SKRange(lowerLimit: bird.position.y - 8, upperLimit: bird.position.y + 8);
        bird.constraints = [SKConstraint.positionY(birdRange!)]
        bird.zPosition = 2;
        addChild(bird);
        
        /* Start Button init */
        startButton.anchorPoint = CGPoint(x: 0, y: 0);
        startButton.size *= 1.5;
        startButton.position = CGPoint(x: (screenWidth / 2) - (startButton.size.width / 2), y: groundSprites[0].frame.maxY)
        startButton.zPosition = 2;
        addChild(startButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            if (startButton.contains(touch.location(in: self)) && !canMoveUp) {
                startButton.position.y -= 2;
                canMoveUp = true;
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            if (startButton.contains(touch.previousLocation(in: self)) && canMoveUp && !startButton.contains(touch.location(in: self))) {
                startButton.position.y += 2;
                canMoveUp = false;
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            if (startButton.contains(touch.location(in: self)) && canMoveUp) {
                startButton.position.y += 2;
                canMoveUp = false;
                NotificationCenter.default.post(name: .changeToMainSceneNoRandomization, object: self) // Notify GameViewController to change scene.
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    private func updateGroundSprites() {
        for ground in groundSprites {
            if (ground.frame.maxX <= 0) {
                let valuesMaxX = groundSprites.map{ (sprite) in
                    return sprite.frame.maxX
                }
                ground.position.x = valuesMaxX.max()!
            }
            ground.position.x -= PIPE_VELOCITY * (1.0/FRAMERATE)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateGroundSprites()
        
        if (birdRange!.upperLimit == bird.position.y) {
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: -50)
        }
        
        if (birdRange!.lowerLimit == bird.position.y) {
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 50)
        }
        
        bird.physicsBody?.linearDamping = 1
    }
    
}
