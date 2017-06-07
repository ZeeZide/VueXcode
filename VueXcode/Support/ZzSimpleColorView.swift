//
//  ZzSimpleColorView.swift
//  VueXcode
//
//  Created by Helge Hess on 07/06/17.
//  Copyright © 2017 ZeeZide GmbH. All rights reserved.
//

import Cocoa

/**
 * ZzSimpleColorView
 *
 * Just to draw a background. Could also use a layer backed view and set the
 * layer bg-color I guess ...
 */
open class ZzSimpleColorView : ZzView {
  
  public convenience init(fill: ZzColor? = nil, stroke: ZzColor? = nil) {
    self.init(frame: ZZInitialSize)
    translatesAutoresizingMaskIntoConstraints = false
    self.fillColor   = fill
    self.strokeColor = stroke
  }
  
  open var fillColor   : ZzColor? = nil {
    didSet { needsDisplay = true }
  }
  open var strokeColor : ZzColor? = nil {
    didSet { needsDisplay = true }
  }
  
  override open func draw(_ dirtyRect: ZzRect) {
    super.draw(dirtyRect)

    // nothing to do
    guard fillColor != nil || strokeColor != nil else { return }
    
    NSGraphicsContext.saveGraphicsState() // TBD: required?
    defer { NSGraphicsContext.restoreGraphicsState() }
    
    let bp = ZzBezierPath(rect: bounds)
    if let c = fillColor   { c.setFill();   bp.fill()   }
    if let c = strokeColor { c.setStroke(); bp.stroke() }
  }
}
