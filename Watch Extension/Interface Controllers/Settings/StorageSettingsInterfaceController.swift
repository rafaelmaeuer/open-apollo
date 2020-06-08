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
        let deleted:Bool = LocalStorageManager.shared.evictTemporaryStorage()
        showPopup(context: "Cache", success:deleted)
    }
    
    @IBAction func didTapDeleteDownload() {
        let deleted:Bool = LocalStorageManager.shared.evictDownloadStorage()
        showPopup(context: "Downloads", success:deleted)
    }
    
    func showPopup(context: String, success: Bool){

        let title = success ? "Success" : "Error"
        let text = context + (success ? " deleted" : " deletion failed")
        let h0 = { print(text) }
        let action = WKAlertAction(title: "Ok", style: .cancel, handler:h0)

        presentAlert(withTitle: title, message: "\n" + text, preferredStyle: .actionSheet, actions: [action])
    }
}
