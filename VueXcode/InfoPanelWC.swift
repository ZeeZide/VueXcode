//
//  InfoPanelWC.swift
//  VueXcode
//
//  Created by Helge Hess on 07/06/17.
//  Copyright © 2017 ZeeZide GmbH. All rights reserved.
//

import Cocoa

class InfoPanelWC: ZzWindowController {
  
  convenience init() {
    self.init(windowNibName: "FAKE") // lame, can't call just init()
    mainComponentName        = "InfoPanelVC"
    title                    = "Vue"
    defaultWindowContentSize = NSMakeSize(220, 240)
    defaultMinimumSize       = defaultWindowContentSize
  }
  
  override func windowDidLoad() {
    guard let window = window else { return }
    
    window.titleVisibility = .hidden // just hides the title string
    window.titlebarAppearsTransparent = true
    
    window.isMovableByWindowBackground = true
  }

  override open var defaultWindowStyleMask : NSWindowStyleMask {
    var mask = super.defaultWindowStyleMask
    mask.insert(.fullSizeContentView)
    mask.remove([.unifiedTitleAndToolbar,  .miniaturizable , .resizable])
    return mask
  }
  
  override open func createContentViewController() -> NSViewController? {
    return InfoPanelVC()
  }
}
