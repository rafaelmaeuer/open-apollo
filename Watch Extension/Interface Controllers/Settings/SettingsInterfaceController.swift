//
//  SettingsInterfaceController.swift
//  Watch Extension
//
//  Created by Khaos Tian on 10/28/18.
//  Copyright © 2018 Oltica. All rights reserved.
//

import WatchKit
import Foundation

class SettingsInterfaceController: WKInterfaceController {

    @IBOutlet weak var shuffleSwitch: WKInterfaceSwitch!
    @IBOutlet weak var offlineSwitch: WKInterfaceSwitch!
    @IBOutlet weak var versionText: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        shuffleSwitch.setOn(UserPreferences.shuffle)
        offlineSwitch.setOn(UserPreferences.offline)
        
        let versionAndBuild = Bundle.versionAndBuild
        versionText.setText(versionAndBuild)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}

// MARK: - Storage

extension SettingsInterfaceController {
    
    @IBAction func didTapStorageButton() {
        pushController(withName: "Storage Settings", context: nil)
    }
}

// MARK: - Shuffle

extension SettingsInterfaceController {
    
    @IBAction func didToggleShuffle(_ value: Bool) {
        UserPreferences.shuffle = value
    }
    
    @IBAction func didToggleOffline(_ value: Bool) {
        UserPreferences.offline = value
        NotificationCenter.default.post(name: .appStateOfflineChange, object: nil)
    }
}

// MARK: - Update

extension NSNotification.Name {
    
    public static let appStateOfflineChange = NSNotification.Name("AppStateOfflineChanged")
}

// MARK: - App Version
public extension Bundle {

    static var version: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    static var build: String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }

    static var versionAndBuild: String? {
        guard let version = Bundle.version,
              let build = Bundle.build else {
            return nil
        }
        return version == build ? "v\(version)" : "v\(version) (b\(build))"
    }
}
