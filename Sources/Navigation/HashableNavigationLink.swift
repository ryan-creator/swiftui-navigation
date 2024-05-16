//
//  HashableNavigationLink.swift
//
//
//  Created by Ryan Cole on 17/05/2024.
//

import SwiftUI

struct HashableNavigationLink<D, C>: View where D: Hashable, C: View {

    @Environment(\.navigationHashValue) private var navigationHashValue

    @State private var destinationValue: D?
    @State private var presentDestination = false

    let data: D.Type
    @ViewBuilder let destination: (D) -> C

    var body: some View {
        NavigationLink(destination: generateDestination(destinationValue, destination), isActive: $presentDestination, label: {
            EmptyView()
        })
            .onChange(of: navigationHashValue.wrappedValue?.hashValue) { _ in
                if let unwrappedValue = navigationHashValue.wrappedValue as? D {
                    destinationValue = unwrappedValue
                    presentDestination = true
                }
            }
    }

    @ViewBuilder
    private func generateDestination(_ item: D?, @ViewBuilder _ destination: @escaping (D) -> C) -> some View where D: Hashable, C: View {
        ZStack {
            if let item {
                destination(item)
            } else {
                EmptyView()
            }
        }
        .onDisappear {
            destinationValue = nil
            presentDestination = false
            navigationHashValue.wrappedValue = nil
        }
    }
}
