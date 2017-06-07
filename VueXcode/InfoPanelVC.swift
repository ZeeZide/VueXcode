//
//  InfoPanelVC.swift
//  VueXcode
//
//  Created by Helge Hess on 07/06/17.
//  Copyright © 2017 ZeeZide GmbH. All rights reserved.
//

class InfoPanelVC : ZzViewControllerBase {
  
  override func makeView() -> ZzView? {
    let view = ZzSimpleColorView(fill: ZzColor.white)
    
    // by default this results in a very stretched window :-)
    // desired: ~490x240
    let infoView = VueCreditsView()
    view.zzAdd(infoView, "H:|[self(<=490)]|", "V:|[self(<=242)]|")
    return view
  }
  
}
