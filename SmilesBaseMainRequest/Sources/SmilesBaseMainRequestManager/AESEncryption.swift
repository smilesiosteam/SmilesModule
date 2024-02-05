//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 18/10/2023.
//

import Foundation
import CommonCrypto

@objc public class AESEncryption: NSObject {

    // MARK: - Value
    // MARK: Private
    private let key: Data
    private let iv: Data


    // MARK: - Initialzier
    @objc public init?(key: String, iv: String) {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
            debugPrint("Error: Failed to set a key.")
            return nil
        }

        guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
            debugPrint("Error: Failed to set an initial vector.")
            return nil
        }


        self.key = keyData
        self.iv  = ivData
    }


    // MARK: - Function
    // MARK: Public
    @objc public func encrypt(string: String) -> Data? {
        return crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
    }

    @objc public func decrypt(data: Data?) -> String? {
        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
        return String(bytes: decryptedData, encoding: .utf8)
    }

    @objc public func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }

        let cryptLength = data.count + kCCBlockSizeAES128
        var cryptData   = Data(count: cryptLength)

        let keyLength = key.count
        let options   = CCOptions(kCCOptionPKCS7Padding)

        var bytesLength = Int(0)

        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                    CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
                    }
                }
            }
        }

        guard UInt32(status) == UInt32(kCCSuccess) else {
            debugPrint("Error: Failed to crypt data. Status \(status)")
            return nil
        }

        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
    
    
    @objc public func encryptDataWithNewHash(stringToHash:String) -> String? {
        let initVector = "NSHG5tytimVCPPzx"
        
        guard let secretKeyData = Data(base64Encoded: "/cD69bFaHIFE7V+n6rQtaM2YILyK2c1iYNIJqjSD/BY=") else {
            return nil
        }
        
        var cryptor: CCCryptorRef?
        var status = CCCryptorCreateWithMode(CCOperation(kCCEncrypt),
                                             CCMode(kCCModeCBC),
                                             CCAlgorithm(kCCAlgorithmAES),
                                             CCPadding(ccPKCS7Padding),
                                             (initVector as NSString).utf8String,
                                             (secretKeyData as NSData).bytes,
                                             secretKeyData.count,
                                             nil,
                                             0,
                                             0,
                                             CCModeOptions(kCCModeOptionCTR_BE),
                                             &cryptor)
        
        if status != kCCSuccess {
            // handle error
            return nil
        }
        
        let dataToEncrypt = stringToHash.data(using: .utf8)!
        let bufferSize = CCCryptorGetOutputLength(cryptor!,
                                                  dataToEncrypt.count,
                                                  true)
        let buffer = UnsafeMutableRawPointer.allocate(byteCount: bufferSize,
                                                       alignment: MemoryLayout<UInt8>.alignment)
        var encryptedLength = 0
        
        status = CCCryptorUpdate(cryptor!,
                                 (dataToEncrypt as NSData).bytes,
                                 dataToEncrypt.count,
                                 buffer,
                                 bufferSize,
                                 &encryptedLength)
        
        if status != kCCSuccess {
            // handle error
            CCCryptorRelease(cryptor!)
            buffer.deallocate()
            return nil
        }
        
        var finalSize = 0
        status = CCCryptorFinal(cryptor!,
                                buffer.advanced(by: encryptedLength),
                                bufferSize - encryptedLength,
                                &finalSize)
        
        if status != kCCSuccess {
            // handle error
            CCCryptorRelease(cryptor!)
            buffer.deallocate()
            return nil
        }
        
        let encryptedData = Data(bytesNoCopy: buffer,
                                 count: encryptedLength + finalSize,
                                 deallocator: .free)
        
        let encryptedStr = encryptedData.base64EncodedString()
        
        CCCryptorRelease(cryptor!)
        
        return encryptedStr
    }

}
