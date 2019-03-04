//
//  Decipher.swift
//  RSA cipher
//
//  Created by Egor Pii on 10/23/18.
//  Copyright © 2018 yenz0redd. All rights reserved.
//

import Foundation

class Decipher: CipherRSABase {
    var closeExp: Int
    var r       : Int

    func decipher(_ inputArr : [UInt16]) -> [UInt8] {
        var resultArr : [UInt8] = []

        for element in inputArr {
            resultArr.append(decipherByte(element, closeExp, r))
        }

        return resultArr
    }

    init(_ closeExp: Int,_ r: Int) {
        self.closeExp = closeExp
        self.r = r
    }
}
