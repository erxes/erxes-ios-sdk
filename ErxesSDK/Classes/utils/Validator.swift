//
//  Validator.swift
//  GIZ
//
//  Created by Soyombo bat-erdene on 10/31/18.
//  Copyright © 2018 Soyombo bat-erdene. All rights reserved.
//

import Foundation
import UIKit

protocol Validatable {
    associatedtype Foo
    func validate(_ functions: [Foo]) -> Bool
}

protocol Evaluatable {
    associatedtype Foo
    func evaluate(with condition: Foo) -> Bool
}

extension UITextField: Validatable {
    func validate(_ functions: [(String) -> Bool]) -> Bool {
        return functions.map { obj in obj(self.text ?? "") }.reduce(true) { $0 && $1 }

    }
}

extension String: Evaluatable {
    func evaluate(with condition: String) -> Bool {
        guard let range = range(of: condition, options: .regularExpression, range: nil, locale: nil) else {
            return false
        }
        return range.lowerBound == startIndex && range.upperBound == endIndex
    }
}

func isPhoneNumberValid(text: String) -> Bool {
    let regexp = "^[0-9]{6,}$"
    return text.evaluate(with: regexp)
}

func isZipCodeValid(text: String) -> Bool {
    let regexp = "^[0-9]{5}$"
    return text.evaluate(with: regexp)
}

func isStateValid(text: String) -> Bool {
    let regexp = "^[A-Z]{2}$"
    return text.evaluate(with: regexp)
}

func isCVCValid(text: String) -> Bool {
    let regexp = "^[0-9]{3,4}$"
    return text.evaluate(with: regexp)
}

func isEmailValid(text: String) -> Bool {
    let regexp = "[A-Z0-9a-z._]+@([\\w\\d]+[\\.\\w\\d]*)"
    return text.evaluate(with: regexp)
}

struct User {
    let firstName: String
    let lastName: String
    let age: Int
}

extension User: Validatable {
    func validate(_ functions: [(User) -> Bool]) -> Bool {
        return functions.map { obj in obj(self) }.reduce(true) { $0 && $1 }
    }
}

func isUserNameValid(user: User) -> Bool {
    let regexp = "[A-Za-z]+"
    return user.firstName.evaluate(with: regexp) && user.lastName.evaluate(with: regexp)
}

func isUserAdult(user: User) -> Bool {
    return user.age >= 18
}
