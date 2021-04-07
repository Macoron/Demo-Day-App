import Foundation

struct Presentation : Identifiable, Codable, Equatable {
    // avg time in seconds for one person to finish presentation
    static let timePerCodable = 60.0 * 4
    
    var id = UUID()
    var name : String
    var speakersCount = 1
    
    var assumedTime : TimeInterval {
        return Double(speakersCount) * Presentation.timePerCodable
    }
    
    init(name: String, speakersCount: Int = 1) {
        self.name = name
        self.speakersCount = speakersCount
    }
}
