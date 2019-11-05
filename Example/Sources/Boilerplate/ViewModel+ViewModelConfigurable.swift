//
//  ViewModel+ViewModelConfigurable.swift
//  Example App
//
//  Created by Max on 11/5/19.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

public protocol ViewModel {
    associatedtype ViewType: ViewModelConfigurable where ViewType.ViewModelType == Self
}

public protocol ViewModelConfigurable where Self: UIView {
    associatedtype ViewModelType: ViewModel where ViewModelType.ViewType == Self
    
    init(viewModel: ViewModelType)
    func configure(with viewModel: ViewModelType)
}
