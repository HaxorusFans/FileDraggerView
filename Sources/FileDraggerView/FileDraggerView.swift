//
//  FileDraggerView.swift
//  VirtualBot
//  Created by ZXL on 2024/12/11.

import Foundation
import SwiftUI
import Cocoa

public class NSFileDraggerView: NSView {
    private var allowedExtensions: [String] = []
    private var goodURLS: [URL] = []
    private var acceptsFile: Bool = true
    private var acceptsDirectory: Bool = false
    var onFileDragged: (([URL]) -> Void)?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        registerForDraggedTypes([.fileURL]) // 注册拖拽类型
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerForDraggedTypes([.fileURL]) // 注册拖拽类型
    }
    
    public override func draggingEntered(_ sender: any NSDraggingInfo) -> NSDragOperation {
        if isFileTypeAllowed(sender){
            self.wantsLayer = true
            self.layer?.backgroundColor = NSColor.gray.withAlphaComponent(0.5).cgColor
            return .copy
        }
        return []
    }
    
    public override func draggingExited(_ sender: (any NSDraggingInfo)?) {
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
    }
    
    public override func draggingEnded(_ sender: any NSDraggingInfo) {
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
    }
    
    public override func performDragOperation(_ sender: any NSDraggingInfo) -> Bool {
        if goodURLS.count > 0 {
            onFileDragged?(goodURLS)
            return true
        }
        return false
    }
    
    public override func draggingUpdated(_ sender: any NSDraggingInfo) -> NSDragOperation {
        if isFileTypeAllowed(sender){
            self.wantsLayer = true
            self.layer?.backgroundColor = NSColor.gray.withAlphaComponent(0.5).cgColor
            return .copy
        }
        return []
    }
    
    private func isFileTypeAllowed(_ sender: NSDraggingInfo) -> Bool {
        if let items = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL] {
            goodURLS.removeAll()
            for item in items {
                if item.hasDirectoryPath{
                    if acceptsDirectory{
                        goodURLS.append(item)
                    }
                }
                else {
                    if acceptsFile{
                        let fileExtension = item.pathExtension.lowercased()
                        if allowedExtensions.count > 0, allowedExtensions.contains(fileExtension) {
                            goodURLS.append(item)
                        }
                        else if allowedExtensions.count <= 0{
                            goodURLS.append(item)
                        }
                    }
                }
            }
            return goodURLS.count > 0
        }
        return false
    }
    
    func setAllowedExtensions(extensions: [String]){
        self.allowedExtensions = extensions
    }
    
    func setAcceptsDirectory(flag: Bool){
        self.acceptsDirectory = flag
    }
    
    func setAcceptsFile(flag: Bool){
        self.acceptsFile = flag
    }
}

@available(macOS 10.15, *)
public struct FileDraggerView: NSViewRepresentable {
    public typealias NSViewType = NSFileDraggerView
    var fileUSage:(([URL]) -> Void)
    let allowedExtensions: [String]
    let acceptsFile: Bool
    let acceptsDirectory: Bool
    
    public init(fileUSage: @escaping ([URL]) -> Void, allowedExtensions: [String], acceptsFile: Bool = true, acceptsDirectory: Bool = false) {
        self.fileUSage = fileUSage
        self.allowedExtensions = allowedExtensions
        self.acceptsFile = acceptsFile
        self.acceptsDirectory = acceptsDirectory
    }
    
    public func makeNSView(context: Context) -> NSFileDraggerView {
        let view = NSFileDraggerView()
        // 设置文件拖拽回调，传递文件路径
        //view.onFileDragged = { fileURL in
        //    self.fileUSage(fileURL)  // 当 CSV 文件被拖拽时，传递文件路径
        //}
        view.onFileDragged = context.coordinator.handleFileDragged
        return view
    }
    
    public func updateNSView(_ nsView: NSFileDraggerView, context: Context) {
        nsView.setAllowedExtensions(extensions: self.allowedExtensions)
        nsView.setAcceptsDirectory(flag: self.acceptsDirectory)
        nsView.setAcceptsFile(flag: self.acceptsFile)
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(onFileDragged:self.fileUSage)
    }
    
    public class Coordinator {
        var onFileDragged:(([URL]) -> Void)
        
        init(
            onFileDragged: @escaping (([URL]) -> Void)
        ) {
            self.onFileDragged = onFileDragged
        }
        
        func handleFileDragged(URLS: [URL]){
            self.onFileDragged(URLS)
        }
    }
}
