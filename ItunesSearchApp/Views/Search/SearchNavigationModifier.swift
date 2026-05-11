//
//  SearchNavigationModifier.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 19.12.25.
//


import SwiftUI

struct SearchNavigationModifier: ViewModifier {

    @Bindable var coordinator: SearchCoordinator

    let destination: (SearchRoute) -> AnyView
    let modalDestination: (SearchModal, SearchCoordinator) -> AnyView

    func body(content: Content) -> some View {
        content
            .navigationDestination(for: SearchRoute.self) { route in
                destination(route)
            }
            .sheet(item: $coordinator.sheet) { modal in
                SheetNavigationContainer(
                    modal: modal,
                    modalDestination: modalDestination
                )
            }
            .fullScreenCover(item: $coordinator.fullScreen) { modal in
                SheetNavigationContainer(
                    modal: modal,
                    modalDestination: modalDestination
                )
            }    }
}

extension View {
    func searchNavigation(
        coordinator: SearchCoordinator,
        @ViewBuilder destination: @escaping (SearchRoute) -> some View,
        @ViewBuilder modalDestination: @escaping (SearchModal, SearchCoordinator) -> some View
    ) -> some View {
        modifier(
            SearchNavigationModifier(
                coordinator: coordinator,
                destination: { AnyView(destination($0)) },
                modalDestination: { AnyView(modalDestination($0, $1)) }
            )
        )
    }
}
