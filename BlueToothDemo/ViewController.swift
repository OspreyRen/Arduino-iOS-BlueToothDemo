//
//  ViewController.swift
//  BlueToothDemo
//
//  Created by ospreyren on 3/27/16.
//  Copyright © 2016 ospreyren. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var tempLabel: UILabel!

    private lazy var btManager = DFBlunoManager.sharedInstance() as! DFBlunoManager
    private var device: DFBlunoDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btManager.delegate = self
    }

    @IBAction private func ledSwitchChanged(sender: UISwitch) {
        if sender.on {
            btManager.writeDataToDevice("1".dataUsingEncoding(NSASCIIStringEncoding), device: device)
        } else {
            btManager.writeDataToDevice("0".dataUsingEncoding(NSASCIIStringEncoding), device: device)
        }
    }
}

extension ViewController: DFBlunoDelegate {
    func bleDidUpdateState(bleSupported: Bool) {
        if bleSupported {
            btManager.scan()
            print("scan device")
            navigationItem.title = "连接中..."
        }
    }

    func didDiscoverDevice(dev: DFBlunoDevice!) {
        if dev.identifier == "874ED35E-46BE-E52E-6784-A49C0E4D16BA" {
            btManager.connectToDevice(dev)
            print("connencting device")
        }
    }

    func readyToCommunicate(dev: DFBlunoDevice!) {
        device = dev
        print("connected device")
        navigationItem.title = "已连接"
    }

    func didDisconnectDevice(dev: DFBlunoDevice!) {
        device = nil
        print("disconnect device")
        navigationItem.title = "已断开"
    }

    func didWriteData(dev: DFBlunoDevice!) {
        print("sending data")
    }

    func didReceiveData(data: NSData!, device dev: DFBlunoDevice!) {
        tempLabel.text = String(data: data, encoding: NSASCIIStringEncoding)! + "º"
    }
}
