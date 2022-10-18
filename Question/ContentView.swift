//
//  ContentView.swift
//  Question
//
//  Created by William Ng on 10/12/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var isEditing : Bool = false
    @State var question : String = ""
    @State var answer : String = ""
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            VStack {
                Text($question.wrappedValue)
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: UIScreen.main.bounds.size.width - 32, maxHeight:300)
            .background(Color.mint).cornerRadius(10)
               
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        isEditing = true
                    } ) {
                        Label("Edit Question", systemImage: "pencil")
                    }
                }

            }
            Text("Select an item")
        }.sheet(isPresented : $isEditing) {
            VStack {
                NavigationView {
                    Form {
                        Section {
                            TextField("Question", text: $question)
                        }
                        Section {
                            TextField("Answer", text: $answer)
                        }
                        Section {
                            Button("Done") {
                                saveQuestion()
                            }
                        }
                    }.navigationBarTitle(Text("Edit Question"))
                }
            }
        }
    }

    private func saveQuestion() {
        isEditing = false
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
