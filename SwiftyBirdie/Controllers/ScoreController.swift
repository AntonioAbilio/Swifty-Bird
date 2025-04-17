import GameplayKit

class ScoreController: GameController<Map> {
    
    private func updatePositionOfScoreSprite(scores: inout [Score], startX : Double, spriteSize : Double, widthOfComponent: Double) {
        var newBeginning = startX - spriteSize
        var accForWidth = 0.0
        
        for score in scores {
            score.position.x = newBeginning
            accForWidth += score.getSizeOfTexture().width
            newBeginning += spriteSize
        }
        
        var newStart = (widthOfComponent - accForWidth) / 2.0
        for score in scores {
            score.position.x = newStart
            newStart += score.getSizeOfTexture().width
        }
    }
    
    public func positionScore(scoreArray: inout [Score], modified: inout Bool, widthOfComponent: Double, currentBegginingY: Double) {
        let currentBegginingX = scoreArray[0].position.x
        
        var lastElem = scoreArray.count - 1
        var needNewNumber = true
        
        if (scoreArray[lastElem].getFull()) {
            
            while (lastElem >= 0) {
                
                // Test if element has space for a value
                if (!scoreArray[lastElem].getFull()) {
                    needNewNumber = false
                    scoreArray[lastElem].incrementScore()
                    break
                } else {
                    scoreArray[lastElem].setFullFalse()
                }
                
                lastElem -= 1
            }
            
            if (needNewNumber) {
                let referenceY = scoreArray[0].position.y
                let newScoreSprite = Score(x: 0, y: referenceY, textureType: .Normal)
                newScoreSprite.incrementScore()
                
                var newArray = [newScoreSprite] + scoreArray
                
                for idx in Array(1...(newArray.count-1)) {
                    newArray[idx].setFullFalse()
                }
                modified = true
                scoreArray = newArray
                updatePositionOfScoreSprite(scores: &newArray, startX: currentBegginingX, spriteSize: newScoreSprite.size.width, widthOfComponent: widthOfComponent)
                model.getGameScene().addChild(newScoreSprite)
                needNewNumber = false
            }
            
        } else {
            scoreArray[lastElem].incrementScore()
        }
        
    }
    
    
    override func step(touch: Bool, time: TimeInterval) {
        
        var currentScoreArray = model.getCurrentScoreArray()
        var wasModified = false
        
        positionScore(scoreArray: &currentScoreArray, modified: &wasModified, widthOfComponent: model.getScreenWidth(), currentBegginingY: currentScoreArray[0].position.y)
        
        if (wasModified) {
            model.setScoreArray(scoreArray: currentScoreArray)
        }
        
    }
        
        
}
