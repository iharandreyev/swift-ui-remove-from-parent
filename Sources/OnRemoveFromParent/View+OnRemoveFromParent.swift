//
//  View+OnRemoveFromParent.swift
//  OnRemoveFromParent
//
//  Created by Andreyeu, Ihar on 3/8/25.
//

import IssueReporting
import SwiftUI

private struct DeinitReporterKey: EnvironmentKey {
  static let defaultValue: DeinitReporter? = nil
}

private extension EnvironmentValues {
  var deinitReporter: DeinitReporter? {
    get { self[DeinitReporterKey.self] }
    set { self[DeinitReporterKey.self] = newValue }
  }
}

private struct OnRemoveFromParentViewModifier: ViewModifier {
  @Environment(\.self)
  private var environment

  let onRemoveFromParent: @MainActor () -> Void
  
  @ViewBuilder
  func body(content: Content) -> some View {
    content.environment(
      \.deinitReporter,
       DeinitReportersPool.shared.spawn(
        forKey: environment.description.hashValue,
        onDeinit: onRemoveFromParent
       )
    )
  }
}

extension View {
  /// Attaches a callback that will be invoked when the view is removed from view hierarchy.
  ///
  /// **LIMITATIONS:**
  ///
  /// - There can be only a single callback for a given view.
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
  ///         /* your work */
  ///      }
  ///      .identify(as: ViewID.someView)
  ///  }
  ///}
  ///```
  ///
  ///
  /// - Parameters:
  ///   - onRemoveFromParent: The closure to be invoked when the view is removed from view hierarchy.
  @inline(__always)
  public func onRemoveFromParent(
    perform onRemoveFromParent: @MainActor @escaping () -> Void
  ) -> some View {
    modifier(
      OnRemoveFromParentViewModifier(
        onRemoveFromParent: onRemoveFromParent
      )
    )
  }
}
