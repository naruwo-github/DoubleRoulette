//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map { Locale(identifier: $0) }
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try intern.validate()
  }

  #if os(iOS) || os(tvOS)
  /// This `R.storyboard` struct is generated, and contains static references to 4 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    /// Storyboard `Modal`.
    static let modal = _R.storyboard.modal()
    /// Storyboard `Popup`.
    static let popup = _R.storyboard.popup()

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "Modal", bundle: ...)`
    static func modal(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.modal)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "Popup", bundle: ...)`
    static func popup(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.popup)
    }
    #endif

    fileprivate init() {}
  }
  #endif

  /// This `R.color` struct is generated, and contains static references to 2 colors.
  struct color {
    /// Color `navigationItemColor`.
    static let navigationItemColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "navigationItemColor")
    /// Color `rouletteLabel`.
    static let rouletteLabel = Rswift.ColorResource(bundle: R.hostingBundle, name: "rouletteLabel")

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "navigationItemColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func navigationItemColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.navigationItemColor, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "rouletteLabel", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func rouletteLabel(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.rouletteLabel, compatibleWith: traitCollection)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "navigationItemColor", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func navigationItemColor(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.navigationItemColor.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "rouletteLabel", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func rouletteLabel(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.rouletteLabel.name)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.file` struct is generated, and contains static references to 2 files.
  struct file {
    /// Resource file `GoogleService-Info.plist`.
    static let googleServiceInfoPlist = Rswift.FileResource(bundle: R.hostingBundle, name: "GoogleService-Info", pathExtension: "plist")
    /// Resource file `roulette-sound.mp3`.
    static let rouletteSoundMp3 = Rswift.FileResource(bundle: R.hostingBundle, name: "roulette-sound", pathExtension: "mp3")

    /// `bundle.url(forResource: "GoogleService-Info", withExtension: "plist")`
    static func googleServiceInfoPlist(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.googleServiceInfoPlist
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "roulette-sound", withExtension: "mp3")`
    static func rouletteSoundMp3(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.rouletteSoundMp3
      return fileResource.bundle.url(forResource: fileResource)
    }

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 3 images.
  struct image {
    /// Image `arrow1`.
    static let arrow1 = Rswift.ImageResource(bundle: R.hostingBundle, name: "arrow1")
    /// Image `arrow2`.
    static let arrow2 = Rswift.ImageResource(bundle: R.hostingBundle, name: "arrow2")
    /// Image `setting`.
    static let setting = Rswift.ImageResource(bundle: R.hostingBundle, name: "setting")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "arrow1", bundle: ..., traitCollection: ...)`
    static func arrow1(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.arrow1, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "arrow2", bundle: ..., traitCollection: ...)`
    static func arrow2(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.arrow2, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "setting", bundle: ..., traitCollection: ...)`
    static func setting(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.setting, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.nib` struct is generated, and contains static references to 2 nibs.
  struct nib {
    /// Nib `DRPopupWithBalloonView`.
    static let drPopupWithBalloonView = _R.nib._DRPopupWithBalloonView()
    /// Nib `DRTableViewCell`.
    static let drTableViewCell = _R.nib._DRTableViewCell()

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "DRPopupWithBalloonView", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.drPopupWithBalloonView) instead")
    static func drPopupWithBalloonView(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.drPopupWithBalloonView)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "DRTableViewCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.drTableViewCell) instead")
    static func drTableViewCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.drTableViewCell)
    }
    #endif

    static func drPopupWithBalloonView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
      return R.nib.drPopupWithBalloonView.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
    }

    static func drTableViewCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> DRTableViewCell? {
      return R.nib.drTableViewCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? DRTableViewCell
    }

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    #if os(iOS) || os(tvOS)
    try storyboard.validate()
    #endif
  }

  #if os(iOS) || os(tvOS)
  struct nib {
    struct _DRPopupWithBalloonView: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "DRPopupWithBalloonView"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }

      fileprivate init() {}
    }

    struct _DRTableViewCell: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "DRTableViewCell"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> DRTableViewCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? DRTableViewCell
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }
  #endif

  #if os(iOS) || os(tvOS)
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      #if os(iOS) || os(tvOS)
      try launchScreen.validate()
      #endif
      #if os(iOS) || os(tvOS)
      try main.validate()
      #endif
      #if os(iOS) || os(tvOS)
      try modal.validate()
      #endif
      #if os(iOS) || os(tvOS)
      try popup.validate()
      #endif
    }

    #if os(iOS) || os(tvOS)
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController

      let bundle = R.hostingBundle
      let name = "LaunchScreen"

      static func validate() throws {
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }
    #endif

    #if os(iOS) || os(tvOS)
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UINavigationController

      let bundle = R.hostingBundle
      let drRouletteViewController = StoryboardViewControllerResource<DRRouletteViewController>(identifier: "DRRouletteViewController")
      let name = "Main"

      func drRouletteViewController(_: Void = ()) -> DRRouletteViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: drRouletteViewController)
      }

      static func validate() throws {
        if UIKit.UIImage(named: "setting", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'setting' is used in storyboard 'Main', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
        if _R.storyboard.main().drRouletteViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'drRouletteViewController' could not be loaded from storyboard 'Main' as 'DRRouletteViewController'.") }
      }

      fileprivate init() {}
    }
    #endif

    #if os(iOS) || os(tvOS)
    struct modal: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let drRouletteSettingViewController = StoryboardViewControllerResource<DRRouletteSettingViewController>(identifier: "DRRouletteSettingViewController")
      let name = "Modal"

      func drRouletteSettingViewController(_: Void = ()) -> DRRouletteSettingViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: drRouletteSettingViewController)
      }

      static func validate() throws {
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
        if _R.storyboard.modal().drRouletteSettingViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'drRouletteSettingViewController' could not be loaded from storyboard 'Modal' as 'DRRouletteSettingViewController'.") }
      }

      fileprivate init() {}
    }
    #endif

    #if os(iOS) || os(tvOS)
    struct popup: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let drResultViewController = StoryboardViewControllerResource<DRResultViewController>(identifier: "DRResultViewController")
      let drSaveTemplateViewController = StoryboardViewControllerResource<DRSaveTemplateViewController>(identifier: "DRSaveTemplateViewController")
      let name = "Popup"

      func drResultViewController(_: Void = ()) -> DRResultViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: drResultViewController)
      }

      func drSaveTemplateViewController(_: Void = ()) -> DRSaveTemplateViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: drSaveTemplateViewController)
      }

      static func validate() throws {
        if #available(iOS 11.0, tvOS 11.0, *) {
          if UIKit.UIColor(named: "navigationItemColor", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Color named 'navigationItemColor' is used in storyboard 'Popup', but couldn't be loaded.") }
        }
        if _R.storyboard.popup().drResultViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'drResultViewController' could not be loaded from storyboard 'Popup' as 'DRResultViewController'.") }
        if _R.storyboard.popup().drSaveTemplateViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'drSaveTemplateViewController' could not be loaded from storyboard 'Popup' as 'DRSaveTemplateViewController'.") }
      }

      fileprivate init() {}
    }
    #endif

    fileprivate init() {}
  }
  #endif

  fileprivate init() {}
}
