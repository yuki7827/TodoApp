//  AddController.swift
import UIKit

//変数の設置
var TodoKobetsunonakami = [String]()

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
        TodoKobetsunonakami.append(TodoTextField.text!)
        //追加ボタンを押したらフィールドを空にする
        TodoTextField.text = ""
        //変数の中身をUDに追加
        UserDefaults.standard.set( TodoKobetsunonakami, forKey: "TodoList" )
        //追加画面に遷移
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
