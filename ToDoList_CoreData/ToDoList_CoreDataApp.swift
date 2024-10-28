//
//  ToDoList_CoreDataApp.swift
//  ToDoList_CoreData
//
//  Created by Larissa Martins Correa on 03/09/24.
//

import SwiftUI

@main
struct ToDoList_CoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TaskListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
