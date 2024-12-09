//
//  RAPA_HostApp.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 11/30/24.
//

import SwiftUI

@main
struct RAPA_HostApp: App {
    @StateObject private var sessionManager = SessionManager()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(sessionManager)
        }
    }
}
