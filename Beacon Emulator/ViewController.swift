//
//  ViewController.swift
//  Beacon Emulator
//
//  Created by Patryk Romańczuk on 21/12/2016.
//  Copyright © 2016 AviadorApps. All rights reserved.
//

import UIKit
import QuartzCore
import CoreLocation
import CoreBluetooth


class ViewController: UIViewController, CBPeripheralManagerDelegate {
    @IBOutlet weak var uuidInput: UITextField!
    
    @IBOutlet weak var majorInput: UITextField!
    
    @IBOutlet weak var minorInput: UITextField!
    
    @IBOutlet weak var bluetoothStatus: UILabel!
    
    @IBOutlet weak var broadcastIndicator: BroadcastIndicator!
    
    var bluetoothPeripheralManager : CBPeripheralManager!
    
    var isBroadcasting : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        
        
        uuidInput.text = UUID().uuidString
        minorInput.text = String(arc4random_uniform(100))
        majorInput.text = String(arc4random_uniform(999) + 1000)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func boardcastToggle(_ sender: Any) {
        if !isBroadcasting {
            guard let minorInput = minorInput.text,
                let majorInput = majorInput.text,
                let uuidInput = uuidInput.text
                else {
                    return
            }
            
            let major: CLBeaconMajorValue? = UInt16(majorInput)
            let minor: CLBeaconMinorValue? = UInt16(minorInput)
            let uuid = UUID(uuidString: uuidInput)
            
            guard let majorVal = major,
                let minorVal = minor,
                let uuidVal = uuid
                else {
                    return
            }
            
            let beaconRegion = CLBeaconRegion(proximityUUID: uuidVal,
                                              major: majorVal,
                                              minor: minorVal,
                                              identifier: "com.AviadorApps.Beacon-Emulator")
            
            let dataDictionary = beaconRegion.peripheralData(withMeasuredPower: nil)
            
            bluetoothPeripheralManager.startAdvertising(dataDictionary as? [String:AnyObject])
            
            animateIndicator()
            
            isBroadcasting = true
        }
        else {
            bluetoothPeripheralManager.stopAdvertising()
            
            broadcastIndicator.layer.removeAllAnimations()
            broadcastIndicator.layer.transform = CATransform3DIdentity
            isBroadcasting = false
        }
    }
    
    @IBAction func randomizeUUID(_ sender: Any) {
        uuidInput.text = UUID().uuidString
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            bluetoothStatus.text = "ON"
        case .poweredOff:
            bluetoothStatus.text = "OFF"
        case .resetting:
            bluetoothStatus.text = "Resetting"
        case .unauthorized:
            bluetoothStatus.text = "Unauthorized"
        case .unknown:
            bluetoothStatus.text = "Unknown"
        case .unsupported:
            bluetoothStatus.text = "Unsupported"
            bluetoothStatus.textColor = UIColor.red;
        default:
            return
        }
    }
    
    func animateIndicator() {
        UIView.animate(withDuration: 1,
                       delay:0.0,
                       options: [.repeat , .curveEaseInOut, .autoreverse, .allowUserInteraction] ,
                       animations: { () -> Void in
            self.broadcastIndicator.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        })
    }
}

