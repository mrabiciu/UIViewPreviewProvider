//
//  MVVM Example.swift
//  Example App
//
//  Created by Max on 11/5/19.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

// We can expand this idea even further if we're working in an environment using MVVM (Model-View-ViewModel)

/// A `ViewModel` version of `Preview`
public struct ViewModelPreview<ViewModelType: ViewModel> {

    public typealias Size = Preview.Size
    
    let viewModel: ViewModelType
    let size: Size
    let displayName: String?
    
    public init(
        _ viewModel: ViewModelType,
        size: Size = .default,
        displayName: String? = nil
    ) {
        self.viewModel = viewModel
        self.size = size
        self.displayName = displayName
    }
}

#if canImport(SwiftUI) && DEBUG

import SwiftUI

/// A new kind of `PreviewProvider` thats powered by `ViewModels`
public protocol ViewModelPreviewProvider: UIViewPreviewProvider {

    associatedtype ViewModelType: ViewModel
    static var viewModels: [ViewModelPreview<ViewModelType>] { get }
}


public extension ViewModelPreviewProvider {
    
    /// Default implementation of `uiPreviews`
    static var uiPreviews: [Preview] {
        return viewModels.map { viewModel in
            return Preview(
                ViewModelType.ViewType(viewModel: viewModel.viewModel),
                size: viewModel.size,
                displayName: viewModel.displayName
            )
        }
    }
}

#endif

/// A `ViewModel` for `ProfileView`
struct ProfileViewModel: ViewModel {

    typealias ViewType = ProfileView
    
    let text: String?
    let image: UIImage?
}

/// Extend `ProfileView` to be `ViewModelConfigurable`
extension ProfileView: ViewModelConfigurable {
    
    convenience init(viewModel: ProfileViewModel) {
        self.init(frame: .zero)
        configure(with: viewModel)
    }
    
    func configure(with viewModel: ProfileViewModel) {
        text = viewModel.text
        image = viewModel.image
    }
}

// Finally we can put all of this together to create a ViewModel based preview provider

#if canImport(SwiftUI) && DEBUG

import SwiftUI

/// A `ViewModel` based preview provider for `ProfileView`
@available(iOS 13, *)
struct ProfileViewModel_Preview: ViewModelPreviewProvider, PreviewProvider {
    
    static let viewModels: [ViewModelPreview<ProfileViewModel>] = [
        ViewModelPreview(
            ProfileViewModel(
                text: "Tim C.",
                image: UIImage(named: "tim")
            ),
            displayName: "Tim"
        ),
        ViewModelPreview(
            ProfileViewModel(
                text: "Mark Z.",
                image: UIImage(named: "mark")
            ),
            displayName: "Mark"
        ),
        ViewModelPreview(
            ProfileViewModel(
                text: "Jeff B.",
                image: UIImage(named: "jeff")
            ),
            displayName: "Jeff"
        ),
        ViewModelPreview(
            ProfileViewModel(
                text: "Bill G.",
                image: UIImage(named: "bill")
            ),
            displayName: "Bill"
        ),
    ]
}

#endif
