import Foundation

class DocumentManager {
    static func createDirectory(folderPath: String) {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("No document directory found in application bundle.")
        }
        
        let folderURL = documentURL.appendingPathComponent(folderPath)
        
        if (try? folderURL.checkResourceIsReachable()) == nil {
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                fatalError("No \(folderURL) directory found in application bundle.")
            }
        }
    }
    static func copyFileFromBundle(sourceFileName: String, sourceFileExtension: String, targetFileURL: URL) {
        if (try? targetFileURL.checkResourceIsReachable()) == nil {
            guard let sourceFilePath = Bundle.main.url(forResource: sourceFileName, withExtension: sourceFileExtension) else {
                fatalError("No \(sourceFileName).\(sourceFileExtension) file found in application bundle.")
            }
            
            do {
                let contents = try Data(contentsOf: sourceFilePath)
                
                try contents.write(to: targetFileURL, options: .atomic)
            }
            catch {
                fatalError("No \(sourceFilePath) file found in application bundle.")
            }
        }
    }
    static func copyFilesFromBundleForType(sourceFileType: String, targetPath: String) {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("No document directory found in application bundle.")
        }
        
        let targetURL = documentURL.appendingPathComponent(targetPath)
        
        if (try? targetURL.checkResourceIsReachable()) != nil {
            do {
                try FileManager.default.contentsOfDirectory(atPath: Bundle.main.bundlePath).lazy.filter { $0.contains(sourceFileType) }.forEach { fileName in
                    let targetFileURL = targetURL.appendingPathComponent(fileName)
                    let arrFile = fileName.split(separator: ".")
                    
                    copyFileFromBundle(sourceFileName: String(arrFile[0]), sourceFileExtension: String(arrFile[1]), targetFileURL: targetFileURL)
                }
            }
            catch {
                fatalError("Error in copyAllFiles().")
            }
        }
    }
    
    static func copyFileFromBundle(sourceFileName: String, sourceFileExtension: String, targetFilePath: String) -> String {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("No document directory found in application bundle.")
        }
        
        let targetFileURL = documentsDirectory.appendingPathComponent(targetFilePath)
        
        if (try? targetFileURL.checkResourceIsReachable()) == nil {
            guard let sourceFilePath = Bundle.main.url(forResource: sourceFileName, withExtension: sourceFileExtension) else {
                fatalError("No \(sourceFileName).\(sourceFileExtension) file found in application bundle.")
            }
            
            do {
                let contents = try Data(contentsOf: sourceFilePath)
            
                try contents.write(to: targetFileURL, options: .atomic)
            }
            catch {
                fatalError("No \(sourceFilePath) file found in application bundle.")
            }
        }
        
        return targetFileURL.path
    }
    static func createFileInApplicationDirectory(contents: Data, targetFilePath: String) -> String {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("No document directory found in application bundle.")
        }
        
        let targetFileURL = documentsDirectory.appendingPathComponent(targetFilePath)
        
        if (try? targetFileURL.checkResourceIsReachable()) == nil {
            do {
                try contents.write(to: targetFileURL, options: .atomic)
            }
            catch {
                fatalError("No \(targetFileURL.path) file saved in application bundle.")
            }
        }
        
        return targetFileURL.path
    }
    static func checkFileInApplicationDirectory(targetFilePath: String) -> String {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("No document directory found in application bundle.")
        }
        
        let targetFileURL = documentsDirectory.appendingPathComponent(targetFilePath)
        var filePath = targetFileURL.path
        
        if (try? targetFileURL.checkResourceIsReachable()) == nil {
            filePath = ""
        }
        
        return filePath
    }
    static func getFileURLInApplicationDirectory(targetFilePath: String) -> URL {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("No document directory found in application bundle.")
        }
        
        return documentsDirectory.appendingPathComponent(targetFilePath)
    }
    static func checkFilesExistForSurahAyatOrderRange(startSurahId: Int64, endSurahId: Int64, startAyatOrderId: Int64, endAyatOrderId: Int64) -> Bool {
        let pageList = PageRepository().getPageList(fromSurahId: startSurahId, toSurahId: endSurahId)
        var status = true;
        
        for pageObject in pageList {
            let fileURL = DocumentManager.checkFileInApplicationDirectory(targetFilePath: ApplicationMethods.getPagePath(scriptId: ApplicationData.CurrentScript.Id, pageId: pageObject.Id))
            
            if fileURL == "" {
                status = false
                
                break
            }
        }
        
        if status == true {
            let recitationList = RecitationRepository().getRecitationList(fromSurahId: startSurahId, toSurahId: endSurahId, fromAyatOrderId: startAyatOrderId, toAyatOrderId: endAyatOrderId)
            
            for recitationObject in recitationList {
                let fileURL = DocumentManager.checkFileInApplicationDirectory(targetFilePath: ApplicationMethods.getRecitationPath(reciterId: ApplicationData.CurrentReciter.Id, recitationName: recitationObject.RecitationFileName))
                
                if fileURL == "" {
                    status = false
                    
                    break
                }
            }
        }
        
        return status
    }
    
    static func initApplicationStructure() {
        createDirectory(folderPath: DirectoryStructure.Database)
        createDirectory(folderPath: DirectoryStructure.DefaultScript)
        createDirectory(folderPath: DirectoryStructure.DefaultAudio)
        
        copyFilesFromBundleForType(sourceFileType: BundleFileType.SQLite, targetPath: DirectoryStructure.Database)
        copyFilesFromBundleForType(sourceFileType: BundleFileType.MP3, targetPath: DirectoryStructure.DefaultAudio)
        copyFilesFromBundleForType(sourceFileType: BundleFileType.PNG, targetPath: DirectoryStructure.DefaultScript)
    }
}
