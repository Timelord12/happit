//
//  PriorityEnum.swift
//  happit
//
//  Created by Андрей  on 20.03.2022.
//

import Foundation

enum Priority : Int, Codable {
    case low
    case middle
    case high
}

enum Kind : Int, Codable {
    case good
    case bad
}

enum CoreDataError : Error {
    case saveError
    case fetchError
    case deleteAllError
}

enum NetworkError : Error {
    case updateError(Int)
    case completeError(Int)
    case deleteError(Int)
    case fetchError(Int)
    case addError(Int)
    case connectionError
}

enum OrderDirection : String {
    case asc
    case desc
}

enum OrderByDate : String {
    case date
}

enum HTTPMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case connect = "CONNECT"
    case options = "OPTIONS"
    case trace = "TRACE"
    case patch = "PATCH"
}
