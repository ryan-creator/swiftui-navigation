//
//  NavigationViewStack.swift
//
//
//  Created by Ryan Cole on 6/03/24.
//

import SwiftUI

/// This struct controls the navigation type based on the iOS
/// version. The `NavigationViewStack` is required to use the
/// custom `navigationDestinationWrapper`. Once all
/// `navigationDestinationWrapper` have been deprecated
/// this struct can be removed.
public struct NavigationViewStack<V>: View where V: View {

    @State private var destinationValue: (any Hashable)?

    private let content: () -> V

    public init(@ViewBuilder content: @escaping () -> V) {
        self.content = content
    }

    public var body: some View {
        if #available(iOS 16, *) {
            NavigationStack { content() }
        } else {
            NavigationView {
                content()
                    .environment(\.navigationHashValue, $destinationValue)
            }
        }
    }
}
