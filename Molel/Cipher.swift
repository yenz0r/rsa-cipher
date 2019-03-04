//
//  Cipher.swift
//  RSA cipher
//
//  Created by Egor Pii on 10/23/18.
//  Copyright © 2018 yenz0redd. All rights reserved.
//

import Foundation

class Cipher: CipherRSABase {
    var p: Int
    var q: Int
    var openExp: Int
    var eiler: Int = 0
    var closeExp: Int = 0

    func cipher(_ inputArr : [UInt8]) -> [UInt16] {
        var resultArr : [UInt16] = []

        let r = self.p * self.q
        eiler = (self.p - 1)*(self.q - 1)

        closeExp = getCloseExp(eiler, openExp)

        for element in inputArr {
            resultArr.append(UInt16(cipherByte(element, openExp, r)))
        }

        return resultArr
    }

    init(_ p: Int, _ q: Int, _ openExp: Int) {
        self.p = p
        self.q = q
        self.openExp = openExp
    }
}
