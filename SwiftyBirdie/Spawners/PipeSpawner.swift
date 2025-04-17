import SpriteKit
import Foundation

func createNewPipe(windowWidth: Double) -> (Pipe, Pipe){
    
    let pipePositions = [-300.0,-260.0,-220.0,-180.0,-140.0,-60.0,-20.0,20.0,60.0,100.0,120.0]
    
    let offset = pipePositions.randomElement()!
    
    let spawnPointX = windowWidth + 100
    
    let pipeDown = Pipe(xPos: spawnPointX, yPos: (610 - SKTexture(imageNamed: "pipe_down").size().height + offset), type: "down")
    pipeDown.physicsBody?.categoryBitMask = PIPE_CATEGORY
    pipeDown.physicsBody?.collisionBitMask = 0
    
    let pipeUP = Pipe(xPos: spawnPointX, yPos: (770 + SKTexture(imageNamed: "pipe_up").size().height + offset), type: "up")
    pipeUP.physicsBody?.categoryBitMask = PIPE_CATEGORY
    pipeUP.physicsBody?.collisionBitMask = 0
    
    return (pipeUP, pipeDown)
}
