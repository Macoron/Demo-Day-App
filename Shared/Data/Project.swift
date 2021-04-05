//
//  Project.swift
//  Demo List
//
//  Created by labsallday labsallday on 05.04.2021.
//

import Foundation

struct Presentation : Identifiable {
    var id = UUID()
    
    var name : String
    var membersCount = 1
    
    // avg time for one person to finish presentation
    static let timePerMember = 60.0 * 5
    
    var assumedTime : TimeInterval {
        return Double(membersCount) * Presentation.timePerMember
    }
}

let testProjects = [
    Presentation(name: "AR Navigation"),
    Presentation(name: "Digital Avatars"),
    Presentation(name: "GAUDI")
]
