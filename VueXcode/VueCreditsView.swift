//
//  VueCreditsView.swift
//  VueXcode
//
//  Created by Helge Hess on 07/06/17.
//  Copyright © 2017 ZeeZide GmbH. All rights reserved.
//

import Cocoa

class VueCreditsView : ZzView {

  let info = InfoPanelInfo()
  
  convenience init() {
    self.init(frame: ZZInitialSize)
  }
  
  override public required init(frame: ZzRect) {
    super.init(frame: frame)
    makeView()
  }
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    makeView()
  }
  
  public var zz : ZzViewFactory {
    return ZzViewFactoryAppKit.defaultViewFactory
  }
  
  
  // MARK: - Actions
  
  @objc func onClick(_ sender: Any) {
    if let label = sender as? ZzLabel {
      onClick(label: label)
    }
    else {
      Swift.print("other click")
    }
  }
  
  func onClick(label: ZzLabel) {
    guard let urls = label.clickableLink else { return }
    guard let url  = URL(string: urls)   else { return }

    NSWorkspace.shared.open(url)
  }
 
  
  // MARK: - View Creation
  
  var portraitConstraints  : [ NSLayoutConstraint ]! = nil
  var landscapeConstraints : [ NSLayoutConstraint ]! = nil
  
  let productLink = "http://zeezide.com/"
  let vueLink     = "https://vuejs.org/"
  let apexLink    = "http://apacheexpress.io/"
  
  func makeView() {
    // setup views
    
    let h1         = makeH1(info.appName)
    let h2         = makeH2("Version \(info.version) (\(info.build))")
    let icon       = makeImageView(info.icon)
    
    // TODO: no automagic wrapping? (on iOS there is via numberOfLines)
    let copy       = makeLabel(info.copyright ?? "")
    let credits    = makeLabel(info.credits   ?? "")
    let disclaimer = makeLabel("Also checkout: ApacheExpress.")
    
    copy   .makeClickable(string: "ZeeZide GmbH",     url: productLink)
    credits.makeClickable(string: "Vue.js",           url: vueLink)
    disclaimer.makeClickable(string: "ApacheExpress", url: apexLink)
    
    // TODO: move that to the ClickableLink
    copy.target       = self
    copy.action       = #selector(onClick(_:))
    credits.target    = self
    credits.action    = #selector(onClick(_:))
    disclaimer.target = self
    disclaimer.action = #selector(onClick(_:))
    
    addSubview(h1)
    addSubview(h2)
    addSubview(icon)
    addSubview(copy)
    addSubview(credits)
    addSubview(disclaimer)
    
    // setup constraints
    
    let ppad   : CGFloat = 12 + 38
    let tspace : CGFloat = ZzFont.zzLabelFontSize * 0.5
    
    portraitConstraints = [
      // vertical: adjust for close button, we start a little lower
      h1.topAnchor.constraint(equalTo: self.topAnchor, constant: ppad),
      h2.topAnchor.constraint(equalTo: h1.bottomAnchor, constant: 2),
      
      icon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      
      disclaimer.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                         constant: -12),
      credits   .bottomAnchor.constraint(equalTo: disclaimer.topAnchor,
                                         constant: -tspace),
      copy      .bottomAnchor.constraint(equalTo: credits.topAnchor,
                                         constant: -tspace),
      
      // horizontal
      h1        .centerXAnchor.constraint(equalTo: self.centerXAnchor),
      h2        .centerXAnchor.constraint(equalTo: self.centerXAnchor),
      disclaimer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      credits   .centerXAnchor.constraint(equalTo: self.centerXAnchor),
      copy      .centerXAnchor.constraint(equalTo: self.centerXAnchor),
      icon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      
      // limit size of label (otherwise it doesn't wrap)
      NSLayoutConstraint(item: copy, attribute: .width,
                         relatedBy: .lessThanOrEqual,
                         toItem: self, attribute: .width,
                         multiplier: 1, constant: 0),
      
      // size of icon
      NSLayoutConstraint(item: icon, attribute: .width,
                         relatedBy: .equal,
                         toItem: nil, attribute: .notAnAttribute,
                         multiplier: 1,
                         constant: 72)
    ]
    
    let imageRatio : CGFloat = 0.35
    #if os(macOS) // on macOS we show a bigga icon
      let imageWidthRatio : CGFloat = imageRatio / 1.35 // most of the space
    #else
      let imageWidthRatio : CGFloat = imageRatio / 2.0 // half of the space
    #endif
    let lpad       : CGFloat = 28
    landscapeConstraints = [
      // vertical
      icon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      h1.topAnchor.constraint(equalTo: self.topAnchor,  constant: lpad),
      h2.topAnchor.constraint(equalTo: h1.bottomAnchor, constant: 2),
      
      disclaimer.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                         constant: -lpad),
      credits   .bottomAnchor.constraint(equalTo: disclaimer.topAnchor,
                                         constant: -tspace),
      copy      .bottomAnchor.constraint(equalTo: credits.topAnchor,
                                         constant: -tspace),
      
      // horizontal
      NSLayoutConstraint(item: icon, attribute: .centerX,
                         relatedBy: .equal,
                         toItem: self, attribute: .trailing,
                         multiplier: imageRatio / 2.0, constant: 0),
      NSLayoutConstraint(item: icon, attribute: .width,
                         relatedBy: .equal,
                         toItem: self, attribute: .width,
                         multiplier: imageWidthRatio,
                         constant: 0),
      
      NSLayoutConstraint(item: h1, attribute: .leading,
                         relatedBy: .equal,
                         toItem: self, attribute: .trailing,
                         multiplier: imageRatio, constant: 0),
      h2        .leftAnchor.constraint(equalTo: h1.leftAnchor),
      disclaimer.leftAnchor.constraint(equalTo: h1.leftAnchor),
      credits   .leftAnchor.constraint(equalTo: h1.leftAnchor),
      copy      .leftAnchor.constraint(equalTo: h1.leftAnchor),
      
      // limit size of label (otherwise it doesn't wrap)
      NSLayoutConstraint(item: copy, attribute: .width,
                         relatedBy: .lessThanOrEqual,
                         toItem: self, attribute: .width,
                         multiplier: (1.0 - imageRatio), constant: 0),
    ]
    
    landscapeConstraints.activate()
    zzWalkViewHierarchy { view in
      if let label = view as? ZzLabel {
        label.textAlignment = .left // created as .center
      }
      return true
    }
  }
  
  // MARK: - Child Views
  
  let font = "Helvetica Neue"
  struct FontSizes {
    static let h1 : CGFloat = 48
    static let h2 = ZzFont.zzLabelFontSize
    static let p  = ZzFont.zzLabelFontSize
  }
  
  func makeH1(_ title: String) -> ZzLabel {
    let label = zz.makeLabel(title)
    label.textAlignment = .center
    label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    label.font = ZzFont.font(family: font, size: FontSizes.h1, weight: 2)
    return label
  }
  
  func makeH2(_ title: String) -> ZzLabel {
    let label = zz.makeLabel(title)
    label.textAlignment = .center
    label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    #if !os(macOS)
      label.font = ZzFont.font(family: font, size: FontSizes.h2, weight: 4)
    #endif
    return label
  }
  
  func makeLabel(_ title: String) -> ZzLabel {
    let label = ClickableLabel(title)
    #if !os(macOS) // hm, otherwise this is lost when made clickable?!
      label.textAlignment = .center
    #endif
    label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    
    label.textColor = ZzColor.darkGray
    label.lineBreakMode = .byWordWrapping
    #if !os(macOS)
      label.numberOfLines = 2
    #endif

    #if !os(macOS)
      label.font  = ZzFont.font(family: font, size: FontSizes.p, weight: 4)
    #endif
    
    return label
  }
  
  func makeImageView(_ image: ZzImage?, size: CGFloat = 72.0) -> ZzView {
    let imageView = ZzImageView(frame: ZzRect())
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = image
    
    #if os(macOS)
      imageView.wantsLayer = true
      imageView.layer?.masksToBounds = true
      imageView.layer?.cornerRadius  = 12.632 // 10 for 57px
    #else
      imageView.layer.masksToBounds = true
      imageView.layer.cornerRadius  = 12.632 // 10 for 57px
    #endif
    
    NSLayoutConstraint(item:   imageView, attribute: .height,
                       relatedBy: .equal,
                       toItem: imageView, attribute: .width,
                       multiplier: 1, constant: 0).isActive = true
    
    #if os(macOS)
      [ NSLayoutConstraint(item: imageView, attribute: .width,
                           relatedBy: .greaterThanOrEqual, constant: 64),
        NSLayoutConstraint(item: imageView, attribute: .width,
                           relatedBy: .lessThanOrEqual, constant: 1024)
        ].activate()
    #endif
    // "H:[self(>=128@500)]", // default size, lower prio
    // "H:|-[self]-|"
    
    return imageView
  }
}

class ClickableLabel: ZzLabel {
  
  convenience init(_ title: String) {
    self.init(frame: ZZInitialSize)
    translatesAutoresizingMaskIntoConstraints = false
    
    /* configure as label */
    isEditable      = false
    isBezeled       = false
    drawsBackground = false
    isSelectable    = false // not for raw labels
    
    /* common */
    alignment   = .left
    stringValue = title // TODO: formatters
    
    // for NSTextField. There is also fittingSize, intrinsicContentSize,
    // but those don't work for NSTextField?
    // fittingSize considers all child views
    sizeToFit() // hm. still required?
  }
  
  override func mouseDown(with event: NSEvent) {
    sendAction(action, to: target)
  }
}



public typealias ZzFont = NSFont

public extension ZzFont {
  
  static var zzLabelFontSize : CGFloat { return labelFontSize }
  
  static func font(family: String, size: CGFloat = ZzFont.systemFontSize,
                   weight: Int = 0)
              -> ZzFont?
  {
    let fm = NSFontManager.shared
    return fm.font(withFamily: family, traits: [], weight: weight, size: size)
  }
  
  static func mono(family: String, size: CGFloat = ZzFont.systemFontSize)
              -> ZzFont?
  {
    let fm = NSFontManager.shared
    return fm.font(withFamily: family, traits: .fixedPitchFontMask,
                   weight: 0, size: size)
  }
  
  var zzBold : ZzFont {
    let fm = NSFontManager.shared
    return fm.convert(self, toHaveTrait: .boldFontMask)
  }
  var zzBolder : ZzFont {
    // https://developer.apple.com/reference/appkit/nsfontmanager/1462321-convertweight
    let fm   = NSFontManager.shared
    return fm.convertWeight(true, of: self)
  }
  
  func zzModifySize(by offset: CGFloat) -> ZzFont {
    let size = pointSize + offset
    let fm   = NSFontManager.shared
    return fm.convert(self, toSize: size)
  }
}


public extension NSTextField {
  
  var textAlignment: NSTextAlignment {
    set { alignment = newValue }
    get { return alignment }
  }
  
}
