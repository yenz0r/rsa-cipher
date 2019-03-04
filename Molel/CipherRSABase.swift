//
//  CipherRSABase.swift
//  RSA cipher
//
//  Created by Egor Pii on 10/25/18.
//  Copyright © 2018 yenz0redd. All rights reserved.
//

import Foundation

class CipherRSABase {
    func fastPower(_ inputA : UInt, _ inputZ : Int, _ inputN : Int) -> UInt {
        var a = inputA
        var z = inputZ
        let n = inputN
        var result : UInt = 1
        while z != 0 {
            while z % 2 == 0 {
                z /= 2
                a = a*a % UInt(n)
            }

            z -= 1
            result = (result * a) % UInt(n)
        }

        return result
    }

    //расширенный алгоритм евклида
    func extensionEuclid(_ inputA : Int, _ inputB : Int) -> Int {
        var d0 = inputA
        var d1 = inputB
        var x0 = 1
        var x1 = 0
        var y0 = 0
        var y1 = 1

        while d1 > 1 {
            let q = d0 / d1
            let d2 = d0 % d1
            let x2 = x0 - q*x1
            let y2 = y0 - q*y1
            d0 = d1
            d1 = d2
            x0 = x1
            x1 = x2
            y0 = y1
            y1 = y2
        }

        return y1
    }

    //получаем закрытую экспоненту
    func getCloseExp(_ eiler : Int, _ openExp : Int) -> Int {
        var result = extensionEuclid(eiler, openExp)

        while result <= 0 {
            result += eiler
        }

        return result
    }

    func cipherByte(_ inputByte : UInt8, _ openExp : Int, _ r : Int) -> UInt16 {
        return UInt16(fastPower(UInt(inputByte), openExp, r))
    }

    func decipherByte(_ inputNum : UInt16, _ closeExp : Int,_ r : Int) -> UInt8 {
        return UInt8(fastPower(UInt(inputNum), closeExp, r))
    }
}
