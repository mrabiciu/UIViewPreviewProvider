//
//  UIViewPreviewProvider.swift
//  PreviewsCompatibility
//
//  Created by Max on 11/5/19.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI

// MARK: - UIViewPreviewProvider

/// Allows rendering UIViews in the Xcode preview canvas pane `(⌥ + ⌘ + return)` meant for `SwiftUI`
///
/// Create a type conforming to this protocol somewhere in your file, and provide it with views to display.
///
/// The `SwiftUI` preview canvas pane `(⌥ + ⌘ + return)` should then start rendering the views you provided and should update whenever you edit your code.
///
///
/// *Note:* You will also need to explicitly conform to `PreviewProvider`. This protocol doesn't directly inherit from `PreviewProvider` but it does provide all the methods needed for auto-conformance
///
///
/// **Example**
///
///```
///#if canImport(SwiftUI) && DEBUG
///
///import SwiftUI
///
///@available(iOS 13.0, *)
///struct MyView_Preview: PreviewProvider, UIViewPreviewProvider {
///
///   static let uiPreviews: [Preview] = {
///       let view1 = MyView()
///       view1.someProperty = "foo"
///
///       let view2 = MyView()
///       view2.someProperty = "bar"
///
///       return [view1, view2].map { Preview($0) }
///   }()
///}
///```
public protocol UIViewPreviewProvider {
    
    /// Array of `Preview` to be displayed in the Xcode canvas  pane `(⌥ + ⌘ + return)`
    static var uiPreviews: [Preview] { get }
    
    /// `ColorScheme` to be used in the Xcode canvas pane
    @available(iOS 13.0, *)
    static var colorSchemes: [ColorScheme] { get }
}

// MARK: UIViewPreviewProvider + PreviewProvider

@available(iOS 13, *)
extension UIViewPreviewProvider {
    
    /// Default color schemes
    public static var colorSchemes: [ColorScheme] {
        [.light, .dark]
    }
    
    /// Calculates the size we apply to the view
    private static func size(for preview: Preview) -> CGSize {
        switch preview.size {
            
        case .intrinsic:
            return preview.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            
        case .fixedWidth(let width):
            var compressedSize = UIView.layoutFittingCompressedSize
            compressedSize.width = width
            let height = preview.view.systemLayoutSizeFitting(compressedSize).height
            return CGSize(width: width, height: height)
            
        case .fixed(let fixedSize):
            return fixedSize
        }
    }
    
    /// Converts a Preview to a SwiftUI View
    static func swiftUIView(from preview: Preview, scheme colorScheme: ColorScheme) -> some View {
        
        let size = self.size(for: preview)

        preview.view.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        preview.view.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        
        return preview
            .previewLayout(
                .fixed(
                    width: size.width,
                    height: size.height
                )
            )
            .previewDisplayName("\(preview.displayName ?? "") [\(colorScheme)]")
            .environment(\.colorScheme, colorScheme)
    }
    
    /// Allows us to automatically conform to `PreviewProvider`
    public static var previews: some View {
        
        let identifiablePreviews = uiPreviews.map {
            IdentifiableBox($0)
        }
        
        let identifieableSchemes = colorSchemes.map {
            IdentifiableBox($0)
        }
        
        return ForEach(identifiablePreviews) { preview in
            ForEach(identifieableSchemes) { scheme in
                swiftUIView(from: preview.item, scheme: scheme.item)
            }
        }
    }
}

// MARK: Preview

/// Wraps a UIView to make it `UIViewRepresentable` and provides additional information for displaying an Xcode preview
public struct Preview {
    
    // MARK: - Size

    /// How views contained in a `Preview` are sized
    public enum Size {

        /// Applies a fixed width with the given amount. Height is intrinsic
        case fixedWidth(CGFloat)
        
        /// Fixed height and width
        case fixed(CGSize)
        
        /// Uses the size returned by .`systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)`
        case intrinsic
        
        // Most common iPhone width
        public static let `default`: Size = .fixedWidth(375)
    }
    
    fileprivate let view: UIView
    fileprivate let size: Size
    fileprivate let displayName: String?
    
    
    /// Initializes a `Preview`
    /// - Parameters:
    ///   - view: `UIView` being previewed
    ///   - size: How the view should be sized. Defaults to `.fixedWidth(375)`
    ///   - displayName: Optional display name shown below the preview. Defaults to `nil`
    public init(
        _ view: UIView,
        size: Size = .default,
        displayName: String? = nil
    ) {
        self.view = view
        self.size = size
        self.displayName = displayName
    }
    
}

// MARK: Preview + UIViewRepresentable

@available(iOS 13, *)
extension Preview: UIViewRepresentable {

    public func makeUIView(context: Context) -> UIView {
        return view
    }
    
    public func updateUIView(_ view: UIView, context: Context) {}
}
    

// MARK: IdentifiableBox

/// Wraps an existing type and makes it `Identifiable`
///
/// We need this so we can do a `ForEach` call with an array of `Preview`
@available(iOS 13.0, *)
private class IdentifiableBox<T>: Identifiable {
    public let item: T
    public init(_ item: T) {
        self.item = item
    }
}

#endif
