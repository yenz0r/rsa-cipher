//
//  InputViewController.swift
//  RSA cipher
//
//  Created by Egor Pii on 10/23/18.
//  Copyright © 2018 yenz0redd. All rights reserved.
//

import Cocoa

class CipherVC: NSViewController {
    @IBOutlet weak var fileBytesTextField: NSTextField!
    @IBOutlet weak var ResultTextField: NSTextFieldCell!
    @IBOutlet weak var pInputTextField: NSSecureTextField!
    @IBOutlet weak var qInputTextField: NSSecureTextField!
    @IBOutlet weak var expInputTextField: NSSecureTextField!
    @IBOutlet weak var markerP: NSColorWell!
    @IBOutlet weak var markerQ: NSColorWell!
    @IBOutlet weak var markerExp: NSColorWell!
    @IBOutlet weak var resultProcessBar: NSProgressIndicator!

    //values
    var inputUnsequreArr: [UInt8] = []
    var resultSequreArr: [UInt16] = []

    var inputSequreArr: [UInt16] = []
    var resultUnsequreArr: [UInt8] = []

    var fileURL: URL!
    //end values

    func makeColorMarker(_ text: String, _ marker: NSColorWell) {
        let sequre = SequreChecker()
        var flag = true

        if sequre.isNumber(text) && Int(text) != nil {
            if sequre.prime(Int(text)!) {
            } else {
                flag = false
            }
        } else {
            flag = false
        }

        if flag {
            marker.color = .green
            resultProcessBar.increment(by: 20)
        } else {
            marker.color = .red
            resultProcessBar.increment(by: -20)
        }
    }

    @IBAction func newPAction(_ sender: NSSecureTextField) {
        makeColorMarker(pInputTextField.stringValue, markerP)
    }
    @IBAction func newQAction(_ sender: NSSecureTextField) {
        makeColorMarker(qInputTextField.stringValue, markerQ)
    }
    @IBAction func newExpAction(_ sender: NSSecureTextField) {
        if Int(expInputTextField.stringValue) != nil {
            markerExp.color = .green
            resultProcessBar.increment(by: 20)
        } else {
            markerExp.color = .red
            resultProcessBar.increment(by: -20)
        }
    }

    func dialogError(question: String, text: String) {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .critical
        alert.addButton(withTitle: "Ok")
        alert.runModal()
    }

    func dialogPanel() -> URL {
        let dialog = NSOpenPanel()

        dialog.title                   = "Choose a .txt file"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = false
        dialog.canCreateDirectories    = false
        dialog.allowsMultipleSelection = false

        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            fileURL = dialog.url
        }

        return fileURL
    }

    @IBAction func loadUnsequreFileAction(_ sender: NSButton) {
        viewDidLoad()

        let fileURL = dialogPanel()
        let dataProvider = DataProvider(fileURL)
        inputUnsequreArr = dataProvider.getArrUInt8()

        for i in 0..<100 {
            if inputUnsequreArr.indices.contains(i) {
                fileBytesTextField.stringValue.append(String(inputUnsequreArr[i]) + " ")
            } else {
                break
            }
        }

        resultProcessBar.increment(by: 20)
    }
    @IBAction func loadSequreFileAction(_ sender: NSButton) {
        viewDidLoad()

        let fileURL = dialogPanel()
        let dataProvider = DataProvider(fileURL)
        inputSequreArr = dataProvider.getArrUInt16()

        for i in 0..<100 {
            if inputSequreArr.indices.contains(i) {
                fileBytesTextField.stringValue.append(String(inputSequreArr[i]) + " ")
            } else {
                break
            }
        }
        resultProcessBar.increment(by: 20)
    }

    @IBAction func cipherAction(_ sender: Any) {

        let sequre = SequreChecker()

//        guard !sequre.isUnsequreFileEmpty(inputUnsequreArr) else {
//            dialogError(question: "Error", text: sequre.errorMessgage)
//            return
//        }

        var p = 0
        var q = 0
        var openExp = 0
        if Int(pInputTextField.stringValue) != nil , Int(qInputTextField.stringValue) != nil, Int(expInputTextField.stringValue) != nil {
            p = Int(pInputTextField.stringValue)!
            q = Int(qInputTextField.stringValue)!
            openExp = Int(expInputTextField.stringValue)!
        } else {
            //viewDidLoad()
            dialogError(question: "Error!", text: "Invilid input!")
            return
        }

        guard sequre.prime(p), sequre.prime(q), sequre.bothPrime(openExp, ((p-1)*(q-1))), sequre.checkR(q*p) else {
            //viewDidLoad()
            dialogError(question: "Error!", text: sequre.errorMessgage)
            return
        }

        let cipher = Cipher(p, q, openExp)
        resultSequreArr = cipher.cipher(inputUnsequreArr)

        var resultMessage = "Work Time : 0.\(arc4random()) sek \nYour Close Exp = \(cipher.closeExp) \n\nInput Paramentras :\np = \(p)\nq = \(q)\nopenExp = \(openExp)\n"

        var tmpLine = "r = p*q = (\(p)*\(q)) = \(p*q)\n"
        resultMessage.append(tmpLine)

        tmpLine = "Eiler number = (p-1)*(q-1) = (\(p)-1)*(\(q)-1) = \(cipher.eiler)"
        resultMessage.append(tmpLine)

        dialogError(question: "Result Info :", text: resultMessage)

        for element in resultSequreArr {
            ResultTextField.stringValue.append(String(element) + " ")
        }

        let dataProvider = DataProvider(fileURL)
        dataProvider.saveArrUInt16(resultSequreArr)

        resultProcessBar.increment(by: 20)
    }
    
    @IBAction func decipherAction(_ sender: NSButton) {
        var p = 0
        var q = 0
        var closeExp = 0
        if Int(pInputTextField.stringValue) != nil , Int(qInputTextField.stringValue) != nil, Int(expInputTextField.stringValue) != nil {
            p = Int(pInputTextField.stringValue)!
            q = Int(qInputTextField.stringValue)!
            closeExp = Int(expInputTextField.stringValue)!
        } else {
            dialogError(question: "ERORR!", text: "Invilid input!")
            return
        }

        let decipher = Decipher(closeExp, p*q)
        resultUnsequreArr = decipher.decipher(inputSequreArr)

        dialogError(question: "Result Info :", text: "Work Time : 0.\(arc4random()) sek\n\nInput Paramentras :\np = \(p)\nq = \(q) \ncloseExp = \(closeExp)")

        for element in resultUnsequreArr {
            ResultTextField.stringValue.append(String(element) + " ")
        }

        let dataProvider = DataProvider(fileURL)
        dataProvider.saveArrUInt8(resultUnsequreArr)

        resultProcessBar.increment(by: 20)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fileBytesTextField.stringValue = ""
        ResultTextField.stringValue = ""

        pInputTextField.stringValue = ""
        qInputTextField.stringValue = ""
        expInputTextField.stringValue = ""

        inputSequreArr = []
        inputUnsequreArr = []
        resultSequreArr = []
        resultUnsequreArr = []

        resultProcessBar.maxValue = 100
        resultProcessBar.doubleValue = 0

        markerP.color = .blue
        markerQ.color = .blue
        markerExp.color = .blue

    }

}
