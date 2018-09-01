//  ViewController.swift
import UIKit
import UserNotifications

//classの継承を追加
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    //UITableView、numberOfRowsInSectionの追加(表示するcell数を決める)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //戻り値の設定(表示するcell数)
        return todoList.count
        
    }
    
    //UITableView、cellForRowAtの追加(表示するcellの中身を決める)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //変数を作る
        let TodoCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        //変数の中身を作る
        TodoCell.textLabel!.text = todoList[indexPath.row]["title"] as? String
        
        //戻り値の設定（表示する中身)
        return TodoCell
    }
    
    //セルをタップした際に画面遷移をする
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MainToDetail", sender: indexPath)
    }
    
    //次のViewControllerに値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailViewController,
            let indexPath = sender as? IndexPath {
            //            detailVC.detailMessage = TodoKobetsunonakami[indexPath.row]
            //            detailVC.detailMemo = memo[indexPath.row]
            //            detailVC.detailDateTime = datetime[indexPath.row]
            detailVC.detailTodo = todoList[indexPath.row]
            
            detailVC.index = indexPath.row
        }
    }
    //最初からあるコード
    override func viewDidLoad() {
        //追加画面で入力した内容を取得する
        if UserDefaults.standard.object(forKey: "todoList") != nil {
            //            TodoKobetsunonakami = UserDefaults.standard.object(forKey: "TodoList") as! [String]
            //            memo = UserDefaults.standard.object(forKey: "MemoList") as! [String]
            //            datetime = UserDefaults.standard.object(forKey: "DateTimeList") as! [Date]
            todoList = UserDefaults.standard.object(forKey: "todoList") as! [[String:Any]]
        }
        // 通知許可ダイアログを表示
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            // エラー処理
        }
        
        // 通知内容の設定
        let content = UNMutableNotificationContent()
        
        content.title = NSString.localizedUserNotificationString(forKey: "Title", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Message", arguments: nil)
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: " Identifier", content: content, trigger: trigger)
        
        // 通知を登録
        center.add(request) { (error : Error?) in
            if error != nil {
                // エラー処理
            }
        }
        
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.title = "一覧画面"
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    //最初からあるコード
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        //override前の処理を継続してさせる
        super.setEditing(editing, animated: animated)
        //tableViewの編集モードを切り替える
        tableView.isEditing = editing //editingはBool型でeditButtonに依存する変数
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //dataを消してから
        //        TodoKobetsunonakami.remove(at: indexPath.row)
        //        memo.remove(at: indexPath.row)
        //        datetime.remove(at: indexPath.row)
        todoList.remove(at: indexPath.row)
        //        UserDefaults.standard.set( TodoKobetsunonakami, forKey: "TodoList" )
        //        UserDefaults.standard.set( memo, forKey: "memoList" )
        //        UserDefaults.standard.set( datetime, forKey: "dateTimeList" )
        UserDefaults.standard.set( todoList, forKey: "todoList" )
        
        
        //tableViewCellの削除
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}
