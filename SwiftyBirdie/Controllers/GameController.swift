import GameplayKit

protocol Controller {
    associatedtype ModelType
    var model: ModelType! { get set }
    func step(touch: Bool, time: TimeInterval)
}

class GameController<T>: Controller {
    var model: T!
    
    init(model: T) {
        self.model = model
    }
    
    func step(touch: Bool, time: TimeInterval) {
        fatalError("This method should be overridden by subclasses")
    }
}
