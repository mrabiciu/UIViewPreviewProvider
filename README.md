# UIViewPreviewProvider
This is a helper class for displaying `UIView`s inside the Xcode preview canvas meant to display `SwiftUI`.  
It allows you to quickly iterate on your `UIView`s without having to rebuild your entire app.  
This is especially useful if your project needs to supports `iOS < 13` and you can't start using `SwiftUI` just yet.

## Adding `UIViewPreviewProvider` to your project. 
Just copy `UIViewPreviewProvider.swift` into your project. 
I don't think this is large enough to warrant adding a whole library to your project.

## Rendering `UIView` previews in your project

In the file where your view is defined:
```swift
// This if check is important if you're working with a project that supports iOS < 13
// If you're working with an iOS 13+ project then you can omit the canImport(SwiftUI) check
#if canImport(SwiftUI) && DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct MyView_Preview: PreviewProvider, UIViewPreviewProvider {
    
    // Provide previews of your UIView
    static let uiPreviews: [Preview] = {

        // Create your views and populate them with some dummy data
        
        let view1 = MyView()
        view1.someProperty = "foo"
        let view1Preview = Preview(view1, displayName: "View 1")

        let view2 = MyView()
        view2.someProperty = "bar"
        let view2Preview = Preview(view2, displayName: "View 2")

        return [view1Preview, view2Preview]
    }()
}

#endif
```

Open up the preview Xcode canvas by pressing `(⌥ + ⌘ + return)` and your previews should show up.

You may need to hit the `Resume` button for them to show up

It should look something like this:
![screenshot](https://i.imgur.com/lOK0tiB.jpg)

## Examples
See [`Example.swift`](https://github.com/mrabiciu/UIViewPreviewProvider/blob/master/Example/Sources/Examples/Example.swift) for more info.

If you're using MVVM see [`MVVM Example.swift`](https://github.com/mrabiciu/UIViewPreviewProvider/blob/master/Example/Sources/Examples/MVVM%20Example.swift) to see how you can generate previews directly from your ViewModels.
