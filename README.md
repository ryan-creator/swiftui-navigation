# SwiftUI Native Navigation
This replicates the SwiftUI native navigation patterns (NavigationStack, navigationDestination) so that it you can use the modern SwiftUI navigation patterns for iOS 15 and below.

## Table of Contents

-   [Installation](#installation)
-   [Usage](#usage)
-   [License](#license)

## Installation <a name="installation"></a>

### Xcode

To integrate SwiftUI Navigation into your Xcode project using Swift Package Manager, follow these steps:

1. Open your Xcode project.
2. Navigate to "File" -> "Add Package Dependency..."
3. Paste the package URL `https://github.com/ryan-creator/swiftui-navigation.git` and click "Next."
4. Choose the version rule according to your preference and click "Next."
5. Click "Finish."

Now you can import the package in your Swift files where you want to perform snapshot testing. 

### Swift Package Manager (SPM)

If you want to use the package in any other project that uses SPM, add the package as a dependency in Package.swift:

```swift
dependencies: [
    .package(
        name: "Navigation",
        url: "https://github.com/ryan-creator/swiftui-navigation.git",
        from: "1."
    ),
]
```

Next, add the package to your target dependencies list:

```swift
targets: [
  .target(
    name: "MyApp",
    dependencies: [.product(name: "Navigation", package: "Navigation")]
  ),
  ...
]
```

## Usage <a name="usage"></a>

Simply import the 'Navigation' package to begin using it in your code.

If the you are unable to import the Navigation package you may need to go into "Project Settings" -> "Your Target" -> "General" -> "Frameworks, Libraries, and Embedded Content" and add the package import there.

```swift
import SwiftUI
import Navigation

struct ContentView: View {
    
    @State private var presentChildView = false
    
    var body: some View {
        NavigationViewStack {
            VStack {
                Text("First View")
                Button("Next View", action: {
                    presentChildView = true
                })
            }
            .navigationDestinationWrapper(isPresented: $presentChildView) {
                Text("Child View")
            }
        }
    }
}
```

### `navigationDestinationWrapper(isPresented:destination:)`

This function acts as a wrapper around the `navigationDestination` modifier in SwiftUI, providing compatibility for iOS versions below 16. It's designed to be used within a `NavigationViewStack`.

**Parameters:**
- `isPresented`: A `Binding` that controls the navigation link's presentation.
- `destination`: A closure returning the view to navigate to.

**Example:**
```swift
struct ContentView: View {
    @State private var isDestinationVisible = false
    
    var body: some View {
        NavigationViewStack {
            Button("Navigate") {
                isDestinationVisible.toggle()
            }
            .navigationDestinationWrapper(isPresented: $isDestinationVisible) {
                Text("Destination View")
            }
        }
    }
}
```

### `navigationDestinationWrapper(for:destination:)`

This function provides compatibility for iOS versions below 17. It's intended to be used within a NavigationViewStack in conjunction with NavigationLinkWrapper.

**Parameters:**
- `for`: The type of data that the destination matches.
- `destination`: A closure returning the view to navigate to, based on the specified data type.

**Example:**
```swift
struct ContentView: View {
    var body: some View {
        NavigationViewStack {
            List {
                Text("Item 1")
                    .onTapGesture {
                        NavigationLinkWrapper(destination: {
                            Text("Detail for Item 1")
                        })
                    }
            }
            .navigationDestinationWrapper(for: String.self) { data in
                Text("Detail for \(data)")
            }
        }
    }
}
```

### `navigationDestinationWrapper(item:destination:)`

Similar to the previous function, this wrapper offers compatibility for iOS versions below 17. It requires being used within a NavigationViewStack as well.

**Parameters:**
- `item`: A Binding optional that controls the navigation link.
- `destination`: A closure taking the unwrapped optional and returning the view to navigate to.

**Example:**
```swift
struct ContentView: View {
    @State private var presentString: String?
    
    var body: some View {
        NavigationViewStack {
            Button("Next View", action: {
                presentString = "Child View"
            })
            .navigationDestinationWrapper(item: $presentString, destination: { string in
                Text(string)
            })
        }
    }
}
```

## License <a name="license"></a>

This library is released under the MIT license. See [LICENSE](https://github.com/pointfreeco/swift-snapshot-testing/blob/main/LICENSE) for details.
