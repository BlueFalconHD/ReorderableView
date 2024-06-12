# ReorderableView

The `ReorderableView` is a SwiftUI component that enables interactive item reordering within various stack layouts. It supports drag-and-drop functionality and can be adapted to various SwiftUI views to enhance user interactivity.

## Features

- **Customizable Layouts**: Choose between horizontal, vertical, and z-stack layouts.
- **Drag-and-Drop**: Intuitive reordering of elements via drag-and-drop.
- **Generics Support**: Use with any custom data type that conforms to `ReorderableData`.
- **SwiftUI Integration**: Seamlessly integrates with existing SwiftUI views and practices.

## Requirements

- iOS 13.0+ / macOS 12+
- Swift 5.0+

## Installation

This project can be added via the Swift Package Manager, In the Menu Bar, click File > Add package dependencies, then paste the following URL into the search bar: `https://github.com/bluefalconhd/ReorderableView` 


## Usage

Here is a simple example of how to use `ReorderableView` in a SwiftUI application:

```swift
import SwiftUI

// Define your data model conforming to `ReorderableData`
struct Item: ReorderableData {
    var id: UUID
    var text: String
}

// Implement the ReorderableView in your SwiftUI view
struct ContentView: View {
    @State private var items: [Item] = [
        Item(id: UUID(), text: "First"),
        Item(id: UUID(), text: "Second"),
        Item(id: UUID(), text: "Third")
    ]

    var body: some View {
        VStack {
            ReorderableView(data: $items, dragEnabled: $true, content: { item in
                Text("Item: \(item.text)")
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }, direction: .VStack)
            .padding(.vertical)
        }
    }
}
```

Replace the `Item` struct and content view as necessary to fit your specific needs.

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Credits

This project was inspired by [swiftui-reorderable-foreach](https://github.com/globulus/swiftui-reorderable-foreach)
