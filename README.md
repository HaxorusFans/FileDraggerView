# **FileDraggerView**

A SwiftUI component for accepting drag-and-drop content. Users can customize what is supported to receive.

## Features

Drag some files into FileDraggerView to get their URLs.

## Compatibility

This component requires macOS 10.15 or later.

## Installation

### Using Swift Package Manager：

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: https://github.com/HaxorusFans/FileDraggerView.git, from: "1.1.0")
]
```

### Manual Installation

1. Download the source files from this repository.
2. Drag and drop them into your Xcode project.

## Usage

```swift
@State var paths:[String] = []
@State var extensions:[String] = ["csv", "xlsx"]
```

```swiftUI
Text("Drag \(extensions.joined(separator: "/")) over here")
    .frame(minWidth: 500, minHeight: 200)
    .background(
        RoundedRectangle(cornerRadius: 10)
            .strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 2, dash: [10, 2]))
    )
    .background(
        FileDraggerView(fileUSage: { URLS in
            paths.removeAll()
            for url in URLS {
                paths.append(url.path)
                print(url.path)
            }
        }, allowedExtensions: extensions, acceptsDirectory: false)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    )
    .animation(nil)
    .padding()Text("Hello world!")
```
