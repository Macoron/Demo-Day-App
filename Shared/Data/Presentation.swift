import Foundation

class Presentation : Identifiable, ObservableObject, Codable {
    // avg time in seconds for one person to finish presentation
    static let timePerCodable = 60.0 * 4
    
    var id = UUID()
    @Published var name : String
    @Published var speakersCount = 1
    
    var assumedTime : TimeInterval {
        return Double(speakersCount) * Presentation.timePerCodable
    }
    
    init(name: String, speakersCount: Int = 1) {
        self.name = name
        self.speakersCount = speakersCount
    }
    
    enum CodingKeys: CodingKey {
        case id, name, speakersCount
    }
    
    required init(from decoder: Decoder) throws {
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


func calcTotalTime(_ presentations: [Presentation]) -> TimeInterval {
    return presentations.reduce(0, { res, p in
        res + p.assumedTime
    })
}

func createShareReport(_ presentations: [Presentation]) -> String {
    var ret = ""
    for (i, pres) in presentations.enumerated() {
        ret += "\(i + 1) - \(pres.name) (\(pres.speakersCount) speakers)\n"
    }
    
    return ret
}

func getDataPath() -> URL {
    let appDirectory = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory,
                                                                .userDomainMask, true).first!
    
    let dataPath = URL(fileURLWithPath: appDirectory).appendingPathComponent("data.json")
    return dataPath
}

func loadData() -> [Presentation] {
    let dataPath = getDataPath()
    
    do {
        let json = try String(contentsOf: dataPath).data(using: .utf8)!
        let decoder = JSONDecoder()
        
        return try decoder.decode([Presentation].self, from: json)
        
    } catch {
        print("Data file not found or invalid (might be first application start)")
        return []
    }
}

func saveData(_ presentations: [Presentation]) {
    let dataPath = getDataPath()
    
    do {
        let encoder = JSONEncoder()
        let json = try encoder.encode(presentations)
        
        try json.write(to: dataPath)
    } catch {
        print("Failed to save data!")
    }
}

let testProjects = [
    Presentation(name: "Rocket Science", speakersCount: 3),
    Presentation(name: "iOS Native Apps", speakersCount: 1),
    Presentation(name: "Monkey Studies", speakersCount: 4)
]
