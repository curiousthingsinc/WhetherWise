//
//  WhetherRule.swift
//  WhetherWiseCore
//
//  Created by Eric Lobdell on 2/14/26.
//

//
//  WeatherRule.swift
//  whether
//
//  Created by Eric Lobdell on 2/4/26.
//

import Foundation
import SwiftData

/// Represents a user-defined weather rule condition
@Model
public final class WhetherRule {
  // Properties MUST be public to be readable by your Apps/Widgets
  public var id: UUID = UUID()
  public var name: String = ""
  public var createdAt: Date = Date()
  public var isEnabled: Bool = true
  
  @Relationship(deleteRule: .cascade)
  public var conditions: [WhetherCondition] = []
  
  public init(name: String = "", isEnabled: Bool = true, conditions: [WhetherCondition] = []) {
    self.id = UUID()
    self.name = name
    self.createdAt = Date()
    self.isEnabled = isEnabled
    self.conditions = conditions
  }
}

/// Individual condition within a weather rule
@Model
public final class WhetherCondition {
  public var id: UUID = UUID()
  public var fieldType: String = ""
  public var comparisonOperator: String = ""
  public var orderIndex: Int = 0
  
  public var numericValue: Double? = nil
  public var stringValue: String? = nil
  public var booleanValue: Bool? = nil
  
  @Relationship(inverse: \WhetherRule.conditions)
  public var rule: WhetherRule?
  
  public init(
    fieldType: String = "",
    comparisonOperator: String = "",
    numericValue: Double? = nil,
    stringValue: String? = nil,
    booleanValue: Bool? = nil,
    orderIndex: Int = 0
  ) {
    self.id = UUID()
    self.fieldType = fieldType
    self.comparisonOperator = comparisonOperator
    self.numericValue = numericValue
    self.stringValue = stringValue
    self.booleanValue = booleanValue
    self.orderIndex = orderIndex
  }
}

// MARK: - Enums for type safety

public enum WeatherFieldType: String, CaseIterable, Codable {
  case temperature, apparentTemperature, dewPoint
  case precipitationChance, precipitationAmount, precipitationType
  case windSpeed, windGust, windDirection
  case humidity, pressure, cloudCover, visibility, condition
  case uvIndex, isDaytime
  
  public var expectedValueType: ValueType {
    switch self {
    case .temperature, .apparentTemperature, .dewPoint,
        .precipitationChance, .precipitationAmount,
        .windSpeed, .windGust, .windDirection,
        .humidity, .pressure, .cloudCover, .visibility, .uvIndex:
      return .numeric
    case .precipitationType, .condition:
      return .string
    case .isDaytime:
      return .boolean
    }
  }
  
  public enum ValueType {
    case numeric, string, boolean
  }
}

public enum ComparisonOperator: String, CaseIterable, Codable {
  case greaterThan, greaterThanOrEqual, lessThan, lessThanOrEqual, equals, notEquals
  case contains, notContains, startsWith, endsWith
  case between, notBetween
  
  public var displayName: String {
    switch self {
    case .greaterThan: return ">"
    case .greaterThanOrEqual: return "≥"
    case .lessThan: return "<"
    case .lessThanOrEqual: return "≤"
    case .equals: return "="
    case .notEquals: return "≠"
    case .contains: return "contains"
    case .notContains: return "does not contain"
    case .startsWith: return "starts with"
    case .endsWith: return "ends with"
    case .between: return "between"
    case .notBetween: return "not between"
    }
  }
}

// MARK: - Helper extensions

public extension WhetherCondition {
  convenience init(
    fieldType: WeatherFieldType,
    comparisonOperator: ComparisonOperator,
    numericValue: Double? = nil,
    stringValue: String? = nil,
    booleanValue: Bool? = nil,
    orderIndex: Int = 0
  ) {
    self.init(
      fieldType: fieldType.rawValue,
      comparisonOperator: comparisonOperator.rawValue,
      numericValue: numericValue,
      stringValue: stringValue,
      booleanValue: booleanValue,
      orderIndex: orderIndex
    )
  }
  
  var fieldTypeEnum: WeatherFieldType? { WeatherFieldType(rawValue: fieldType) }
  var comparisonOperatorEnum: ComparisonOperator? { ComparisonOperator(rawValue: comparisonOperator) }
  
  func evaluate(with weatherData: [String: Any]) -> Bool {
    guard let fieldTypeEnum = fieldTypeEnum,
          let comparisonOperatorEnum = comparisonOperatorEnum,
          let actualValue = weatherData[fieldType] else {
      return false
    }
    
    switch fieldTypeEnum.expectedValueType {
    case .numeric:
      guard let numericValue = numericValue, let actualNumeric = actualValue as? Double else { return false }
      return evaluateNumeric(actualNumeric, comparisonOperatorEnum, numericValue)
    case .string:
      guard let stringValue = stringValue, let actualString = actualValue as? String else { return false }
      return evaluateString(actualString, comparisonOperatorEnum, stringValue)
    case .boolean:
      guard let booleanValue = booleanValue, let actualBool = actualValue as? Bool else { return false }
      return evaluateBoolean(actualBool, comparisonOperatorEnum, booleanValue)
    }
  }
  
  private func evaluateNumeric(_ actual: Double, _ op: ComparisonOperator, _ expected: Double) -> Bool {
    switch op {
    case .greaterThan: return actual > expected
    case .greaterThanOrEqual: return actual >= expected
    case .lessThan: return actual < expected
    case .lessThanOrEqual: return actual <= expected
    case .equals: return abs(actual - expected) < 0.001
    case .notEquals: return abs(actual - expected) >= 0.001
    default: return false
    }
  }
  
  private func evaluateString(_ actual: String, _ op: ComparisonOperator, _ expected: String) -> Bool {
    let a = actual.lowercased()
    let e = expected.lowercased()
    switch op {
    case .equals: return a == e
    case .notEquals: return a != e
    case .contains: return a.contains(e)
    case .notContains: return !a.contains(e)
    case .startsWith: return a.hasPrefix(e)
    case .endsWith: return a.hasSuffix(e)
    default: return false
    }
  }
  
  private func evaluateBoolean(_ actual: Bool, _ op: ComparisonOperator, _ expected: Bool) -> Bool {
    switch op {
    case .equals: return actual == expected
    case .notEquals: return actual != expected
    default: return false
    }
  }
}

public extension WhetherRule {
  func evaluate(with weatherData: [String: Any]) -> Bool {
    guard isEnabled, !conditions.isEmpty else { return false }
    return conditions.allSatisfy { $0.evaluate(with: weatherData) }
  }
  
  var description: String {
    guard !conditions.isEmpty else { return name.isEmpty ? "Empty rule" : name }
    let conditionDescriptions = conditions.sorted { $0.orderIndex < $1.orderIndex }.map { condition in
      var desc = condition.fieldType
      if let op = condition.comparisonOperatorEnum { desc += " \(op.displayName)" }
      if let num = condition.numericValue { desc += " \(num)" }
      else if let str = condition.stringValue { desc += " '\(str)'" }
      else if let bool = condition.booleanValue { desc += " \(bool)" }
      return desc
    }
    
    return conditionDescriptions.joined(separator: " AND ")
  }
}
