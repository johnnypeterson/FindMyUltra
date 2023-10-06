//
//  FilterModel.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 10/6/23.
//

import SwiftUI

struct FilterModel {
 var difficulty: Difficulty?
 var raceDistance: RaceDistance?
  
}



enum Difficulty: CaseIterable, Identifiable, CustomStringConvertible {
    case unranked
    case easy
    case moderate
    case tough
    case extreme
    
    var id: Self {self}
    var description: String {
        switch self {
            
        case .unranked:
            return "Unranked"
        case .easy:
            return "Easy"
        case .moderate:
            return "Moderate"
        case .tough:
            return "Tough"
        case .extreme:
            return "Extreme"
        }
    }
    var network: String {
        switch self {
            
        case .unranked:
            return "0"
        case .easy:
            return "1"
        case .moderate:
            return "2"
        case .tough:
            return "3"
        case .extreme:
            return "4"
        }
    }
}


enum RaceDistance: CaseIterable, Identifiable, CustomStringConvertible {
    case lessThenTen
    case tenToTwentySix
    case twentySixtoForty
    case fortyOneToSixty
    case sixyOneToNintey
    case NinteyToOneHundred
    case oneHundredPlus
    
    var id: Self {self}
    var description: String {
        switch self {
        
        case .lessThenTen:
            return "<10 Miles"
        case .tenToTwentySix:
            return "10-26 Miles"
        case .twentySixtoForty:
            return "26-40 Miles"
        case .fortyOneToSixty:
            return "41-60 Miles"
        case .sixyOneToNintey:
            return "61-90 Miles"
        case .NinteyToOneHundred:
            return "91-100 Miles"
        case .oneHundredPlus:
            return ">110 Miles"
        }
    }
    var network: String {
        switch self {
        
        case .lessThenTen:
            return "1"
        case .tenToTwentySix:
            return "2"
        case .twentySixtoForty:
            return "3"
        case .fortyOneToSixty:
            return "4"
        case .sixyOneToNintey:
            return "5"
        case .NinteyToOneHundred:
            return "6"
        case .oneHundredPlus:
            return "7"
        }
    }
}
