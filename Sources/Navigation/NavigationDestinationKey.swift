//
//  NavigationDestinationKey.swift
//  
//
//  Created by Ryan Cole on 17/05/2024.
//

import SwiftUI

struct NavigationDestinationKey: EnvironmentKey {
    static var defaultValue: Binding<(any Hashable)?> = .constant(nil)
}

extension EnvironmentValues {
    var navigationHashValue: Binding<(any Hashable)?> {
        get { self[NavigationDestinationKey.self] }
        set { self[NavigationDestinationKey.self] = newValue }
    }
}
