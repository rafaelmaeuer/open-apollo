//
//  StorageSettingsInterfaceController.swift
//  Watch Extension
//
//  Created by Khaos Tian on 11/4/18.
//  Copyright © 2018 Oltica. All rights reserved.
//

import WatchKit
import SpotifyServices

class StorageSettingsInterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

    @IBAction func didTapDeleteCache() {
        LocalStorageManager.shared.evictTemporaryStorage()
        showPopup(context: "Cache")
    }
    
    @IBAction func didTapDeleteDownload() {
        LocalStorageManager.shared.evictDownloadStorage()
        showPopup(context: "Downloads")
    }
    
    func showPopup(context: String){

        let text = context + " deleted"
        let h0 = { print(text) }
        let action = WKAlertAction(title: "Ok", style: .cancel, handler:h0)

        presentAlert(withTitle: "Success", message: "\n" + text, preferredStyle: .actionSheet, actions: [action])
    }
}
