//
//  Example.swift
//  Example App
//
//  Created by Max on 11/5/19.
//  Copyright © 2019 Max. All rights reserved.
//

// MARK: - Description
/// This file shows an example of how to use UIViewPreviewProvider with an existing UIView.
//  / We'll be generating previews of `ProfileView`

import UIKit

// MARK: - Preview

// Its important that you wrap your preview logic in this `#if`
#if canImport(SwiftUI) && DEBUG

import SwiftUI

// Create a struct conforming to `UIViewPreviewProvider` and `PreviewProvider`
@available(iOS 13.0, *)
struct ProfileView_Preview: PreviewProvider, UIViewPreviewProvider {
    
    // Provide some views to preview
    static let uiPreviews: [Preview] = {
        
        let tim = ProfileView()
        tim.text = "Tim C."
        tim.image = UIImage(named: "tim")
        let timPreview = Preview(tim, displayName: "Tim")
        
        let mark = ProfileView()
        mark.text = "Mark Z."
        mark.image = UIImage(named: "mark")
        let markPreview = Preview(mark, displayName: "Mark")
        
        let jeff = ProfileView()
        jeff.text = "Jeff B."
        jeff.image = UIImage(named: "jeff")
        let jeffPreview = Preview(jeff, displayName: "Jeff")
        
        let bill = ProfileView()
        bill.text = "Bill G."
        bill.image = UIImage(named: "bill")
        let billPreview = Preview(bill, displayName: "Bill")
        
        return [
            timPreview,
            markPreview,
            jeffPreview,
            billPreview,
        ]
    }()
}
#endif

// MARK: - ProfileView

/// A simple view that displays a user's profile
final class ProfileView: UIView {
    
    // MARK: Internal Properties
    
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    var image: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue }
    }
    
    // MARK: Private Properties
        
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.font
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Constants.imageBackground
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = Constants.imageBorder
        imageView.layer.cornerRadius = Constants.imageSize / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: Constants
    
    private struct Constants {
        
        static let imageSize: CGFloat = 48
        static let padding: CGFloat = 16
        
        static let font: UIFont = .systemFont(ofSize: 18)
        
        static let imageBackground: UIColor = UIColor(white: 0.9, alpha: 1)
        
        static let imageBorder: CGColor = UIColor(white: 0.8, alpha: 1).cgColor
    }
    
    // MARK: Initializers
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
                
        backgroundColor = .white
            
        addSubviews()
        installConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func addSubviews() {
        addSubview(imageView)
        addSubview(label)
    }
    
    private func installConstraints() {
        let constraints: [NSLayoutConstraint] = [
            // image view
            imageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.padding
            ),
            imageView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: Constants.padding
            ),
            imageView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -Constants.padding
            ),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            
            // label
            
            label.leadingAnchor.constraint(
                equalTo: imageView.trailingAnchor,
                constant: Constants.padding
            ),
            label.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Constants.padding
            ),
            label.topAnchor.constraint(
                equalTo: topAnchor,
                constant: Constants.padding
            ),
            label.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -Constants.padding
            )
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
