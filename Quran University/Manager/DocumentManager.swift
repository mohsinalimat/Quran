import Foundation

class DocumentManager {
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    
    static func initApplicationStructure() {
        createDirectory(folderPath: DirectoryStructure.Database)
        createDirectory(folderPath: DirectoryStructure.DefaultScript)
        createDirectory(folderPath: DirectoryStructure.DefaultAudio)
        createDirectory(folderPath: DirectoryStructure.TempRecordingRecitation)
        createDirectory(folderPath: DirectoryStructure.StudentAssignmentRecording)
        createDirectory(folderPath: DirectoryStructure.TeacherAssignmentRecording)
        
        copyFilesFromBundleForType(sourceFileType: BundleFileType.SQLite, targetPath: DirectoryStructure.Database)
        copyFilesFromBundleForType(sourceFileType: BundleFileType.MP3, targetPath: DirectoryStructure.DefaultAudio)
        copyFilesFromBundleForType(sourceFileType: BundleFileType.PNG, targetPath: DirectoryStructure.DefaultScript)
    }
    static func clearDirectory(folderPath: String) {
        let folderURL = documentsDirectory.appendingPathComponent(folderPath)
        
        if (try? folderURL.checkResourceIsReachable()) != nil {
            do {
                try FileManager.default.contentsOfDirectory(atPath: folderURL.path).lazy.forEach { fileName in
                    let targetFileURL = folderURL.appendingPathComponent(fileName)
                    
                    try FileManager.default.removeItem(atPath: targetFileURL.path)
                }
            }
            catch {
                fatalError("No \(folderURL) directory found in application bundle.")
            }
        }
    }
    static func createDirectory(folderPath: String) {
        let folderURL = documentsDirectory.appendingPathComponent(folderPath)
        
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
        let targetURL = documentsDirectory.appendingPathComponent(targetPath)
        
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
        let targetFileURL = documentsDirectory.appendingPathComponent(targetFilePath)
        var filePath = targetFileURL.path
        
        if (try? targetFileURL.checkResourceIsReachable()) == nil {
            filePath = ""
        }
        
        return filePath
    }
    static func getFileURLInApplicationDirectory(targetFilePath: String) -> URL {
        return documentsDirectory.appendingPathComponent(targetFilePath)
    }
    static func checkFilesExistForSurahAyatOrderRange(startSurahId: Int64, endSurahId: Int64, startAyatOrderId: Int64, endAyatOrderId: Int64) -> FileMissingMode {
        let pageList = PageRepository().getPageList(fromSurahId: startSurahId, toSurahId: endSurahId, startAyatOrderId: startAyatOrderId, endAyatOrderId: endAyatOrderId)
        var missingMode = FileMissingMode.None
        var scriptExist = true
        var audioExist = true
        
        for pageObject in pageList {
            let fileURL = DocumentManager.checkFileInApplicationDirectory(targetFilePath: ApplicationMethods.getPagePath(scriptId: ApplicationData.CurrentScript.Id, pageId: pageObject.Id))
            
            if fileURL == "" {
                scriptExist = false
                
                break
            }
        }
        
        let recitationList = RecitationRepository().getRecitationList(fromSurahId: startSurahId, toSurahId: endSurahId, fromAyatOrderId: startAyatOrderId, toAyatOrderId: endAyatOrderId)
        
        for recitationObject in recitationList {
            let fileURL = DocumentManager.checkFileInApplicationDirectory(targetFilePath: ApplicationMethods.getRecitationPath(reciterId: ApplicationData.CurrentReciter.Id, recitationName: recitationObject.RecitationFileName))
            
            if fileURL == "" {
                audioExist = false
                
                break
            }
        }
        
        if !scriptExist && !audioExist {
            missingMode = .All
        }
        else if !scriptExist {
            missingMode = .Script
        }
        else if !audioExist {
            missingMode = .Audio
        }
        
        return missingMode
    }
}
