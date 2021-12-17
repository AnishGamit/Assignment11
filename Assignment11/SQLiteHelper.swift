//
//  SQLiteHelper.swift
//  Assignment11
//
//  Created by DCS on 17/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import Foundation
import SQLite3

class SQLiteHandler {
    static let shared = SQLiteHandler()
    let dbpath = "studentdb.sqllite"
    var db:OpaquePointer?
    private init(){
        db = opendatabase()
        createtable()
    }
    private func opendatabase()->OpaquePointer?{
        let docurl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileurl = docurl.appendingPathComponent(dbpath)
        
        var database:OpaquePointer? = nil
        if sqlite3_open(fileurl.path,&database) == SQLITE_OK {
            print("Opened connection to the database successfully at: \(fileurl)")
            return database
        }else{
            print("error connecting to the database")
            return nil
        }
    }
    private func createtable(){
        let createTableString = """
            CREATE TABLE IF NOT EXISTS student(
                spid INTEGER PRIMARY KEY,
                sname TEXT,
                email TEXT,
                gender TEXT,
                password TEXT,
                course TEXT);
        """
        var creatTableStatement:OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &creatTableStatement, nil) == SQLITE_OK{
            if sqlite3_step(creatTableStatement)==SQLITE_DONE {
                print("student created")
            }else{
                print("student no created")
            }
        }else{
            print("student table not prepared")
        }
        sqlite3_finalize(creatTableStatement)
    }
    func delete(for id:Int, completion: @escaping ((Bool) -> Void)) {
        let deletestr = "delete from student where spid=?;"
        
        var deletest:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deletestr, -1, &deletest, nil) == SQLITE_OK {
            
            sqlite3_bind_int(deletest, 1, Int32(id))
            print("id is:\(id)")
            if sqlite3_step(deletest) == SQLITE_DONE {
                print("deleted")
                completion(true)
            } else {
                print("not deleted")
                completion(false)
            }
            
        } else {
            print("delete statement could not be prepared")
            completion(false)
        }
        sqlite3_finalize(deletest)
    }
    
    func insert(e:Student, completion: @escaping ((Bool) -> Void)) {
        let insertstr = "INSERT INTO student (spid,sname,email,gender,password,course) VALUES (?, ?, ? , ?, ?, ?);"
        
        var insertst:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertstr, -1, &insertst, nil) == SQLITE_OK {
            //int sqlite3_bind_text(sqlite3_stmt*,int,const char*,int,void(*)(void*));
            sqlite3_bind_int(insertst,  1, Int32(e.spid))
            sqlite3_bind_text(insertst, 2, (e.sname as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertst, 3, (e.email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertst, 4, (e.gen as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertst, 5, (e.pwd as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertst, 6, (e.course as NSString).utf8String, -1, nil)
            if sqlite3_step(insertst) == SQLITE_DONE {
                print("inserted")
                completion(true)
            } else {
                print("not inserted")
                completion(false)
            }
            
        } else {
            print("Insert statement could not be prepared")
            completion(false)
        }
        sqlite3_finalize(insertst)
    }
    func update(e:Student, completion: @escaping ((Bool) -> Void)) {
        let updatestr = "UPDATE student SET sname = ?, email = ?, gender = ?, password = ?, course = ? WHERE spid = ?;"
        
        var updatest:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updatestr, -1, &updatest, nil) == SQLITE_OK {
            //int sqlite3_bind_text(sqlite3_stmt*,int,const char*,int,void(*)(void*));
            sqlite3_bind_text(updatest, 1, (e.sname as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updatest, 2, (e.email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updatest, 3, (e.gen as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updatest, 4, (e.pwd as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updatest, 5, (e.course as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updatest,  6, Int32(e.spid))
            if sqlite3_step(updatest) == SQLITE_DONE {
                print("updated")
                completion(true)
            } else {
                print("not updated")
                completion(false)
            }
            
        } else {
            print("update statement could not be prepared")
            completion(false)
        }
        sqlite3_finalize(updatest)
    }
    func fetch() -> [Student] {
        let fetchstr = "SELECT * FROM student;"
        var stud = [Student]()
        var fetchst:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, fetchstr, -1, &fetchst, nil) == SQLITE_OK {
            
            
            while sqlite3_step(fetchst) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(fetchst, 0))
                let name =  String(cString: sqlite3_column_text(fetchst, 1))
                let email = String(cString: sqlite3_column_text(fetchst, 2))
                let gen = String(cString: sqlite3_column_text(fetchst, 3))
                let pwd = String(cString: sqlite3_column_text(fetchst, 4))
                let course = String(cString: sqlite3_column_text(fetchst, 5))
                stud.append(Student(spid: id, sname:name,email: email,gen: gen,pwd:pwd, course: course))
            }
            
        } else {
            print("fetch statement could not be prepared")
            
        }
        sqlite3_finalize(fetchst)
        return stud
    }
    func fetchCorseWise(e:Student, completion: @escaping ((Bool) -> Void)) -> [Student] {
        let fetchstr = "SELECT * FROM student where course = ?;"
        var stud = [Student]()
        var fetchst:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, fetchstr, -1, &fetchst, nil) == SQLITE_OK {
            sqlite3_bind_text(fetchst, 5, (e.course as NSString).utf8String, -1, nil)
          
            while sqlite3_step(fetchst) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(fetchst, 0))
                let name =  String(cString: sqlite3_column_text(fetchst, 1))
                let email = String(cString: sqlite3_column_text(fetchst, 2))
                let gen = String(cString: sqlite3_column_text(fetchst, 3))
                let pwd = String(cString: sqlite3_column_text(fetchst, 4))
                let course = String(cString: sqlite3_column_text(fetchst, 5))
                stud.append(Student(spid: id, sname:name,email: email,gen: gen,pwd:pwd, course: course))
            }
            
        } else {
            print("fetch statement could not be prepared")
            
        }
        sqlite3_finalize(fetchst)
        return stud
    }
}
