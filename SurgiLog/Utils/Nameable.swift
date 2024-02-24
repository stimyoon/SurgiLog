//
//  NameProtocol.swift
//  QuickSpine
//
//  Created by Tim Yoon on 2/11/24.
//

import Foundation

protocol Nameable {
    var firstName: String { set get }
    var middleName: String { set get }
    var lastName: String { set get }
    var formalName: String { get }
    var firstAndLastName: String { get }
    var fullName: String { get }
}
extension Nameable {
    var formalName: String {
        lastName + ", " + firstName + " " + middleName
    }
    var firstAndLastName: String {
        firstName + " " + lastName
    }
    var fullName: String {
        firstName + " " + middleName + " " +  lastName
    }
    var lastAndFirstName: String {
        lastName + ", " + firstName
    }
}
