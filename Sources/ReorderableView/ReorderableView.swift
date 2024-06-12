//
//  BlueFalconHD 2024
//  MIT LICENSE
//

import SwiftUI
import AppKit
import UniformTypeIdentifiers

/// A protocol defining data requirements for reorderable items.
public protocol ReorderableData: Identifiable, Equatable {
    /// Unique identifier for the item.
    var id: UUID { get set }
}

/// Directions in which the reorderable view can layout its contents.
public enum ReorderableDirection {
    case HStack
    case VStack
    case LazyHStack
    case LazyVStack
    case ZStack
}

/// A view that allows for the reordering of its contents.
///
/// Generics:
///  - `Item`: Must conform to `ReorderableData`.
///  - `Content`: The type of view to be displayed for each item.
struct ReorderableView<Item, Content>: View where Item: ReorderableData, Content: View {
    /// The data array containing reorderable items.
    @Binding var data: [Item]
    /// Boolean state to enable or disable drag functionality.
    @Binding var dragEnabled: Bool
    /// The content closure that provides a view for each item.
    let content: (Item) -> Content
    
    /// The layout direction of the view's contents.
    var direction: ReorderableDirection = .VStack
    
    /// State to track the item currently being dragged.
    @State private var draggedItem: Item?
    
    var body: some View {
        Group {
            switch direction {
            case .HStack:
                HStack { contentViews }
            case .VStack:
                VStack { contentViews }
            case .LazyHStack:
                LazyHStack { contentViews }
            case .LazyVStack:
                LazyVStack { contentViews }
            case .ZStack:
                ZStack { contentViews }
            }
        }
    }
    
    /// Provides the view for each item, with drag-and-drop capabilities.
    var contentViews: some View {
        ForEach(data) { item in
            content(item)
                .onDrag({
                    self.draggedItem = item
                    return NSItemProvider(object: String(describing: item.id) as NSString)
                }, preview: { Rectangle().opacity(0) })
                .onDrop(of: [UTType.text], delegate: DragRelocateDelegate(item: item, data: $data, current: $draggedItem))
        }
    }
}

/// A delegate that handles the drag-and-drop functionality for reorderable items.
struct DragRelocateDelegate<Item>: DropDelegate where Item: ReorderableData {
    /// The item being dragged.
    let item: Item
    /// Binding to the array of data items.
    @Binding var data: [Item]
    /// The item currently being dragged.
    @Binding var current: Item?

    /// Handles the drop event by reordering items.
    func dropEntered(info: DropInfo) {
        if let currentIndex = data.firstIndex(of: current!), let targetIndex = data.firstIndex(of: item) {
            if currentIndex != targetIndex {
                data.move(fromOffsets: IndexSet(integer: currentIndex),
                          toOffset: targetIndex > currentIndex ? targetIndex + 1 : targetIndex)
            }
        }
    }

    /// Updates the drop proposal during a drag operation.
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    /// Finalizes the drop operation by clearing the currently dragged item.
    func performDrop(info: DropInfo) -> Bool {
        current = nil
        return true
    }
}

