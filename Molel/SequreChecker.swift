//
//  SequreChecher.swift
//  RSA cipher
//
//  Created by Egor Pii on 10/23/18.
//  Copyright © 2018 yenz0redd. All rights reserved.
//

import Foundation

class SequreChecker {
    let numSet: Set = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

    var errorMessgage = ""
    var index = 1
    //private
    func isNumber(_ num: String) -> Bool {
        for element in num {
            guard numSet.contains(String(element)) else {
                return false
            }
        }
        return true
    }

    public func prime (_ num: Int) -> Bool {
        if num < 2 {
            return false
        }

        for i in 2..<num {
            if num % i == 0 {
                errorMessgage.append("\(index) : \(num) is not prime!\n")
                index += 1
                return false
            }
        }
        return true
    }

    public func bothPrime(_ first: Int, _ second: Int) -> Bool { //for open exp
        var a = 0
        var b = max(first, second), r = min(first, second)
        while r != 0 {
            a = b
            b = r
            r = a % b
        }
        return b == 1
    }

    //public
    public func isUnsequreFileEmpty(_ inputArr : [UInt8]) -> Bool {
        errorMessgage.append("\(index) : unsequre file is empty!\n")
        index += 1
        return inputArr.count == 0
    }

    public func ifSequreFileEmpty(_ inputArr : [UInt16]) -> Bool {
        errorMessgage.append("\(index) : sequre file is empty!\n")
        index += 1
        return inputArr.count == 0
    }

    public func checkR(_ r: Int) -> Bool {
        guard r >= UInt8.max && r <= UInt16.max else {
            errorMessgage.append("\(index) : your P and Q is too small!")
            index += 1
            return false
        }
        return true
    }


}
