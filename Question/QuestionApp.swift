//
//  QuestionApp.swift
//  Question
//
//  Created by William Ng on 10/12/22.
//
// Lets users create a question with and answer
// and maybe lets users write an new answer each time and saves it

import SwiftUI

@main
struct QuestionApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
