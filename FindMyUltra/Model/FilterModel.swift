//
//  FilterModel.swift
//  FindMyUltra
//
//  Created by Johnny Peterson on 10/6/23.
//




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
    case showAll
    case lessThanTen
    case tenToTwentySix
    case twentySixToForty
    case fortyOneToSixty
    case sixtyOneToNinety
    case ninetyToOneHundred
    case oneHundredPlus
    
    var id: Self {self}
    var description: String {
        switch self {
        case .showAll:
            return "Show All"
        case .lessThanTen:
            return "<10 Miles"
        case .tenToTwentySix:
            return "10-26 Miles"
        case .twentySixToForty:
            return "26-40 Miles"
        case .fortyOneToSixty:
            return "41-60 Miles"
        case .sixtyOneToNinety:
            return "61-90 Miles"
        case .ninetyToOneHundred:
            return "91-100 Miles"
        case .oneHundredPlus:
            return ">110 Miles"
        }
    }
    var network: String {
        switch self {
        case .showAll:
            return "0"
        case .lessThanTen:
            return "1"
        case .tenToTwentySix:
            return "2"
        case .twentySixToForty:
            return "3"
        case .fortyOneToSixty:
            return "4"
        case .sixtyOneToNinety:
            return "5"
        case .ninetyToOneHundred:
            return "6"
        case .oneHundredPlus:
            return "7"
        }
    }
}

/// Represents the radius, in miles, used when searching for races.
///
/// This was previously named `DistanceFromMe` but now reflects that the
/// search can originate from any point, not just the user's current
/// location.
enum SearchRadius: CaseIterable, Identifiable, CustomStringConvertible {
    case twentyFive
    case fiftyMiles
    case oneHundred
    case twoHundred
    case threeHundred
    case fourHundred
    case fiveHundred
    
    var id: Self {self}
    var description: String {
        switch self {
        
        case .twentyFive:
            return "25 Miles"
        case .fiftyMiles:
            return "50 Miles"
        case .oneHundred:
            return "100 Miles"
        case .twoHundred:
            return "200 Miles"
        case .threeHundred:
            return "300 Miles"
        case .fourHundred:
            return "400 Miles"
        case .fiveHundred:
            return "500 Miles"
        }
    }
    /// String representation expected by the backend when specifying the
    /// radius in miles.
    var network: String {
        switch self {
        case .twentyFive:
            return "25"
        case .fiftyMiles:
            return "50"
        case .oneHundred:
            return "100"
        case .twoHundred:
            return "200"
        case .threeHundred:
            return "300"
        case .fourHundred:
            return "400"
        case .fiveHundred:
            return "500"
        }
    }
}

enum Month: CaseIterable, Identifiable, CustomStringConvertible  {
    case January, February, March, April, May, June, July, August, September, October, November, December
    case showAll
    
    var id: Self {self}
    var description: String {
        switch self {
        case .showAll:
            return "Show All"
        case .January:
            return " January"
        case .February:
            return " February"
        case .March:
            return " March"
        case .April:
            return " April"
        case .May:
            return " May"
        case .June:
            return " June"
        case .July:
            return " July"
        case .August:
            return " August"
        case .September:
            return " September"
        case .October:
            return " October"
        case .November:
            return " November"
        case .December:
            return " December"
        }
    }
    var network: String {
        switch self {
        case .showAll:
            return "0"
        case .January:
            return "1"
        case .February:
            return "2"
        case .March:
            return "3"
        case .April:
            return "4"
        case .May:
            return "5"
        case .June:
            return "6"
        case .July:
            return "7"
        case .August:
            return "8"
        case .September:
            return "9"
        case .October:
            return "10"
        case .November:
            return "11"
        case .December:
            return "12"
        }
    }

}

