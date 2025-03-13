//
//  View+OnRemoveFromParent.swift
//  OnRemoveFromParent
//
//  Created by Andreyeu, Ihar on 3/8/25.
//

import SwiftUI

extension View {
  /// Attaches a callback that will be invoked when the view is removed from view hierarchy.
  ///
  /// **LIMITATIONS:**
  ///
  /// - The view identity must be bound to a proxy value with `identify(as:)` modifier.
  /// - There can be only a single callback for a given view. Due to the way SwiftUI modifiers work, only the outer modifier will produce effect.
  ///
  ///```swift
  ///enum ViewID: Hashable, Sendable {
  ///  case someView
  ///}
  ///
  ///struct Container: View {
  ///  var body: some View {
  ///    SomeView()
  ///      .onRemoveFromParent {
  ///        ///
  ///        // WILL NOT BE INVOKED!
  ///      }
  ///      .onRemoveFromParent {
  ///        // WILL BE INVOKED
  ///        /* your work */
  ///      }
  ///      .identify(as: ViewID.someView)
  ///  }
  ///}
  ///
  ///struct SomeView: View {
  ///  var body: some View {
  ///    AnotherView()
  ///      .onRemoveFromParent {
  ///        // WILL NOT BE INVOKED!
  ///      }
  ///  }
  ///}
  ///```
  ///
  /// - Parameters:
  ///   - onRemoveFromParent: The closure to be invoked when the view is removed from view hierarchy.
  @inline(__always)
  @ViewBuilder
  public func onRemoveFromParent(
    fileID: StaticString = #fileID,
    line: UInt = #line,
    perform onRemoveFromParent: @MainActor @escaping () -> Void
  ) -> some View {
    if #available(iOS 17, macCatalyst 17, macOS 14, tvOS 17, visionOS 2, watchOS 11, *) {
      modifier(
        OnRemoveFromParentModernViewModifier(
          onRemoveFromParent: onRemoveFromParent
        )
      )
    } else {
      modifier(
        OnRemoveFromParentLagacyViewModifier(
          fileID: fileID,
          line: line,
          onRemoveFromParent: onRemoveFromParent
        )
      )
    }
  }
}
