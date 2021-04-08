//
//  PresentationsStore.swift
//  DemoDay Random (iOS)
//
//  Created by Alex Evgrashin on 07.04.2021.
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
    
    func getDataPath() throws -> URL {
        let dataPath = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("data.json")
        
        return dataPath
    }
    
    func loadData() {
        do {
            let dataPath = try getDataPath()
            let json = try String(contentsOf: dataPath).data(using: .utf8)!
            let decoder = JSONDecoder()
            
            presentations = try decoder.decode([Presentation].self, from: json)
            
        } catch {
            print("Data file not found or invalid (might be first application start)")
        }
    }

    func saveData() {
        do {
            let dataPath = try getDataPath()
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
