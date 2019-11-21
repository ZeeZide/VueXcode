
//
//  InfoPanelInfo.swift
//  VueXcode
//
//  Created by Helge Hess on 07/06/17.
//  Copyright © 2017-2019 ZeeZide GmbH. All rights reserved.
//

import Cocoa

struct InfoPanelInfo {
  
  let appName   : String
  let version   : String
  let build     : String
  let copyright : String?
  let credits   : String?
  
  var copyrightTwo : String? {
    guard let cr = copyright else { return nil }
    return cr.replacingOccurrences(of: "GmbH. ", with: "GmbH.\n")
  }
  
  init(bundle: Bundle) {
    let nameKey = kCFBundleNameKey! as String
    appName   = bundle[info: nameKey as String]
                ?? ProcessInfo.processInfo.processName
    version   = bundle[info: "CFBundleShortVersionString"] ?? "0.42.0"
    build     = bundle[info: "CFBundleVersion"]            ?? "1337"
    copyright = bundle[info: "NSHumanReadableCopyright"]
    
    credits   = "Vue.js MIT © Evan You"
  }
  
  init() {
    self.init(bundle: Bundle.main)
  }
  
  var icon : ZzImage? { return ZzImage(named: NSImage.applicationIconName) }
}

extension Bundle {
  
  subscript(info key: String) -> String? {
    return object(forInfoDictionaryKey: key) as? String
  }
  
  subscript(info key: String) -> Int? {
    guard let v = object(forInfoDictionaryKey: key) else { return nil }
    if let v = v as? Int { return v }
    guard let s = v as? String else { return nil }
    return Int(s)
  }
  
}
