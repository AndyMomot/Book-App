// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum LauncScreen {
    /// Localizable.strings
    ///   BookApp
    /// 
    ///   Created by Андрей on 05.04.2023.
    internal static let bookApp = L10n.tr("Localizable", "LauncScreen.bookApp", fallback: "Book App")
    /// Welcome to Book App
    internal static let welcomeText = L10n.tr("Localizable", "LauncScreen.welcomeText", fallback: "Welcome to Book App")
  }
  internal enum LibraryScreen {
    /// Top Romantic Comedy
    internal static let comedyLabel = L10n.tr("Localizable", "LibraryScreen.comedyLabel", fallback: "Top Romantic Comedy")
    /// Library
    internal static let libraryLabel = L10n.tr("Localizable", "LibraryScreen.libraryLabel", fallback: "Library")
    /// New Arrivals
    internal static let newArrivalsLabel = L10n.tr("Localizable", "LibraryScreen.newArrivalsLabel", fallback: "New Arrivals")
    /// Romance
    internal static let romanceLabel = L10n.tr("Localizable", "LibraryScreen.romanceLabel", fallback: "Romance")
  }
  internal enum RecommendedScreen {
    /// Summary
    internal static let summary = L10n.tr("Localizable", "RecommendedScreen.summary", fallback: "Summary")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
