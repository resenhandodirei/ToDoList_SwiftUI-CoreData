//
//  EditTaskView.swift
//  ToDoList_CoreData
//
//  Created by Larissa Martins Correa on 25/10/24.
//

import SwiftUI

struct EditTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var task: TaskItem
    @State private var updatedText: String = ""
    @State private var textEditorHeight: CGFloat = 40 // Altura inicial

    var body: some View {
        VStack {
            ResizableTextEditor(text: $updatedText, height: $textEditorHeight, placeholder: "Digite sua tarefa aqui...")
                .frame(height: textEditorHeight)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )

            Button("Save") {
                task.name = updatedText
                do {
                    try viewContext.save()
                } catch {
                    print("Error saving updated task: \(error)")
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .onAppear {
            updatedText = task.name ?? ""
        }
        .padding()
    }
}

struct ResizableTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat
    var placeholder: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = context.coordinator
        textView.text = placeholder
        textView.textColor = .gray
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text.isEmpty ? placeholder : text
        uiView.textColor = text.isEmpty ? .gray : .label
        
        DispatchQueue.main.async {
            let size = uiView.sizeThatFits(CGSize(width: uiView.frame.width, height: CGFloat.greatestFiniteMagnitude))
            height = size.height
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: ResizableTextEditor

        init(_ parent: ResizableTextEditor) {
            self.parent = parent
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == parent.placeholder {
                textView.text = ""
                textView.textColor = .label
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = .gray
            }
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}
