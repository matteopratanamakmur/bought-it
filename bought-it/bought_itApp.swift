//
//  bought_itApp.swift
//  bought-it
//
//  Created by yuhori on 2020/12/29.
//

import SwiftUI

@main
struct bought_itApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
