//
//  ViewController.swift
//  SqlLite
//
//  Created by Muna Abdelwahab on 3/17/21.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var imageText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    
    var file: URL?
    var path: String?
    var db: OpaquePointer?
    var createTableStatement: OpaquePointer?
    var insertStatement : OpaquePointer?
    var queryStatement : OpaquePointer?
    var deleteStatement :OpaquePointer?
    var updateStatement : OpaquePointer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        file = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        path = file?.appendingPathComponent("swift10.sqlite").relativePath
        if sqlite3_open(path, &db) == SQLITE_OK {
            print("DB opened")
            let createTableString = "CREATE TABLE IF NOT EXISTS Friends ( ID INT PRIMARY KEY NOT NULL , NAME CHAR (255) , IMAGE CHAR (255) , PHONE CHAR (255) , AGE CHAR (255));"
            if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
                if sqlite3_step(createTableStatement) == SQLITE_DONE {
                    print( "Contact table created")
                } else {
                    print("Contatct table is not created")
                }
                
            } else {
                print("create Table statment is not prepared")
            }
        } else {
            print("failed to open")
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        if sqlite3_open(path,&db) == SQLITE_OK {
            let insertString = "INSERT INTO Friends (ID,NAME,IMAGE,PHONE,AGE) VALUES (?,?,?,?,?)"
            
            if sqlite3_prepare_v2(db, insertString, -1, &insertStatement, nil) == SQLITE_OK {
                
                let name:NSString = nameText.text! as NSString
                let image:NSString = imageText.text! as NSString
                let phone:NSString = phoneText.text! as NSString
                let age:Int = Int(ageText.text!)!
                let id:Int = Int(idText.text!)!
                
                sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, image.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, phone.utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 1, Int32(id))
                sqlite3_bind_int(insertStatement, 5, Int32(age))
                
                if sqlite3_step(insertStatement) == SQLITE_DONE{
                    print("successfully inserted Row ")
                }else{
                    print("couldn't insert row")
                }
            }else{
                print("failed To open")
            }
            idText.text = ""
            nameText.text = ""
            imageText.text = ""
            ageText.text = ""
            phoneText.text = ""
        }
    }
    
    @IBAction func listButton(_ sender: Any) {
        let data = self.storyboard?.instantiateViewController(identifier: "dataVC") as! MyTableViewController
        
        var friendarray : [Friend] = []
        if sqlite3_open(path,&db) == SQLITE_OK {
            let queryString = " SELECT * FROM  Friends"
            if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let friendArr = Friend()
                    let id = sqlite3_column_int(queryStatement, 0)
                    if let nRes = sqlite3_column_text(queryStatement, 1) {
                        let name = String(cString: nRes)
                        friendArr.id = Int(id)
                        friendArr.name = name
                    } else {
                        print("Query result is nil")
                        return
                    }
                    if let iRes = sqlite3_column_text(queryStatement, 2) {
                        let image = String(cString: iRes)
                        friendArr.image = image
                    } else {
                        print("Query result is nil")
                        return
                    }
                    if let pRes = sqlite3_column_text(queryStatement, 3) {
                        let phone = String(cString: pRes)
                        friendArr.phone = phone
                    } else {
                        print("Query result is nil")
                        return
                    }
                    let age = sqlite3_column_int64(queryStatement, 4)
                    friendArr.age = age
                    //print(friendArr.name!)
                    friendarray.append(friendArr)
                    
                }
                //friendarray.append(friendArr)
                print(friendarray.count)
                //print(friendarray[0].name!)
                data.friend.append(contentsOf: friendarray)
            } /*else {
                print("query returned no results (EMPTY).")
            }*/
        } else {
            print("query is not prepared")
        }
        
        navigationController?.pushViewController(data, animated: true)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        let deleteString = " DELETE FROM Friends WHERE ID = " + idText.text! + ";"
        if sqlite3_prepare_v2(db, deleteString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("successfuly deleted row")
            }else{
                print("couldnt delete row")
            }
        }else{
            print("delete statement couldnt be prepared")
        }
    }
    
    @IBAction func displayButton(_ sender: Any) {
        let updateString = " UPDATE Friends SET NAME = '" + nameText.text! + "' WHERE ID = " + idText.text! + "; "
                
        if sqlite3_prepare_v2(db, updateString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE{
                print("Successfuly update Row ")
            }else{
                print("couldn't update row")
            }
        }else{
            print("update statement is not prepared")
        }
    }

}

