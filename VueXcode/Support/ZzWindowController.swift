//
//  ZzWindowController.swift
//  VueXcode
//
//  Created by Helge Hess on 07/06/17.
//  Copyright © 2017-2019 ZeeZide GmbH. All rights reserved.
//


import Cocoa

open class ZzWindowController: NSWindowController,
                               NSWindowDelegate, NSToolbarDelegate
{
  // Various styles:
  // - https://github.com/robin/TitlebarAndToolbar

  open var mainComponentName         : String? = nil
  
  open var defaultWindowContentSize  = NSMakeSize(100, 620)
  open var defaultMinimumSize        = NSMakeSize(720, 340)
  
  open var hasUnifiedTitleAndToolbar = false
  open var title                     : String {
    set { _title = newValue }
    get {
      if _title == nil { _title = "\(type(of: self))" }
      return _title!
    }
  }
  var _title : String? = nil // stored value for 'title' property
  
  open var zzFrameAutosaveName       : String? = nil
  open var zzToolbarID               : String? = nil
  
  open var zzWindowClass             = NSWindow.self
  
  var tb : NSToolbar? = nil
  
  public var zz : ZzViewFactory {
    return ZzViewFactoryAppKit.defaultViewFactory
  }
  
  public convenience init() {
    // We may be able to make this a designated init and call
    // super.init(window:). But then the loading stuff doesn't get run?
    self.init(windowNibName: "FAKE") // this is not a designated init!
  }
  
  
  // MARK: - Window Setup
  
  open var defaultWindowContentRect : NSRect {
    let s = defaultWindowContentSize
    return NSMakeRect(0, 200, s.width, s.height)
  }
  
  open var defaultWindowStyleMask : NSWindow.StyleMask {
    var mask : NSWindow.StyleMask =
                 [ .titled, .closable, .miniaturizable, .resizable ]
    
    if hasUnifiedTitleAndToolbar {
      mask.insert(.unifiedTitleAndToolbar)
    }
    
    return mask
  }
  
  open override func loadWindow() {
    let win = self.zzWindowClass.init(contentRect: defaultWindowContentRect,
                                      styleMask:   defaultWindowStyleMask,
                                      backing:     .buffered,
                                      defer:       true)
    win.title    = title
    win.minSize  = defaultMinimumSize
    win.delegate = self
    window       = win
    
    if win.styleMask.contains(.unifiedTitleAndToolbar) {
      win.titleVisibility = .hidden
    }
    
    
    // CREATE OUR ROOT VIEW CONTROLLER
    
    if let vc = createContentViewController() {
      win.contentViewController = vc
    }
    
    
    // Window size
    
    win.setContentSize(defaultWindowContentSize)
    
    win.center()
    // autosave frame
    // Note: this stores the position, but not the size. The size is then reset
    //       by the contentViewController!
    // NOTE: this must be done late, so that it properly restores the size
    if let s = self.zzFrameAutosaveName, !s.isEmpty {
      win.setFrameAutosaveName(s)
    }
  }
  
  open func createContentViewController() -> NSViewController? {
    return nil
  }
  
}
