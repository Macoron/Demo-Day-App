import Foundation

class Presentation : Identifiable, ObservableObject {
    var id = UUID()
    
    @Published var name : String
    @Published var speakersCount = 1
    
    init(name: String, speakersCount: Int = 1) {
        self.name = name
        self.speakersCount = speakersCount
    }
    
    // avg time in seconds for one person to finish presentation
    static let timePerMember = 60.0 * 4
    
    var assumedTime : TimeInterval {
        return Double(speakersCount) * Presentation.timePerMember
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

let testProjects = [
    Presentation(name: "Rocket Science", speakersCount: 3),
    Presentation(name: "iOS Native Apps", speakersCount: 1),
    Presentation(name: "Monkey Studies", speakersCount: 4)
]
