//
//  DetailViewController.swift
//  Todoapl
//
//  Created by Apple on 2018/08/26.
//  Copyright © 2018年 Baminami. All rights reserved.
//

import UIKit
import Eureka
import UserNotifications


class DetailViewController: FormViewController {
    
    //    @IBOutlet weak var detailLabel: UILabel!
    //    var detailMessage: String?
    //    var detailMemo: String?
    //    var detailDateTime: Date?
    var detailTodo: [String:Any]?
    var index: Int?
    var isFinished: Bool?
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
        if let isFin = isFinished {
            if isFin {
                let rightButton: UIBarButtonItem = UIBarButtonItem(title: "未完了", style: .plain, target: self, action: Selector("NoFinishButtonTapped"))
                self.navigationItem.setRightBarButton(rightButton, animated: true)
                
            } else {
                let rightButton: UIBarButtonItem = UIBarButtonItem(title: "完了", style: .plain, target: self, action: Selector("FinishButtonTapped"))
                self.navigationItem.setRightBarButton(rightButton, animated: true)
            }
        }
        
        //フォーム作成
        form
            +++ Section("Todo")
            <<< TextRow {row in
                row.title = "タイトル"
                row.placeholder = "タイトルを入力してください"
                row.value = detailTodo?["title"] as? String
                }.onChange { row in
                    let value = row.value
                    if let printValue = value {
                        print(printValue)
                    }
                    //変数に入力内容を入れる
                    if let index = self.index,
                        let rowValue = value {
                        if self.isFinished! {
                            didList[index]["title"] = rowValue
                            //変数の中身をUDに追加
                            UserDefaults.standard.set( didList, forKey: "didList" )
                        } else {
                            todoList[index]["title"] = rowValue
                            //変数の中身をUDに追加
                            UserDefaults.standard.set( todoList, forKey: "todoList" )
                        }
                    }
            }
            <<< TextAreaRow {row in
                row.placeholder = "メモを入力"
                row.value = detailTodo?["memo"] as? String
                }.onChange { row in
                    let value = row.value
                    if let printValue = value {
                        print(printValue)
                    }
                    
                    //変数に入力内容を入れる
                    if let index = self.index,
                        let rowValue = value {
                        if self.isFinished! {
                            didList[index]["memo"] = rowValue
                            //変数の中身をUDに追加
                            UserDefaults.standard.set( didList, forKey: "didList" )
                        } else {
                            todoList[index]["memo"] = rowValue
                            //変数の中身をUDに追加
                            UserDefaults.standard.set( todoList, forKey: "todoList" )
                        }
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
                        if self.isFinished! {
                            didList[index]["dateTime"] = rowValue
                            //変数の中身をUDに追加
                            UserDefaults.standard.set( didList, forKey: "didList" )
                        } else {
                            todoList[index]["dateTime"] = rowValue
                            //変数の中身をUDに追加
                            UserDefaults.standard.set( todoList, forKey: "todoList" )
                        }
                    }
                    NotificationUtil.notificationSetting(title: self.detailTodo!["title"] as! String, body: self.detailTodo!["memo"] as! String, fromDate: value!)
            }
            <<< PushRow<String> {row in
                row.title = "通知"
                row.options = ["0分前","1分前","3分前","5分前","10分前","15分前","20分前","30分前"]
                row.value = "0分前"
                }.onChange { row in
                    let value = row.value
                    if let printValue = value {
                        print(printValue)
                    }
                    var splitArray = value!.components(separatedBy: "分前")
                    let addTime = (Int)(splitArray[0]) ?? 0
                    
                    NotificationUtil.notificationSetting(title: self.detailTodo!["title"] as! String, body: self.detailTodo!["memo"] as! String, fromDate: self.detailTodo!["dateTime"] as! Date, addTime: addTime )
        }
        
        // Do any additional setup after loading the view.
        //detailLabel.text = detailMessage
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func FinishButtonTapped(){
        didList.append(todoList[index!])
        todoList.remove(at: index!)
        UserDefaults.standard.set( todoList, forKey: "todoList" )
        UserDefaults.standard.set( didList, forKey: "didList" )
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func NoFinishButtonTapped(){
        todoList.append(didList[index!])
        didList.remove(at: index!)
        UserDefaults.standard.set( todoList, forKey: "todoList" )
        UserDefaults.standard.set( didList, forKey: "didList" )
        self.navigationController?.popViewController(animated: true)
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
