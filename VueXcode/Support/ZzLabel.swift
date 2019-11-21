//
//  ZzLabel.swift
//  VueXcode
//
//  Created by Helge Hess on 07/06/17.
//  Copyright © 2017-2019 ZeeZide GmbH. All rights reserved.
//

import Cocoa

extension ZzLabel {
  
  func makeClickable(range: NSRange, url: String, color: ZzColor = .black) {
    guard range.location != NSNotFound && range.length > 0 else { return }
    
    let attrS = attributedStringValue.mutableCopy()
                as? NSMutableAttributedString
             ?? NSMutableAttributedString(string: stringValue)
    
    let linkAttrs : [ NSAttributedString.Key : Any ] = [
      .foregroundColor: color,
      .underlineStyle: NSNumber(value: NSUnderlineStyle.single.rawValue),
      .link: URL(string: url)!
    ]
    attrS.setAttributes(linkAttrs, range: range)
    
    // isSelectable = true // breaks stuff
    attributedStringValue = attrS
  }
  
  func makeClickable(string: String, url: String, color: ZzColor = .black) {
    let ns = stringValue as NSString
    let r  = ns.range(of: string)
    makeClickable(range: r, url: url, color: color)
  }
  
  var clickableLink : String? {
    let ass = attributedStringValue
    
    var url : String? = nil
    ass.enumerateAttribute(.link,
                           in: NSRange(location: 0, length: ass.length),
                           options: [])
    { (value, range, doStop) in
      guard let lurl = value else { return }
      
      if let lurl = lurl as? String {
        url = lurl
        doStop.pointee = true
      }
      else if let lurl = lurl as? URL {
        url = lurl.absoluteString
        doStop.pointee = true
      }
    }
    
    return url
  }
}
