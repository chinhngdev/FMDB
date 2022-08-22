//
//  State.swift
//  Day7_FMDB
//
//  Created by Chinh Ng on 09/06/2022.
//

import Foundation
import FMDB

struct State {
    var stateID: String = ""
    var stateName: String = ""
    var stateCode: String = ""
    
    init() { }
    
    init(resultSet: FMResultSet) {
        self.stateID = resultSet.string(forColumnIndex: 0) ?? ""
        self.stateName = resultSet.string(forColumnIndex: 1) ?? ""
        self.stateCode = resultSet.string(forColumnIndex: 2) ?? ""
    }
    
    /// thêm bản ghi mới vào database
    func insertToDB() {
        let query = "insert into StateInfo (stateID, stateName, stateCode) values ('\(stateID)', '\(stateName)', '\(stateCode)')"
        _ = DatabaseManager.shared.excuteUpdate(query: query)
    }
    
    /// xoá bản ghi trong database
    func delete() {
        let query = "delete from StateInfo where stateID = '\(self.stateID)'"
        _ = DatabaseManager.shared.excuteUpdate(query: query)
    }
    
    /// sửa bản ghi trong database
    func modify() {
        let query = "update StateInfo set stateName = '\(self.stateName)', stateCode = '\(self.stateCode)' where stateID = '\(self.stateID)'"
        _ = DatabaseManager.shared.excuteUpdate(query: query)
    }
}
