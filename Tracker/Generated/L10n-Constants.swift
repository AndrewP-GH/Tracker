// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum InfoPlist {
    /// InfoPlist.strings
    ///   Tracker
    /// 
    ///   Created by Андрей Парамонов on 23.11.2023.
    internal static let cfBundleDisplayName = L10n.tr("InfoPlist", "CFBundleDisplayName", fallback: "Трекер")
  }
  internal enum Localizable {
    /// Plural format key: "%#@DAYS@"
    internal static func numberOfDays(_ p1: Int) -> String {
      return L10n.tr("Localizable", "numberOfDays", p1, fallback: "Plural format key: \"%#@DAYS@\"")
    }
    internal enum Trackers {
      /// Удалить
      internal static let delete = L10n.tr("Localizable", "trackers.delete", fallback: "Удалить")
      /// Редактировать
      internal static let edit = L10n.tr("Localizable", "trackers.edit", fallback: "Редактировать")
      /// Фильтры
      internal static let filters = L10n.tr("Localizable", "trackers.filters", fallback: "Фильтры")
      /// Закрепить
      internal static let pin = L10n.tr("Localizable", "trackers.pin", fallback: "Закрепить")
      /// Закрепленные
      internal static let pinned = L10n.tr("Localizable", "trackers.pinned", fallback: "Закрепленные")
      /// Статистика
      internal static let statistics = L10n.tr("Localizable", "trackers.statistics", fallback: "Статистика")
      /// Localizable.strings
      ///   Tracker
      /// 
      ///   Created by Андрей Парамонов on 22.11.2023.
      internal static let title = L10n.tr("Localizable", "trackers.title", fallback: "Трекеры")
      /// Трекеры
      internal static let trackers = L10n.tr("Localizable", "trackers.trackers", fallback: "Трекеры")
      /// Открепить
      internal static let unpin = L10n.tr("Localizable", "trackers.unpin", fallback: "Открепить")
    }
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
