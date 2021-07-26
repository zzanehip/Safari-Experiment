
<p align="center">
<a href="https://github.com/CodeSlicing/pure-swift-ui-tools">
<img src="./Assets/Images/pure-swift-ui-tools-logo.png" width="400"/>
</a>
</p>

[PureSwiftUITools][pure-swift-ui-tools] is a companion package to [PureSwiftUI][pure-swift-ui] which is designed to provide useful implementation of various concepts written for [SwiftUI][swift-ui].

- [Motivation](#motivation)
- [Documentation](#documentation)
  - [Containers](#containers)
    - [GridView](#gridview)
  - [Utilities](#utilities)
    - [GradientMap](#gradientmap)
  - [Extensions](#extensions)
    - [Inner Shadows](#inner-shadows)
- [Caveats](#caveats)
- [Installation](#installation)
- [Versioning](#versioning)
- [Version History](#version-history)
- [Licensing](#licensing)
- [Contact](#contact)

## Motivation

Since `SwiftUI` is still relatively new, there are many use-cases that are not addressed either directly by Apple or by the community in general. [PureSwiftUITools][pure-swift-ui-tools] is a way of formulating various ideas into tools which can be used directly in projects, or used as a basis for learning, extending for bespoke purposes, or as a foundation for building a more robust approach. I see this package as a educational platform as much as anything else. As various utilities are introduced they will be accompanied by appropriate demos and gists that demonstrate usage.

## Documentation

### Containers

#### GridView

[GridView][containers-grid-view] facilitates the easy creation and manipulation of grids with a specified number of columns of rows.

### Utilities

#### GradientMap

[GradientMap][gradient-map] allows the extraction of colors along a gradient for use where context sensitive colors are a requirement of the UX. 

### Extensions

#### Inner Shadows

These extensions bring inner shadows to all major component types in `SwiftUI`. You can read about them [here][inner-shadows].

## Caveats

Although [PureSwiftUITools][pure-swift-ui-tools] exports `SwiftUI` - meaning you don't need to import `SwiftUI` at the top of your views for compilation - unfortunately at the time of writing previews do not work if you are not explicitly importing `SwiftUI`. Hopefully this will be addressed in a future release.

## Installation

The `pure-swift-ui-tools` package can be found at:

<https://github.com/CodeSlicing/pure-swift-ui-tools.git>

Instructions for installing swift packages can be found [here][swift-package-installation].

## Versioning

This project adheres to a [semantic versioning](https://semver.org) paradigm. I'm sure a lot will change after WW20, so that's probably when version 2.0.0+ will appear.

## Version History

- [1.0.0][tag-1.0.0] Commit initial code with GridView
- [1.1.0][tag-1.1.0] Add GradientMap and RGBA with appropriate supporting extensions
- [1.2.0][tag-1.2.0] Add inner shadows
- [1.3.0][tag-1.3.0] Fix segmentation fault in Xcode 11.4
- [1.3.1][tag-1.3.1] Updating dependency on PureSwiftUI to 1.20.0
- [2.0.0][tag-2.0.0] Updating dependency on PureSwiftUI to 2.0.0. Breaking changes in PureSwiftUI 2.0.0 (although only on the type system) so be careful if using this library to pull in PureSwiftUI. 

## Licensing

This project is licensed under the MIT License - see [here][mit-licence] for details.

## Contact

You can contact me on Twitter [@CodeSlice][codeslice-twitter]. Happy to hear suggestions for improving the package, or feature suggestions. I've probably made a few boo boos along the way, so I'm open to course correction. I won't be open-sourcing the project for the moment since I simply don't have time to administer PRs at this point, though I do intend to do so in the future if there's enough interest.

<!---
 external links:
--->

[pure-swift-ui]: https://github.com/CodeSlicing/pure-swift-ui
[pure-swift-ui-tools]: https://github.com/CodeSlicing/pure-swift-ui-tools
[codeslice-twitter]: https://twitter.com/CodeSlice
[swift-ui]: https://developer.apple.com/xcode/swiftui/
[swift-functions]: https://docs.swift.org/swift-book/LanguageGuide/Functions.html
[swift-package-installation]: https://medium.com/better-programming/add-swift-package-dependency-to-an-ios-project-with-xcode-11-remote-local-public-private-3a7577fac6b2

<!---
gists:
--->

[gist-offset-to-position-demo]: https://gist.github.com/CodeSlicing/2c5376552fa8c27456925370403caa46
[gist-relative-offset-demo]: https://gist.github.com/CodeSlicing/6873695fd0113c27d5cdd8591eca9d1d

<!---
version links:
--->

[tag-1.0.0]: https://github.com/CodeSlicing/pure-swift-ui-rools/tree/1.0.0
[tag-1.1.0]: https://github.com/CodeSlicing/pure-swift-ui-rools/tree/1.1.0
[tag-1.2.0]: https://github.com/CodeSlicing/pure-swift-ui-rools/tree/1.2.0
[tag-1.3.0]: https://github.com/CodeSlicing/pure-swift-ui-rools/tree/1.3.0
[tag-1.3.1]: https://github.com/CodeSlicing/pure-swift-ui-rools/tree/1.3.1
[tag-2.0.0]: https://github.com/CodeSlicing/pure-swift-ui-rools/tree/2.0.0


<!---
 local docs:
--->

[mit-licence]: ./Assets/Docs/LICENCE.md
[containers-grid-view]: ./Assets/Docs/Components/Containers/GridView/grid-view.md
[gradient-map]: ./Assets/Docs/Components/Model/Color/gradient-map.md
[inner-shadows]: ./Assets/Docs/Components/Extensions/InnerShadows/inner-shadows.md

