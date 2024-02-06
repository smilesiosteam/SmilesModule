import XCTest
@testable import DeviceAppCheck
import UIKit

public final class DeviceAppCheckTests: XCTestCase {
    
    func testDeviceCheckSupport() {
        XCTAssert(DeviceAppCheck.shared.isSupported(),"Device/App Attest is not supported")
    }
    
    func testDeviceAppAttestData(){
        guard DeviceAppCheck.shared.isSupported() else {
            XCTFail("Device/App Attest is not supported")
            return
        }
        DeviceAppCheck.shared.getSecurityData { deviceCheckToken, attestation, challange, error in
            if (deviceCheckToken == nil) && (attestation == nil) {
                XCTFail("Attestation data not returned")
            } else if deviceCheckToken == nil {
                XCTAssert(!(attestation?.isEmpty ?? true), "Wrong Attestation data size")
            } else if attestation == nil {
                XCTAssert(!(deviceCheckToken?.isEmpty ?? true), "Wrong Device Check Token size")
            } else {
                XCTFail("Attestation data not returned")
            }
        }
    }
    
    func testOSVersion(){
        if #available(iOS 14.0, *){
            return
        }else if #available(iOS 11.0, *){
            return
        }else{
            XCTFail("iOS version is not supported")
        }
    }
    
    func testGetAppAttestKeyID(){
        if #available(iOS 14.0, *) {
            let group = DispatchGroup()
            let queue = DispatchQueue(label: "com.etisalat.appAttest")
            group.enter()
            queue.async {
                AppAttestor.shared.getAppAttestKeyId { key, error in
                    guard error == nil else {
                        XCTFail("Key not found")
                        group.leave()
                        return
                    }
                    guard key != nil else {
                        XCTFail("Key not found")
                        group.leave()
                        return
                    }
                    group.leave()
                }
            }
            group.wait()
        } else {
            XCTFail("iOS version is not supported")
        }
    }
    
    func testGeneratingChallenge(){
        if #available(iOS 14.0, *) {
            XCTAssert(AppAttestor.shared.generateRandomBytes()?.count == 32,"Challenge not created successfully")
        } else {
            XCTFail("iOS version is not supported")
        }
    }
}
