//  ViewController.swift
import UIKit
import UserNotifications

//classの継承を追加
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    static let center = UNUserNotificationCenter.current()
    
    
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
            detailVC.isFinished = false
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
        ViewController.center.requestAuthorization(options: [.alert, .sound, .badge]) {
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
        ViewController.center.add(request) { (error : Error?) in
            if error != nil {
                // エラー処理
            }
        }
        
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.title = "一覧画面"
        //navigationItem.leftBarButtonItem = editButtonItem
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
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // Cellのスワイプ処理
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let swipeCellToDelete = UITableViewRowAction(style: .default, title: "削除") { action, index in
            self.swipeDelete(indexPath: indexPath)// 押されたときの動きを定義しています
        }
        let swipeCellToFinish = UITableViewRowAction(style: .default, title: "完了") { action, index in
            self.swipeFinish(index: index.row, indexPath: indexPath)
        }

        // 背景色
        swipeCellToDelete.backgroundColor = .red
        swipeCellToFinish.backgroundColor = .blue
        // 配列の右から順で表示される
        return [swipeCellToFinish, swipeCellToDelete]
    }
    
    // trueを返すことでCellのアクションを許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // スワイプされたとき用のメソッド
    func swipeDelete(indexPath: IndexPath) {
        todoList.remove(at: indexPath.row)
        UserDefaults.standard.set( todoList, forKey: "todoList" )
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func swipeFinish(index: Int, indexPath: IndexPath) {
        didList.append(todoList[index])
        todoList.remove(at: index)
        UserDefaults.standard.set( todoList, forKey: "todoList" )
        UserDefaults.standard.set( didList, forKey: "didList" )
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}
