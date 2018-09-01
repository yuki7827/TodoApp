//
//  DetailViewController.swift
//  Todoapl
//
//  Created by Apple on 2018/08/26.
//  Copyright © 2018年 Baminami. All rights reserved.
//

import UIKit
import Eureka

class DetailViewController: FormViewController {
    
//    @IBOutlet weak var detailLabel: UILabel!
//    var detailMessage: String?
//    var detailMemo: String?
//    var detailDateTime: Date?
    var detailTodo: [String:Any]?
    var index: Int?
//
//    @IBAction func deleteButtonTapped(_ sender: Any) {
//        if let indexPath = index {
//            TodoKobetsunonakami.remove(at: indexPath)
//            //変数の中身をUDに追加
//            UserDefaults.standard.set( TodoKobetsunonakami, forKey: "TodoList" )
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //フォーム作成
        form
            +++ Section("Todo")
            <<< TextRow {row in
                row.title = "タイトル"
                row.placeholder = "タイトルを入力してください"
                row.value = detailTodo?["title"] as? String
                }.onChange { row in
                    let value = row.value
                    print(value!)
                    //変数に入力内容を入れる
                    if let index = self.index,
                    let rowValue = value {
                        todoList[index]["title"] = rowValue
                        
                        //変数の中身をUDに追加
                        UserDefaults.standard.set( todoList, forKey: "todoList" )
                        
                    }


                    
                }
            <<< TextAreaRow {row in
                row.placeholder = "メモを入力"
                row.value = detailTodo?["memo"] as? String
                }.onChange { row in
                    let value = row.value
                    print(value!)
                    //変数に入力内容を入れる
                    if let index = self.index,
                        let rowValue = value {
                        todoList[index]["memo"] = rowValue
                        //変数の中身をUDに追加
                        UserDefaults.standard.set( todoList, forKey: "todoList" )
                    }
            }
//            // ここからセクション2のコード
//            +++ Section("セクション2")
//            <<< TextRow { row in
//                row.title = "1行メモ"
//                row.placeholder = "1行メモを入力"
//            }

//            +++ Section("セクション4")
            <<< DateTimeRow("") {
                $0.title = "期限"
                $0.value = detailTodo?["dateTime"] as? Date
                }.onChange { row in
                    let value = row.value
                    print(value!)
                    //変数に入力内容を入れる
                    if let index = self.index,
                        let rowValue = value {
                        todoList[index]["dateTime"] = rowValue
                        //変数の中身をUDに追加
                        UserDefaults.standard.set( todoList, forKey: "todoList" )
                    }
        }
        
        

        // Do any additional setup after loading the view.
        //detailLabel.text = detailMessage
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
