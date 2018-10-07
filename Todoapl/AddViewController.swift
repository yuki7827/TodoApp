//  AddController.swift
import UIKit

//タイトル
//var TodoKobetsunonakami = [String]()
//メモ
//var memo = [String]()
//日時
//var datetime = [Date]()

//Todoの配列
var todo =  ["title":"", "memo":"", "dateTime": Date()] as [String : Any]
var todoList = [[String:Any]]()
var didList = [[String:Any]]()

class AddViewController: UIViewController {
    
    //テキストフィールドの設定
    @IBOutlet weak var TodoTextField: UITextField!
    
    //エラーメッセージを表示するラベルの設定
    @IBOutlet weak var errorLabel: UILabel!
    
    //追加ボタンの設定
    @IBAction func TodoAddButton(_ sender: Any) {
        //空文字チェック
        if let emptyCheckStr: String = TodoTextField.text,
            emptyCheckStr.isEmpty {
            errorLabel.text = "タイトルを記入してください"
            return
        }
        //変数に入力内容を入れる
        //        TodoKobetsunonakami.append(TodoTextField.text!)
        //        memo.append("")
        //        datetime.append(Date())
        todo.updateValue(TodoTextField.text!, forKey: "title")
        todo.updateValue("", forKey: "memo")
        todo.updateValue(Date(), forKey: "dateTime")
        todoList.append(todo)
        //追加ボタンを押したらフィールドを空にする
        TodoTextField.text = ""
        //変数の中身をUDに追加
        UserDefaults.standard.set( todoList, forKey: "todoList" )
        //        UserDefaults.standard.set( memo, forKey: "MemoList" )
        //        UserDefaults.standard.set( datetime, forKey: "DateTimeList" )
        //一覧画面に遷移
        self.performSegue(withIdentifier: "addToMain", sender: nil)
    }
    
    //最初からあるコード
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //最初からあるコード
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
