import SpriteKit
import GameplayKit

// Constants
let PIPE_CATEGORY: UInt32 = 0x01
let BIRD_CATEGORY: UInt32 = 0x01 << 1
let PIPE_VELOCITY: CGFloat = 180.0;
let FRAMERATE: CGFloat = 60.0;
let PIPE_COOLDOWN = 1.6

class GameScene: SKScene, SKPhysicsContactDelegate {
    static var night = false
    
    // Map Class
    private var map : Map!
    private var mapController : MapController!

    // Variables that help control the game
    private var userTouched = false
    private var canMoveUp = false
    private var gamePaused = false
    private var pauseTimeStart = -1.0
    private var pauseTimeEnd = -1.0

    // Possibly randomized values
    private var bg = SKSpriteNode(imageNamed: "day")
    private var birdColor = 1
    
    
    init(size: CGSize, randomizeValues: Bool) {
        if (randomizeValues) {
            GameScene.night = !GameScene.night
            self.birdColor = Int.random(in: 1..<4)
        }
        if (GameScene.night) {
            bg = SKSpriteNode(imageNamed: "night")
        }
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        mapController.cleanup()
        mapController = nil
    }
    
    @objc func handleWillResignActive(notification: Notification) {
        if map.getPauseButton().parent != nil && !gamePaused {
            pauseGame()
        }
    }

    override func didMove(to view: SKView) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        GSAudio.sharedInstance.playSound(soundFileName: SoundFx.SceneChange)
        physicsWorld.contactDelegate = self
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        bg.anchorPoint = CGPoint(x: 0, y: 0);
        bg.position = CGPoint(x: 0, y: 0);
        bg.size = self.size;
        bg.zPosition = 0;
        bg.name = "bg";
        addChild(bg);
        
        //self.view?.showsPhysics = true;
        self.map = Map(gameScene: self, screenWidth: self.size.width, screenHeight: self.size.height, birdColor: self.birdColor);
        mapController = MapController(model: map);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userTouched = true
        
        touches.forEach { touch in
            if (map.getReplayButton().parent != nil && map.getReplayButton().contains(touch.location(in: self)) && !canMoveUp) {
                map.getReplayButton().position.y -= 2;
                canMoveUp = true;
            }
            if (map.getPauseButton().parent != nil && map.getPauseButton().contains(touch.location(in: self))) {
                userTouched = false
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            if (map.getReplayButton().parent != nil && map.getReplayButton().contains(touch.previousLocation(in: self)) && canMoveUp && !map.getReplayButton().contains(touch.location(in: self))) {
                map.getReplayButton().position.y += 2;
                canMoveUp = false;
            }
        }
    }
    
    private func pauseGame() {
        userTouched = false
        if (!gamePaused){
            map.getPauseButton().texture = map.getSpriteAtlas().textureNamed("play_mini")
            addChild(map.getDarkOverlay())
            map.getBird().stopFlying()
            map.getPipeArray().forEach({pipe in pipe.stopMoving()})

        } else {
            map.getDarkOverlay().removeFromParent()
            map.getBird().startFlying()
            map.getBird().physicsBody?.velocity.dy = -250
            map.getPipeArray().forEach({
                pipe in
                
                pipe.startMoving()
            })
    
            map.getPauseButton().texture = map.getSpriteAtlas().textureNamed("pause_mini")
            PipeController.lastPipeSpawnTime += pauseTimeEnd - pauseTimeStart
        }
        
        gamePaused = !gamePaused
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        touches.forEach { touch in
            if (map.getReplayButton().parent != nil && map.getReplayButton().contains(touch.location(in: self)) && canMoveUp) {
                map.getReplayButton().position.y += 2;
                canMoveUp = false;
                NotificationCenter.default.post(name: .changeToMainSceneWithRandomization, object: self) // Notify GameViewController to change scene.
                NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
            }
            
            if (map.getPauseButton().parent != nil && map.getPauseButton().contains(touch.location(in: self)) && !map.getBird().isDead()) {
                pauseGame()
            }
        }
        
        
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    
    override func update(_ currentTime: TimeInterval) {
        if (!gamePaused) {
            mapController?.step(touch: userTouched, time: currentTime);
            userTouched = false;
            pauseTimeStart = currentTime
        } else {
            if (map.getBird().isDead()) {
                gamePaused = false
            }
            pauseTimeEnd = currentTime
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        map.getBird().setDeadState(value: true);
        GSAudio.sharedInstance.playSound(soundFileName: SoundFx.Hit)
        GSAudio.sharedInstance.playSound(soundFileName: SoundFx.Death)
        mapController.setGroundSoundAsPlayed()
        map.getBird().physicsBody?.categoryBitMask = 0x00;
        map.getBird().physicsBody?.collisionBitMask = 0x00;
        map.getBird().physicsBody?.contactTestBitMask = 0x00;
    }

}
