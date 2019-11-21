//
//  ZzViewConstraints.swift
//  VueXcode
//
//  Created by Helge Hess on 07/06/17.
//  Copyright © 2017-2019 ZeeZide GmbH. All rights reserved.
//

import class     Cocoa.NSLayoutConstraint
import typealias Cocoa.CGFloat

public extension ZzView {
  
  @discardableResult
  func zzAdd<T>(_ subview: T,
                hug    : ZzLayoutPriority? = nil,
                hugh   : ZzLayoutPriority? = nil,
                hugv   : ZzLayoutPriority? = nil,
                cr     : ZzLayoutPriority? = nil,
                crh    : ZzLayoutPriority? = nil,
                crv    : ZzLayoutPriority? = nil,
                aspect : Bool = false,
                _ constraintArgs : Any...) -> T
         where T: ZzView
  {
    addSubview(subview)
    
    // what crap :-)
    let def = ZzLayoutPriority(rawValue: 0.0)
    let lhugh : ZzLayoutPriority? = (hugh == nil && hug == nil)
      ? nil : ZzLayoutPriority((hugh ?? def).rawValue + (hug ?? def).rawValue)
    let lhugv : ZzLayoutPriority? = (hugv == nil && hug == nil)
      ? nil : ZzLayoutPriority((hugv ?? def).rawValue + (hug ?? def).rawValue)

    let lcrh  : ZzLayoutPriority? = (crh == nil && cr == nil)
      ? nil : ZzLayoutPriority((crh ?? def).rawValue + (cr ?? def).rawValue)
    let lcrv  : ZzLayoutPriority? = (crv == nil && cr == nil)
      ? nil : ZzLayoutPriority((crv ?? def).rawValue + (cr ?? def).rawValue)
    
    if let h = lhugh { subview.setContentHuggingPriority(h, for: .horizontal) }
    if let h = lhugv { subview.setContentHuggingPriority(h, for: .vertical)   }
    if let h = lcrh {
      subview.setContentCompressionResistancePriority(h, for: .horizontal)
    }
    if let h = lcrv {
      subview.setContentCompressionResistancePriority(h, for: .vertical)
    }
    
    var constraints = ZZArrayOfConstraints()

    if !constraintArgs.isEmpty {
      let views : ZzViewDictionary = [ "self": subview, "super": self ]
      subview.translatesAutoresizingMaskIntoConstraints = false
      ZzAdd(constraints: constraintArgs, to: &constraints, views: views)
    }
      
    if aspect {
      constraints.append(NSLayoutConstraint.zzAspectRatio(subview))
    }
    
    if !constraints.isEmpty {
      NSLayoutConstraint.activate(constraints)
    }
    
    return subview
  }
  
}


public extension ZzView { // Constraints
  
  var zzAllConstraints : [ NSLayoutConstraint ] {
    var ca = self.constraints
    for view in subviews {
      ca.append(contentsOf: view.zzAllConstraints)
    }
    return ca
  }
  
  @discardableResult
  func zzConstrain(h: String = "", v: String = "")
       -> [ NSLayoutConstraint ]
  {
    // Sample: let ca = constrain(h: "|[self]|" v:"|[self]|")
    let superView = self.superview
    let views : ZzViewDictionary = superView != nil
                                    ? [ "self": self, "super": superView! ]
                                    : [ "self": self ]

    let hc : ZZArrayOfConstraints, vc : ZZArrayOfConstraints
    if !h.isEmpty { hc = NSLayoutConstraint.zz("H:" + h, views: views)}
    else          { hc = [] }
    if !v.isEmpty { vc = NSLayoutConstraint.zz("V:" + v, views: views)}
    else          { vc = [] }
    
    let ac : ZZArrayOfConstraints
    if      hc.isEmpty { ac = vc }
    else if vc.isEmpty { ac = hc }
    else               { ac = vc + hc }
    
    guard !ac.isEmpty else { return [] }
    
    if let sv = superView { sv.addConstraints(ac) }
    return ac
  }
  
  func zzAddConstraint(_ vfl: String, views: ZzViewDictionary? = nil)
       -> ZZArrayOfConstraints
  {
    // TODO: docs say we should use +[NSLayoutConstraint activateConstraints:]
    //       instead
    // Used in ZzSourceListView and ZzToolbarStatusView
    let cs = NSLayoutConstraint.zz(vfl, views: views)
    addConstraints(cs)
    return cs
  }
  
  func zzFixWidthConstraint(_ width: CGFloat) -> NSLayoutConstraint {
    return NSLayoutConstraint(item:   self, attribute: .width, relatedBy:.equal,
                              toItem: nil,  attribute: .notAnAttribute,
                              multiplier: 1, constant: width)
  }

  static func zzConstrainVerticalStack(_ _views : [ ZzView ]) {
    // TODO: collect NSLayoutConstraints! (zzConstrain activates already)
    
    guard _views.count > 1 else { return }
    
    // setup stacking constraints
    var lastView : ZzView? = nil
    
    for subview in _views {
      subview.zzConstrain(h: "|[self]|")
      
      if lastView == nil { // attach first to top
        subview.zzConstrain(v: "|[self]")
      }
      else {
        lastView!.bottomAnchor.constraint(equalTo: subview.topAnchor).isActive = true
      }
      lastView = subview
    }
    
    // attach last to bottom
    lastView?.zzConstrain(v: "[self]|")
  }


  // MARK: Padding

  class var zzStandardConstantBetweenSiblings : CGFloat {
    return _zzStandardConstantBetweenSiblings
  }
  
  class var zzStandardConstantBetweenSuperview : CGFloat {
    return _zzStandardConstantBetweenSuperview
  }
}

private var _zzStandardConstantBetweenSiblings : CGFloat = {
  let view = ZzView()
  let ca = NSLayoutConstraint.constraints(withVisualFormat:"[view]-[view]",
                                          metrics: nil,
                                          views: [ "view": view ])
  return ca.first!.constant // 8.0
}()

private var _zzStandardConstantBetweenSuperview : CGFloat = {
  let superView = ZzView()
  let view      = ZzView()
  superView.addSubview(view)
  
  let ca = NSLayoutConstraint.constraints(withVisualFormat:"[view]-|",
                                          metrics: nil,
                                          views: [ "view": view ])
  return ca.first!.constant // 20.0
}()
