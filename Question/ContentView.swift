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
    @State var questionText : String = ""
    @State var answerText : String = ""
    @State var showAnswer : Bool = false
    @FetchRequest(sortDescriptors: [])
    private var questions: FetchedResults<Question>

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if (showAnswer) {
                        Text(getQuestion()?.answer ?? "")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .padding(12)
                    } else {
                        Text(getQuestion()?.text ?? "")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .padding(12)
                    }
                }
                .frame(maxWidth: UIScreen.main.bounds.size.width - 32, maxHeight:300)
                .background(Color.mint).cornerRadius(10)
                Button(action: {
                    showAnswer = !showAnswer
                }) {
                    if showAnswer {
                       Text("Back")
                    } else {
                        Text("Show Answer")
                    }
                }.padding(16)
            }.navigationTitle("Question")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        isEditing = true
                    } ) {
                        Label("Edit Question", systemImage: "pencil")
                    }
                }
            }
        }.sheet(isPresented : $isEditing) {
            VStack {
                NavigationView {
                    Form {
                        Section {
                            TextField("Question", text: $questionText)
                        }
                        Section {
                            TextField("Answer", text: $answerText)
                        }
                        Section {
                            Button("Done") {
                                saveQuestion()
                            }
                        }
                    }.navigationBarTitle(Text("Edit Question"))
                }
            }.onAppear {
                questionText = getQuestion()?.text ?? ""
                answerText = getQuestion()?.answer ?? ""
            }
        }
    }
    
    private func getQuestion()  -> Question? {
        if questions.isEmpty {
            return nil
        } else {
            return questions[0]
        }
    }
    
    private func saveQuestion() {
        var question = getQuestion()
        if (question == nil) {
            question = Question(context : viewContext)
            question?.text = questionText
            question?.answer = answerText
        } else {
            question?.text = questionText
            question?.answer = answerText
        }
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
