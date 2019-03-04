//
//  DataProvider.swift
//  RSA cipher
//
//  Created by Egor Pii on 10/23/18.
//  Copyright © 2018 yenz0redd. All rights reserved.
//

import Foundation

class DataProvider {
    var fileURL: URL

    func getFileSize() -> Int {
        do {
        let resources = try fileURL.resourceValues(forKeys:[.fileSizeKey])
        let fileSize = resources.fileSize!
            return fileSize
        } catch {
            print("Error: \(error)")
            return 0
        }
    }

    func getArrUInt8() -> [UInt8] {
        var resultArr: [UInt8] = []
        let inputStream = InputStream(fileAtPath: fileURL.path)!

        resultArr = [UInt8](repeating: 0, count: Int(getFileSize()))
        inputStream.open()
        inputStream.read(&resultArr, maxLength: Int(getFileSize()))
        inputStream.close()

        return resultArr
    }

    func getArrUInt16() -> [UInt16] {

        func get16Bit(_ a: UInt8, _ b: UInt8) -> UInt16 {
            var tmpA = UInt16(a)
            let tmpB = UInt16(b)
            tmpA <<= 8
            tmpA |= tmpB

            return tmpA
        }

        var tmpArr: [UInt8] = getArrUInt8()

        var resultArr: [UInt16] = []
        for i in 0..<tmpArr.count {
            if i % 2 == 0 {
                resultArr.append(get16Bit(tmpArr[i], tmpArr[i+1]))
            }
        }

        return resultArr
    }

    func saveArrUInt8(_ inputArr : [UInt8]) {
        let outputStream = OutputStream(toFileAtPath: fileURL.path, append: false)!

        outputStream.open()
        outputStream.write(inputArr, maxLength: inputArr.count)
        outputStream.close()
    }

    func saveArrUInt16(_ inputArr : [UInt16]) {
        var resultArr: [UInt8] = []

        for int in inputArr {
            for i: UInt in [8,0] {
                let temp = (int >> i) & 255
                resultArr.append(UInt8(temp))
            }
        }

        saveArrUInt8(resultArr)
    }

    init(_ fileURL: URL) {
        self.fileURL = fileURL
    }
}
