//
//  DecipherVC.swift
//  RSA cipher
//
//  Created by Egor Pii on 10/31/18.
//  Copyright © 2018 yenz0redd. All rights reserved.
//

import Cocoa

class DecipherVC: NSViewController {

    var inputArr: [UInt16] = []

    @IBAction func loadFileAction(_ sender: NSButton) {
        let dialog = NSOpenPanel()

        dialog.title                   = "Choose a .txt file"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = false
        dialog.canCreateDirectories    = false
        dialog.allowsMultipleSelection = false
        //dialog.allowedFileTypes        = ["txt", ""]

        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let fileURL = dialog.url

            let dataProvider = DataProvider(fileURL!)
            inputArr = dataProvider.getArrUInt16()
        }

        for element in inputArr {
            //fileBytesTextField.stringValue.append(String(element) + " ")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
