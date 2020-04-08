//
//  AppDelegate.swift
//  Bluesnooze
//
//  Created by Oliver Peate on 07/04/2020.
//  Copyright © 2020 Oliver Peate. All rights reserved.
//

import Cocoa
import IOBluetooth
import LaunchAtLogin

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var launchAtLoginMenuItem: NSMenuItem!

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        initStatusItem()
        setLaunchAtLoginState()
        NSWorkspace.shared.notificationCenter.addObserver(
            self, selector: #selector(onSleepNote(note:)), name: NSWorkspace.willSleepNotification, object: nil
        )
        NSWorkspace.shared.notificationCenter.addObserver(
            self, selector: #selector(onWakeNote(note:)), name: NSWorkspace.didWakeNotification, object: nil
        )
    }

    // MARK: Click handlers

    @IBAction func launchAtLoginClicked(_ sender: NSMenuItem) {
        LaunchAtLogin.isEnabled = !LaunchAtLogin.isEnabled
        setLaunchAtLoginState()
    }

    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    // MARK: Notification handlers

    @objc func onSleepNote(note: NSNotification) {
        setBluetooth(powerOn: false)
    }

    @objc func onWakeNote(note: NSNotification) {
        setBluetooth(powerOn: true)
    }

    private func setBluetooth(powerOn: Bool) {
        IOBluetoothPreferenceSetControllerPowerState(powerOn ? 1 : 0)
    }

    // MARK: UI state

    private func initStatusItem() {
        if let icon = NSImage(named: "bluesnooze") {
            icon.isTemplate = true
            statusItem.button?.image = icon
        } else {
            statusItem.button?.title = "Bluesnooze"
        }
        statusItem.menu = statusMenu
    }

    private func setLaunchAtLoginState() {
        let state = LaunchAtLogin.isEnabled ? NSControl.StateValue.on : NSControl.StateValue.off
        launchAtLoginMenuItem.state = state
    }
}
