//
//  PresentationsStore.swift
//  DemoDay Random (iOS)
//
//  Created by labsallday labsallday on 07.04.2021.
//

import Foundation

class PresentationsStore: ObservableObject {
    @Published var presentations : [Presentation]
    
    init(presentations : [Presentation] = []) {
        self.presentations = presentations
    }
    
    func calcTotalTime() -> TimeInterval {
        return presentations.reduce(0, { res, p in
            res + p.assumedTime
        })
    }
    
    func createTextReport() -> String {
        var ret = ""
        for (i, pres) in presentations.enumerated() {
            ret += "\(i + 1) - \(pres.name) (\(pres.speakersCount) speakers)\n"
        }
        
        return ret
    }
    
    func getDataPath() -> URL {
        let appDirectory = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory,.userDomainMask, true).first!
        
        let dataPath = URL(fileURLWithPath: appDirectory).appendingPathComponent("data.json")
        return dataPath
    }
    
    func loadData() {
        let dataPath = getDataPath()
        
        do {
            let json = try String(contentsOf: dataPath).data(using: .utf8)!
            let decoder = JSONDecoder()
            
            presentations = try decoder.decode([Presentation].self, from: json)
            
        } catch {
            print("Data file not found or invalid (might be first application start)")
        }
    }

    func saveData() {
        let dataPath = getDataPath()
        
        do {
            let encoder = JSONEncoder()
            let json = try encoder.encode(presentations)
            
            try json.write(to: dataPath)
        } catch {
            print("Failed to save data!")
        }
    }
}

let testProjects = [
    Presentation(name: "Rocket Science", speakersCount: 3),
    Presentation(name: "iOS Native Apps", speakersCount: 1),
    Presentation(name: "Monkey Studies", speakersCount: 4)
]

let testStore = PresentationsStore(presentations: testProjects)
