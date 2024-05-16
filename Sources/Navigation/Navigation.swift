//
//  Navigation.swift
//
//
//  Created by Ryan Cole on 6/03/24.
//

import SwiftUI

public extension View {

    @ViewBuilder
    /// This is a wrapper function that interfaces the same as the new SwiftUI
    /// navigationDestination modifier but also works for iOS versions below 16.
    /// This function requires to be used within a `NavigationViewStack`. On
    /// deprecation of iOS 15 this function can be removed and uses replaced with the
    /// native `navigationDestination(isPresented: ...)`.
    /// - Parameters:
    ///   - isPresented: The state binding that controls navigation link.
    ///   - destination: The destination closure which has the unwrapped optional.
    /// - Returns: Modified view.
    func navigationDestinationWrapper<V>(isPresented: Binding<Bool>, @ViewBuilder destination: () -> V) -> some View where V: View {
        if #available(iOS 16, *) {
            self.navigationDestination(isPresented: isPresented, destination: destination)
        } else {
            ZStack {
                NavigationLink(isActive: isPresented, destination: destination, label: {
                    EmptyView()
                })
                self
            }
        }
    }

    @ViewBuilder
    /// This is a wrapper function that interfaces the same as the new SwiftUI
    /// navigationDestination modifier but also works for iOS versions below 17.
    /// This function requires to be used within a `NavigationViewStack`. On
    /// deprecation of iOS 16 this function can be removed and uses replaced with the
    /// native `navigationDestination(item: ...)`.
    /// - Parameters:
    ///   - item: The state binding optional that controls navigation link.
    ///   - destination: The destination closure which has the unwrapped optional.
    /// - Returns: Modified view.
    func navigationDestinationWrapper<D, C>(item: Binding<D?>, @ViewBuilder destination: @escaping (D) -> C) -> some View where D: Hashable, C: View {
        if #available(iOS 17, *) {
            self.navigationDestination(item: item, destination: destination)
        } else {
            ZStack {
                NavigationLink(
                    destination: unwrapDestination(item, destination),
                    isActive: Binding<Bool>(
                        get: { item.wrappedValue != nil },
                        set: { _ in
                            item.wrappedValue = nil
                        }
                    ),
                    label: { EmptyView() }
                )
                self
            }
        }
    }

    @ViewBuilder
    /// This is a wrapper function that interfaces the same as the new SwiftUI
    /// navigationDestination modifier but also works for iOS versions below 17.
    /// This function requires to be used within a `NavigationViewStack`
    /// and the `NavigationLinkWrapper`. On deprecation of iOS 15
    /// this function can be removed and uses replaced with the native
    /// `navigationDestination(for: ...)` function.
    /// - Parameters:
    ///   - for: The type of data that this destination matches.
    ///   - destination: A view builder that defines a view to display when the stack’s navigation state contains a value of type data.
    /// - Returns: Modified view.
    func navigationDestinationWrapper<D, C>(for data: D.Type, @ViewBuilder destination: @escaping (D) -> C) -> some View where D: Hashable, C: View {
        if #available(iOS 16, *) {
            self.navigationDestination(for: data, destination: destination)
        } else {
            ZStack {
                HashableNavigationLink(data: data, destination: destination)
                self
            }
        }
    }

    @ViewBuilder
    private func unwrapDestination<D, C>(_ item: Binding<D?>, @ViewBuilder _ destination: @escaping (D) -> C) -> some View where D: Hashable, C: View {
        if let unwrappedItem = item.wrappedValue {
            destination(unwrappedItem)
        } else {
            EmptyView()
        }
    }
}
