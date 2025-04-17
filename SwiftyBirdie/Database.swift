import Foundation

class Database {
    static private var instance : Database?
    let fileName = "birdb"
    var databaseExists = false
    var oldScore: UInt64 = 0
    
    private func writeToFile(newContent: String) {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            
            do {
                try newContent.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {}
        }
    }
    
    private func privateReadFromFile() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            
            do {
                // Read the file content
                let fileContent = try String(contentsOf: fileURL, encoding: .utf8)
                oldScore = UInt64(fileContent) ?? 0
            } catch {
                writeToFile(newContent: "0")
            }
        }
        databaseExists = true
    }

    private init() {
        privateReadFromFile()
    }
    
    static func getInstance() -> Database {
        if instance == nil {
            instance = Database()
        }
        return instance!
    }
    
    func getOldScore() -> UInt64 {
        return oldScore
    }
    
    func setNewScore(newScore: UInt64) {
        oldScore = newScore
        writeToFile(newContent: String(oldScore))
    }
    
}
