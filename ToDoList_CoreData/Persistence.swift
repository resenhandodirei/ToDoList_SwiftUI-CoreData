//
//  Persistence.swift
//  ToDoList_CoreData
//
//  Created by Larissa Martins Correa on 03/09/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    // Preview para o SwiftUI
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Adicionando dados de exemplo no preview
        for _ in 0..<5 {
            let newItem = TaskItem(context: viewContext)
            newItem.timestamp = Date()
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ToDoList_CoreData")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        // Permite que o contexto de visualização mescle automaticamente as alterações do contexto pai
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
