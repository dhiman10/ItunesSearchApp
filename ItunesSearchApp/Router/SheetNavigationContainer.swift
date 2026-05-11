//
//  SheetCoordinatorContainer.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 19.12.25.
//
import SwiftUI


struct SheetNavigationContainer: View {

    let modal: SearchModal
    let modalDestination: (SearchModal, SearchCoordinator) -> AnyView

    // 🔥 NEW coordinator for THIS navigation stack
    @State private var sheetCoordinator = SearchCoordinator()

    var body: some View {
        NavigationStack(path: $sheetCoordinator.path) {
            modalDestination(modal, sheetCoordinator)
        }
    }
}

