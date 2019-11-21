//
//  ZzViewController.swift
//  VueXcode
//
//  Created by Helge Hess on 07/06/17.
//  Copyright © 2017-2019 ZeeZide GmbH. All rights reserved.
//

import class Foundation.NSString
import class Cocoa.Bundle
import class Cocoa.NSViewController
import func  Cocoa.NSClassFromString
import class Cocoa.NSLayoutConstraint

public typealias ZzViewController = NSViewController

public extension ZzViewController {
   
  var zz : ZzViewFactory {
    return ZzViewFactoryAppKit.defaultViewFactory
  }
}

open class ZzViewControllerBase : ZzViewController {
  
  // use this instead of loadView
  open func makeView() -> ZzView? {
    let v = ZzView(frame: ZZInitialSize)
    v.translatesAutoresizingMaskIntoConstraints = false
    return v
  }
  
  override open func loadView() {
    // Intentionally not calling super. Just for handcoded.
    if let view = makeView() {
      self.view = view
    }
  }
  
}
