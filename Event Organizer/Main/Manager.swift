//
//  Manager.swift
//  Event Organizer
//
//  Created by Sreesh Srinivasan on 5/5/23.
//

import Foundation

struct Event: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var date: String
    var location: String
    var notes: String
    var tasks: [Task]
    var inventoryItems: [InventoryItem]
    var attendees: [Attendee]
}

struct Task: Identifiable,Codable,Hashable {
    var id = UUID()
    var name: String
    var status: String
}

enum TaskStatus: String, CaseIterable, Identifiable, Hashable {
    case notStarted = "Not started"
    case inProgress = "In progress"
    case completed = "Completed"
    
    var id: Self {self}
}

struct InventoryItem: Identifiable,Codable,Equatable,Hashable {
    var id = UUID()
    var name: String
    var quantity: String
    var quantityNeeded: String
}

struct Attendee: Identifiable, Equatable, Codable, Hashable {
    var id = UUID()
    var email: String
    var status: String 
}


var eventsDataArr: [Event] = []
func loadEventsData() -> [Event] {
    guard let username = UserDefaults.standard.string(forKey: "UserName") else {
        fatalError("Username not found in UserDefaults.")
    }
    let file = fileURL(forUsername: username)

    guard let jsonData = try? Data(contentsOf: file) else {
        return []
    }
    let decoder = JSONDecoder()
    guard let events = try? decoder.decode([Event].self, from: jsonData) else {
        fatalError("Failed to decode JSON data to events.")
    }

    eventsDataArr = events
    return eventsDataArr
}


func saveEventData(toSave: Event) {
    let file: URL
    
    if let index = eventsDataArr.firstIndex(where: { $0.id == toSave.id}) {
        // Update the event at the found index
        eventsDataArr.remove(at: index)
    }
    eventsDataArr.append(toSave)
    
    guard let username = UserDefaults.standard.string(forKey: "UserName") else {
        fatalError("Username not found in UserDefaults.")
    }
    
    if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                        in: .userDomainMask).first {
        file = fileURL(forUsername: username)
        
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // Optional: for pretty-printed output
        guard let jsonData = try? encoder.encode(eventsDataArr) else {
            fatalError("Failed to encode events to JSON.")
        }
        do {
            try jsonData.write(to: file)
        } catch {
            print("Failed to write JSON data to file: \(error)")
        }
    }
    else {
        print("documentDirectory Not Found")
    }
}


func fileURL(forUsername username: String) -> URL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let filename = "\(username)-eventsData.json"
    return documentsURL.appendingPathComponent(filename)
}

func removeEvent(_ event: Event) {
    if let index = eventsDataArr.firstIndex(where: { $0.name == event.name && $0.date == event.date && $0.location == event.location && $0.notes == event.notes }) {
        eventsDataArr.remove(at: index)
    }
}



