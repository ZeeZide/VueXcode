//
//  ZzLayoutConstraint.swift
//  VueXcode
//
//  Created by Helge Hess on 07/06/17.
//  Copyright © 2017-2019 ZeeZide GmbH. All rights reserved.
//

import class Foundation.NSNumber

import class     Cocoa.NSView
import class     Cocoa.NSLayoutConstraint
import typealias Cocoa.CGFloat
import var       Cocoa.NSViewNoIntrinsicMetric
import enum      Cocoa.NSLayoutAttribute
import enum      Cocoa.NSLayoutRelation

public let ZzViewNoIntrinsicMetric = NSView.noIntrinsicMetric

public typealias ZZArrayOfConstraints = [ NSLayoutConstraint ]
public typealias ZZArrayOfStrings     = [ String ]
public typealias ZzViewDictionary     = [ String : ZzView ]
public typealias ZzMetrics            = [ String : NSNumber ]

public extension Array where Element : NSLayoutConstraint {
  
  @discardableResult
  func activate() -> Array {
    NSLayoutConstraint.activate(self)
    return self
  }
  @discardableResult
  func deactivate() -> Array {
    NSLayoutConstraint.deactivate(self)
    return self
  }
  
  var priority : ZzLayoutPriority {
    set {
      for constraint in self {
        constraint.priority = newValue
      }
    }
    get {
      return ZzLayoutPriority(
        map({ $0.priority.rawValue }).reduce(0.0) { last, prio in
          return last + (prio / Float(self.count))
        }
      )
    }
  }
  
}

public func ZzAdd(constraints: [ Any] , to array: inout [ NSLayoutConstraint ],
                  views: ZzViewDictionary? = nil)
{
  for arg in constraints {
    if let constraint = arg as? NSLayoutConstraint {
      array.append(constraint)
    }
    else if let argCA = arg as? [NSLayoutConstraint] {
      array.append(contentsOf: argCA)
    }
    else if let vfl = arg as? String {
      let ca = NSLayoutConstraint.zz(vfl, views: views)
      array.append(contentsOf: ca)
    }
    else if let argCA = arg as? [ Any ] {
      ZzAdd(constraints: argCA, to: &array, views: views)
    }
    else {
      fatalError("unexpected constraint argument type")
    }
  }
}

public extension NSLayoutConstraint {
  
  convenience init(item view1: Any, attribute attr1: Attribute,
                   relatedBy relation: Relation = .equal,
                   multiplier: CGFloat = 1.0, constant c: CGFloat)
  {
    self.init(item: view1, attribute: attr1, relatedBy: relation,
              toItem: nil, attribute: .notAnAttribute,
              multiplier: multiplier, constant: c)
  }

  // make height the same as width
  static func zzAspectRatio(_ a: ZzView, multiplier: CGFloat = 1,
                            priority: ZzLayoutPriority = .init(750))
              -> NSLayoutConstraint
  {
    let c = NSLayoutConstraint(item:   a, attribute: .height, relatedBy: .equal,
                               toItem: a, attribute: .width,
                               multiplier: multiplier, constant: 0)
    c.priority = priority
    return c
  }
  
  static func zz(_ vfl: Any, views: ZzViewDictionary? = nil,
                 metrics: ZzMetrics? = nil)
              -> ZZArrayOfConstraints
  {
    // Visual Markup Language
    if let s = vfl as? String {
      return NSLayoutConstraint.constraints(
               withVisualFormat: s, options: [], metrics: metrics,
               views: (views ?? [:]) as [ String : Any ])
    }
    
    // a constraint already
    if let c = vfl as? NSLayoutConstraint {
      return [ c ]
    }
    
    guard let _vfl = vfl as? [ Any ] else { // nothing we know about
      assert(false, "expected VFL or an array of that!")
      return []
    }
    
    // an array of something

    let count = _vfl.count
    if count == 0 { return [] }
    if count == 1 { return zz(_vfl[0], views: views, metrics: metrics) }
      
    var ma = ZZArrayOfConstraints()
    ma.reserveCapacity(32)
      
    for lvfl in _vfl {
      let lc = zz(lvfl, views: views, metrics: metrics)
      ma.append(contentsOf: lc)
    }
    return ma
  }

}
