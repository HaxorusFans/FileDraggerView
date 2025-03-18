//
//  ContentView.swift
//  FileDraggerExample
//  Created by ZXL on 2025/3/18
        

import SwiftUI
import FileDraggerView

struct ContentView: View {
    @State var paths:[String] = []
    @State var extensions:[String] = ["csv", "xlsx"]
    var body: some View{
        VStack{
            List {
                ForEach(Array(paths.enumerated()), id: \.0){ index, path in
                    Text(path)
                }
            }
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
                .padding()
        }
    }
}

#Preview {
    ContentView()
}

