//
//  LocalFileManager.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 19/04/24.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    
    private init() {    }
    
    
    func saveImage(image: UIImage, folderName: String, imageName: String) {
        
        // creating folder
        createFolderIfNeeded(folderName: folderName)
        
        // get path for image
        guard
            let imageData = image.pngData(),
            let url = getImagePath(imageName: imageName, folderName: folderName) else { return }
        
        // save image to FM
        do {
            try imageData.write(to: url)
        } catch let error {
            print("Error Saving Image. \(imageName), \(error)")
        }
    }
    
    func getImage(folderName: String, imageName: String) -> UIImage? {
        guard
            let url = getImagePath(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path())
        else { return nil }
        
        return UIImage(contentsOfFile: url.path())
    }

    private func createFolderIfNeeded(folderName: String) {
        guard let url = getFolderPath(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path()) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                print("success Creating Folder")
            } catch let error {
                print("Failed To Creating A Folder. \(folderName), \(error)")
            }
        }
    }
    
    private func getFolderPath(folderName: String) -> URL? {
        // ../Folder_Name
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return url.appending(path: folderName, directoryHint: .isDirectory)
    }
    
    private func getImagePath(imageName: String, folderName: String) -> URL? {
        // ../Folder_Name
        // ../Folder_Name/ImageName.png

        guard let folder = getFolderPath(folderName: folderName) else { return nil }
        return folder.appending(path: imageName + ".png", directoryHint: .notDirectory)
    }
}
