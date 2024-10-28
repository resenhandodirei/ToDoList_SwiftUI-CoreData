//
//  ContentView.swift
//  ToDoList_CoreData
//
//  Created by Larissa Martins Correa on 03/09/24.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskItem.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<TaskItem>

    @State private var showPopover = false

    var body: some View {
        NavigationView {
            ZStack {
                if items.isEmpty {
                    VStack {
                        Image(systemName: "list.bullet.rectangle")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        Text("No tasks available")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .padding()
                        Button(action: {
                            showPopover = true
                        }) {
                            Label("Add First Task", systemImage: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .background(Capsule().fill(Color.blue.opacity(0.1)))
                    }
                    .transition(.opacity)
                } else {
                    List {
                        ForEach(items) { item in
                            NavigationLink(destination: {
                                if let timestamp = item.timestamp {
                                    HStack {
                                        Text("Task created at \(timestamp, formatter: itemFormatter)")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                        
                                        NavigationLink(destination: EditTaskView(task: item)) {
                                            Image(systemName: "pencil.line")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .padding(.vertical, 16)
                                    Spacer()
                                } else {
                                    Text("No timestamp")
                                }
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        if let timestamp = item.timestamp {
                                            Text("Task at \(timestamp, formatter: itemFormatter)")
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                        } else {
                                            Text("No timestamp")
                                                .foregroundColor(.gray)
                                        }
                                        if let timestamp = item.timestamp {
                                            Text("Added on \(timestamp, formatter: dateOnlyFormatter)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10)
                                                .fill(Color(.systemGray6)))
                                .shadow(radius: 2)
                            }
                        }

                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("To-Do List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .font(.headline)
                }
                ToolbarItem {
                    Button(action: {
                        showPopover = true
                    }) {
                        Label("Add Task", systemImage: "plus.circle")
                            .font(.title3)
                    }
                }
            }
            .popover(isPresented: $showPopover) {
                AddTaskPopover(isPresented: $showPopover)
                    .environment(\.managedObjectContext, viewContext) // Passa o contexto do ManagedObject para o popover
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

private let dateOnlyFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

#Preview {
    TaskListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
