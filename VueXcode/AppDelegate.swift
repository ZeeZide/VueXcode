//
//  AppDelegate.swift
//  VueXcode
//
//  Created by Helge Hess on 07/06/17.
//  Copyright © 2017 ZeeZide GmbH. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var aboutWC : ZzWindowController? = nil


  func applicationDidFinishLaunching(_ aNotification: Notification) {
    aboutWC = InfoPanelWC()
    aboutWC?.showWindow(self)
    
    patchAboutMenu()
  }

  // MARK: - About Menu
  
  // I think this is not called because we are NOT an NSResponder subclass?
  // TODO: or is just a 'canPerformAction' missing?
  func patchAboutMenu() {
    guard let menu    = NSApplication.shared().mainMenu else { return }
    guard let appMenu = menu.item(at: 0)?.submenu       else { return }
    
    let appItems = appMenu.items
    
    // FIXME: index based, but how to do it betta? => Create programatically!
    if appItems.count > 0 {
      let item = appItems[0]
      if item.action == #selector(orderFrontStandardAboutPanel(_:)) {
        item.target = self
      }
    }
  }

  func orderFrontStandardAboutPanel(_ sender: Any?) {
    if aboutWC == nil { aboutWC = InfoPanelWC() }
    aboutWC?.showWindow(self)
    aboutWC?.window?.orderFront(self)
  }
}

