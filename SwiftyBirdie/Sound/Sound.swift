import Foundation
import AVFoundation

public enum SoundFx: String, CaseIterable {
    case Point = "sfx_point"
    case Death = "sfx_die"
    case Hit = "sfx_hit"
    case Wing = "sfx_wing"
    case SceneChange = "sfx_swooshing"
}

class GSAudio {
    static let sharedInstance = GSAudio()
    private init() {
        mixer = audioEngine.mainMixerNode
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {}
    }

    let audioEngine = AVAudioEngine()
    let mixer: AVAudioMixerNode?
    private var playerNodes: [AVAudioPlayerNode] = []
    private let queue = DispatchQueue(label: "com.gs.audio.queue")

    func playSound(soundFileName: SoundFx) {
        queue.async {
            guard let bundlePath = Bundle.main.path(forResource: soundFileName.rawValue, ofType: "caf") else { return }
            let soundFileNameURL = URL(fileURLWithPath: bundlePath)
            do {
                // Start the audio engine if not already running
                if !self.audioEngine.isRunning {
                    try self.audioEngine.start()
                }
                let file = try AVAudioFile(forReading: soundFileNameURL)
                
                // Create and retain a new player node
                let playerNode = AVAudioPlayerNode()
                self.playerNodes.append(playerNode)
                self.audioEngine.attach(playerNode)
                self.audioEngine.connect(playerNode, to: self.mixer!, format: file.processingFormat)
                
                playerNode.play() // Start the player to ensure it is ready

                // Use a buffer for short sounds
                let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(file.length))!
                try file.read(into: buffer)
                
                playerNode.scheduleBuffer(buffer, at: nil, options: []) {
                    // Remove the player node after playback
                    self.queue.async {
                        self.audioEngine.detach(playerNode)
                        if let index = self.playerNodes.firstIndex(of: playerNode) {
                            self.playerNodes.remove(at: index)
                        }
                    }
                }
            } catch {}
        }
    }
}

