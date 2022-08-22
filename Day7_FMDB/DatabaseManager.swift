//
//  DatabaseManager.swift
//  Day7_FMDB
//
//  Created by Chinh Ng on 09/06/2022.
//

import Foundation
import FMDB

fileprivate let DataBaseName = "StateInfo"
fileprivate let DataBaseType = "db"

class DatabaseManager {
    static var shared = DatabaseManager()
    var database: FMDatabase!
    
    init() {
        self.initDatabase()
    }
    
    // MARK: - State
    /// Lấy danh sách các bang trong database
    func getListStates() -> [State] {
        var states = [State]()
        openDB()
        guard let resultSet = getResultSet(query: "select * from StateInfo") else {
            closeDB()
            return []
        }
        
        while resultSet.next() {
            let obj = State.init(resultSet: resultSet)
            states.append(obj)
        }
        
        closeDB()
        return states
    }
}

extension DatabaseManager {
    
    /// Nhận một lệnh sql dưới dạng String rồi thực thi
    /// - Parameter query: lệnh sql muốn thực thi
    /// - Returns: trả về true khi lệnh được thực thi, false khi thực thi thất bại
    func excuteUpdate(query: String) -> Bool {
        openDB()
        let success = database!.executeStatements(query)
        closeDB()
        return success
    }
    
    func isExistRecord(query: String) -> Bool {
        openDB()
        let resultSet = try? database.executeQuery(query, values: nil)
        let rs = resultSet?.next() ?? false
        closeDB()
        return rs
    }
}

// MARK: - Private
private extension DatabaseManager {
    
    /// ???? khởi tạo database
    func initDatabase() {
        guard let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            print("document directory not found")
            return
        }
        
        let dataBaseFilePath = documentPath + "/" + DataBaseName + "." + DataBaseType
        print("databasePath = \(dataBaseFilePath)")
        if FileManager.default.fileExists(atPath: dataBaseFilePath) == false {
            try? FileManager.default.copyfileToUserDocumentDirectory(forResource: DataBaseName, ofType: DataBaseType)
        }
        database = FMDatabase.init(path: dataBaseFilePath)
        openDB()
        database.shouldCacheStatements = true
    }
    
    /// thực thi lệnh SQLite trả về FMResultSet, biểu diễn kết quả thực hiện truy vấn trên csdl FMDatabase
    func getResultSet(query: String) -> FMResultSet? {
        return try? database.executeQuery(query, values: nil)
    }
    
    /// mở kết nối db
    func openDB() {
        database.open()
    }
    
    /// ngắt kết nối db
    func closeDB() {
        database.close()
    }
}


extension FileManager {
    /// copy file trong sample.db tới Document dicrectory
    func copyfileToUserDocumentDirectory(forResource name: String,
                                         ofType fileExtension: String) throws
    {
        if let bundlePath = Bundle.main.path(forResource: name, ofType: fileExtension),
            let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                               .userDomainMask,
                                                               true).first {
            let fileName = "\(name).\(fileExtension)"
            let fullDestPath = URL(fileURLWithPath: destPath)
                .appendingPathComponent(fileName)
            let fullDestPathString = fullDestPath.path
            
            if !self.fileExists(atPath: fullDestPathString) {
                try self.copyItem(atPath: bundlePath, toPath: fullDestPathString)
            }
        }
    }
}
