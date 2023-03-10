//
//  CoreDataManager.swift
//  NotesApp
//
//  Created by Konstantin Bolgar-Danchenko on 26.12.2022.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager(modelName: "CoreDataNote")
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    func createFirstNote() {
        let note = Note(context: viewContext)
        note.self.title = "Hello, CFT!"
        note.text = "I hope you like my test task.\nHave a nice day!\nKonstantin"
        note.id = UUID().uuidString
        note.date = Date()
        note.color = "Purple"
        save()
        MainViewController.allNotes.append(note)
        return
    }
    
    func createNote() -> Note {
        let note = Note(context: viewContext)
        note.self.title = ""
        note.text = ""
        note.id = UUID().uuidString
        note.date = Date()
        note.color = Styles.colorStrings.randomElement() ?? ""
        save()
        return note
    }
    
    // Saving note to Core Data
    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error occurred while saving to Core Data: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchNotes(filter: String? = nil) -> [Note] {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Note.date, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        // If filter is on
        if let filter = filter {
            let pr1 = NSPredicate(format: "title contains[cd] %@", filter)
            let pr2 = NSPredicate(format: "text contains[cd] %@", filter)
            let predicate = NSCompoundPredicate(type: .or, subpredicates: [pr1, pr2])
            request.predicate = predicate
        }
        return (try? viewContext.fetch(request)) ?? []
    }
    
    func deleteNote(_ note: Note) {
        viewContext.delete(note)
        save()
    }
}
