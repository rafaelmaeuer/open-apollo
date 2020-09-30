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
        let text = "\n" + context + (success ? " deleted" : " deletion failed")
        let action = WKAlertAction.init(title: "Ok", style: .default, handler: {
            print("Dismissed")
        })

        WKExtension.shared().visibleInterfaceController?.presentAlert(withTitle: title, message: text, preferredStyle: .alert, actions: [action])
    }
}
