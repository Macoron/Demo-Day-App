import Foundation

struct Presentation : Identifiable, Codable {
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
    
    
    // encoding - decoding logic
    enum CodingKeys: CodingKey {
        case id, name, speakersCount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        speakersCount = try container.decode(Int.self, forKey: .speakersCount)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(speakersCount, forKey: .speakersCount)
    }
}
