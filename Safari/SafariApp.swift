//
//  SafariApp.swift
//  Safari
//
//  Created by Zane Kleinberg on 7/26/21.
//

import SwiftUI

@main
struct SafariApp: App {
    @ObservedObject var bm_observer = bookmarks_observer()
    @ObservedObject var hs_observer = history_observer()
    var body: some Scene {
        WindowGroup {
            ContentView(bm_observer: bm_observer, hs_observer: hs_observer).edgesIgnoringSafeArea(.top).frame(minWidth: 800, maxWidth: .infinity, minHeight: 120, maxHeight: .infinity).onAppear {
                NSApplication.shared.windows.forEach({ $0.tabbingMode = .disallowed })
                if let mainMenu = NSApp .mainMenu {
                        DispatchQueue.main.async {
                            if let edit = mainMenu.items.first(where: { $0.title == "Format"}) {
                                mainMenu.removeItem(edit);
                            }
                        }
                    }
            }
        }.windowStyle(HiddenTitleBarWindowStyle()).commands() {
            CommandMenu("History") {
                ForEach(hs_observer.history) { history in
                
                    Button(history.name) {
                        hs_observer.selected_history = history.url
                            let nc = NotificationCenter.default
                            nc.post(name: Notification.Name("selected_history"), object: nil)
                         }
                }                     }
                 
        CommandMenu("Bookmarks") {
            
            ForEach((bm_observer.bookmarks ?? [:]).sorted(by: <), id: \.key) { key, value in
            
                     Button(value) {
                        bm_observer.selected_bookmark = key
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("selected_bookmark"), object: nil)
                     }
            }
                 }
        CommandGroup(after: CommandGroupPlacement.newItem) {
                       Button("New Tab") {
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("addTab"), object: nil)
                       }.keyboardShortcut("t", modifiers: [.command])
                   }
           // CommandGroup(replacing: CommandGroupPlacement.textFormatting, addition: {})
        }
    }
}

class bookmarks_observer: ObservableObject {
    @Published var selected_bookmark: String = ""
    @Published var bookmarks: [String:String] {
        didSet {
            UserDefaults.standard.set(bookmarks, forKey: "bookmarks")
        }
    }
    
    init() {
        self.bookmarks = UserDefaults.standard.object(forKey: "bookmarks") as? [String:String] ?? [:]
    }
    func update_bookmarks() {
        self.bookmarks = UserDefaults.standard.object(forKey: "bookmarks") as? [String:String] ?? [:]
    }
}

struct history_id: Identifiable {
    let id = UUID()
    let name: String
    let url: String
}


class history_observer: ObservableObject {
    @Published var selected_history: String = ""
    @Published var history: [history_id] = [history_id]() {
        didSet {
           // UserDefaults.standard.set(bookmarks, forKey: "bookmarks")
        }
    }
    init() {
    }
}
