//
//  CoreDataProperties.swift
//  NotesApp
//
//  Created by Konstantin Bolgar-Danchenko on 26.12.2022.
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject, Identifiable {}

extension Note {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }
    
    @NSManaged public var date: Date
    @NSManaged public var id: String
    @NSManaged public var text: String
    @NSManaged public var title: String
    @NSManaged public var color: String
}
