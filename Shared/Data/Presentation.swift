import Foundation

struct Presentation : Identifiable {
    var id = UUID()
    
    var name : String
    var membersCount = 1
    
    // avg time in seconds for one person to finish presentation
    static let timePerMember = 60.0 * 4
    var assumedTime : TimeInterval {
        return Double(membersCount) * Presentation.timePerMember
    }
}

func calcTotalTime(_ presentations: [Presentation]) -> TimeInterval {
    return presentations.reduce(0, { res, p in
        res + p.assumedTime
    })
}

let testProjects = [
    Presentation(name: "Rocket Science", membersCount: 3),
    Presentation(name: "iOS Native Apps"),
    Presentation(name: "Monkey Studies")
]
