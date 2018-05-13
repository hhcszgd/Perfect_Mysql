//
//  DataBaseManager.swift
//  COpenSSL
//
//  Created by WY on 2018/5/13.
//

import Foundation

import PerfectHTTP
import PerfectHTTPServer

import PerfectMySQL
private let servername = "127.0.0.1"
private let username = "root"
private let password = "123123"
private let dbName = "songDB"
class DataBaseManager  {
    static func fetchData() {
        let mysql = MySQL() // 创建一个MySQL连接实例
        mysql.setOption(.MYSQL_SET_CHARSET_NAME, "utf8")
        let connected = mysql.connect(host: servername, user: username, password: password, db: dbName)
        print(mysql.listDatabases())
        
        print(mysql.listTables())
        
        guard connected else {
            // 验证一下连接是否成功
            print(mysql.errorMessage())
            return
        }
        
        defer {
            mysql.close() //这个延后操作能够保证在程序结束时无论什么结果都会自动关闭数据库连接
        }
        
        // 运行查询（比如返回在options数据表中的所有数据行）
        let querySuccess = mysql.query(statement: "SELECT * FROM songs order by size")
        
        // 确保查询完成
        guard querySuccess else {
            return
        }
        
        // 在当前会话过程中保存查询结果
        let results = mysql.storeResults()! //因为上一步已经验证查询是成功的，因此这里我们认为结果记录集可以强制转换为期望的数据结果。当然您如果需要也可以用if-let来调整这一段代码。
        
        var ary = [[String:Any]]() //创建一个字典数组用于存储结果
        print("\(#line) : : \(results.numFields())")
        results.forEachRow { row in
//            print(row.self )
            dump(row)
//            print(type(of: row ))
//            print(row[0])
//            let optionName = getRowString(forRow: row[0]) //保存选项表的Name名称字段，应该是所在行的第一列，所以是row[0].
//            let optionValue = getRowString(forRow: row[1]) //保存选项表Value字段
//            ary.append(["\(optionName)":optionValue]) //保存到字典内
        }
    }
}
