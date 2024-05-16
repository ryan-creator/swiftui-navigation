//
//  NavigationLinkWrapper.swift
//
//
//  Created by Ryan Cole on 17/05/2024.
//

import SwiftUI

public struct NavigationLinkWrapper<P, Label>: View where P: Hashable, Label: View {

    @Environment(\.navigationHashValue) private var navigationHashValue

    private let value: P?
    private let label: () -> Label

    public init(value: P?, @ViewBuilder label: @escaping () -> Label) {
        self.value = value
        self.label = label
    }

    public var body: some View {
        if #available(iOS 16, *) {
            NavigationLink(value: value, label: label)
        } else {
            Button {
                navigationHashValue.wrappedValue = value
            } label: {
                label()
            }
        }
    }
}
