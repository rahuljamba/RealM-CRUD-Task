//
//  DatabaseManager.swift
//  JarvisTask
//
//  Created by Apple on 14/02/25.
//

import Foundation
import UIKit
import RealmSwift

class DatabaseManager {
    private var realm: Realm
    
    init() {
        // Initialize Realm
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
    
    // MARK: - Generic CRUD Operations
    
    // Create or Update
    func save<T: Object>(_ object: T, completionHandler:(_ status: Bool)->Void) {
        do {
            try realm.write {
                realm.add(object, update: .modified)
                completionHandler(true)
            }
        } catch {
            print("Failed to save object: \(error)")
            completionHandler(false)
        }
    }
    
    // Save file in local file manager
    func saveImageToFileSystem(image: UIImage, name: String) -> String? {
        guard let imageData = image.pngData() else {
            print("Failed to convert image to Data")
            return nil
        }
        
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("\(UUID().uuidString).png")
        
        do {
            try imageData.write(to: fileURL)
            return fileURL.path
        } catch {
            print("Failed to save image to file system: \(error)")
            return nil
        }
    }
    
    // Read (Fetch All Objects)
    func fetchAll<T: Object>(_ type: T.Type) -> [T] {
        let results = realm.objects(type)  // Realm Results<>
        return Array(results)  // ✅ Convert to Array<T>
    }
    
    // Read images
    
    func fetchImageFromFileSystem(path: String) -> UIImage? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let fileName = (path as NSString).lastPathComponent
        let fileURL = documentsDirectory.appendingPathComponent(fileName)


        // ✅ Check if file exists
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                let imageData = try Data(contentsOf: fileURL)
                return UIImage(data: imageData)
            } catch {
                print("🚨 Failed to fetch image from file system: \(error)")
                return nil
            }
        } else {
            print("🚨 File does not exist at path: \(fileURL.path)")
            return nil
        }
    }

    func updateObject<T: Object>(ofType type: T.Type, byId objectId: ObjectId, update object: T, completionHandler: (_ status: Bool) -> Void) {
    
        // ✅ Fetch existing object dynamically
        guard let existingObject = realm.object(ofType: type, forPrimaryKey: objectId) else {
            print("\(T.self) with ID \(objectId) not found ❌")
            completionHandler(false)
            return
        }

        do {
            try realm.write {
                realm.add(object, update: .modified)  // ✅ Update full object safely
                completionHandler(true)
            }
        } catch {
            print("Failed to update \(T.self): \(error) ❌")
            completionHandler(false)
        }
    }

}
