//
//  ZzViewFactory.swift
//  VueXcode
//
//  Created by Helge Hess on 07/06/17.
//  Copyright © 2017 ZeeZide GmbH. All rights reserved.
//

import Cocoa

public typealias ZzViewFactory = ZzViewFactoryAppKit

public class ZzViewFactoryAppKit {

  static let defaultViewFactory : ZzViewFactory = ZzViewFactoryAppKit()
  
  func makeLabel(_ value: Any?) -> ZzLabel {
    let v = NSTextField(frame: ZZInitialSize)
    v.translatesAutoresizingMaskIntoConstraints = false
    
    /* configure as label */
    v.isEditable      = false
    v.isBezeled       = false
    v.drawsBackground = false
    v.isSelectable    = false // not for raw labels
    
    /* common */
    v.alignment   = NSLeftTextAlignment
    v.objectValue = value // TODO: formatters
    
    // for NSTextField. There is also fittingSize, intrinsicContentSize,
    // but those don't work for NSTextField?
    // fittingSize considers all child views
    v.sizeToFit() // hm. still required?
    
    return v
  }
  
}
