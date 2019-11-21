//
//  ZzView.swift
//  VueXcode
//
//  Created by Helge Hess on 07/06/17.
//  Copyright © 2017-2019 ZeeZide GmbH. All rights reserved.
//

import func Foundation.NSLog
import class Cocoa.CALayer

public struct ZzViewSearchOptions: OptionSet {
  
  public let rawValue: Int
  
  public init(rawValue: Int) { self.rawValue = rawValue }
  
  public static let none = ZzViewSearchOptions(rawValue: 0)
  
  public static let deep = ZzViewSearchOptions(rawValue: 1 << 1)
    // looks for the upmost view
}

public extension ZzView {
  
  // MARK: - View Hierarchy
  
  @discardableResult
  func zzWalkViewHierarchy(_ block: ( ZzView ) -> Bool) -> Bool {
    let sv = subviews
    
    for view in sv {
      guard block(view) else { return false } // stopped
    }
    
    for view in sv {
      guard view.zzWalkViewHierarchy(block) else { return false } // stopped
    }
    
    return true
  }

  func zzSubview(options     opts      : ZzViewSearchOptions = .none,
                 passingTest predicate : ( ZzView ) -> Bool)
       -> ZzView?
  {
    for view in subviews {
      if predicate(view) {
        return view
      }
    }
    
    if opts.contains(.deep) {
      for view in subviews {
        let sv = view.zzSubview(options: opts, passingTest: predicate)
        if sv != nil { return sv }
      }
    }
    
    return nil
  }
  
  func zzFirstSubview<T: ZzView>() -> T? { // This is a little crazy :-)
    guard let v = zzFirstSubview(ofClass: T.self) else { return nil }
    return (v as! T)
  }
  func zzFirstSubview<T: ZzView>() -> T { // This is a little crazy :-)
    return zzFirstSubview(ofClass: T.self) as! T
  }
  
  func zzFirstSubview(ofClass aClass: AnyClass) -> ZzView? {
    return zzSubview(options: .deep) { $0.isKind(of: aClass) }
  }
  func zzView(withID id: String) -> ZzView? {
    return zzSubview(options: .deep) { $0.identifier?.rawValue == id }
  }
  
  func zzIdToSubview() -> [ String: ZzView ] {
    var idToView = [ String: ZzView ]()
    
    zzWalkViewHierarchy { view in
      guard let vid = view.identifier else { return true }
      
      guard idToView[vid.rawValue] == nil else {
        NSLog("WARN(\(#function)): duplicate view identifier: " +
              "\(vid) base: \(self)")
        return true
      }
      
      idToView[vid.rawValue] = view
      return true
    }
    
    if idToView["self"] == nil {
      idToView["self"] = self
    }
    
    return idToView
  }

}
