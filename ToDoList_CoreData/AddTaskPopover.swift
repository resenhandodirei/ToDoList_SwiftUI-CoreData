//
//  AddTaskPopover.swift
//  ToDoList_CoreData
//
//  Created by Larissa Martins Correa on 24/10/24.
//

import SwiftUI

struct AddTaskPopover: View {
    @Binding var isPresented: Bool
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var title: String = ""
    @State private var tag: String = ""
    @State private var description: String = ""

    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    isPresented = false
                }.foregroundStyle(.red)
                
                Spacer()
                
                Text("Add New Task")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.vertical, 46)
                    
                Spacer()

                Button("Save") {
                    saveTask()
                    isPresented = false
                }
            }
            
            TextField("Title", text: $title)
                .frame(width: .infinity, height: .infinity)
                .padding(.vertical, 12) // Aumente o preenchimento vertical
                .padding(.horizontal) // Preenchimento horizontal padrão
                .overlay(
                    RoundedRectangle(cornerRadius: 8) // Borda arredondada
                        .stroke(Color.gray, lineWidth: 1) // Cor e largura da borda
                )
            TextField("Tag", text: $tag)
                .frame(width: .infinity, height: .infinity)
                .padding(.vertical, 12) // Aumente o preenchimento vertical
                .padding(.horizontal) // Preenchimento horizontal padrão
                .overlay(
                    RoundedRectangle(cornerRadius: 8) // Borda arredondada
                        .stroke(Color.gray, lineWidth: 1) // Cor e largura da borda
                )
            
            TextField("Description", text: $description) // Usando TextEditor para a descrição
                .frame(width: .infinity, height: .infinity)
            
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8) // Borda arredondada
                                    .stroke(Color.gray, lineWidth: 1) // Cor e largura da borda
                            )
                            .border(Color.gray, width: 1)
                            .cornerRadius(5)
            
        }
        .padding()
        Spacer()
    }
    
    private func saveTask() {
        withAnimation {
            let newItem = TaskItem(context: viewContext)
            newItem.title = title
            newItem.tag = tag
            newItem.timestamp = Date()
            newItem.details = description // Certifique-se de que você tenha um campo 'details' em TaskItem

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
