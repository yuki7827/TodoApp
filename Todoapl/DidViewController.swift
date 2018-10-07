//
//  DidViewController.swift
//  Todoapl
//
//  Created by Apple on 2018/10/07.
//  Copyright © 2018年 Baminami. All rights reserved.
//

import UIKit

class DidViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    //表示するcell数を決めるデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return didList.count
    }
    
    //表示するcellの中身を決めるデリゲートメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let didCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "DidCell", for: indexPath)
        //変数の中身を作る
        didCell.textLabel!.text = didList[indexPath.row]["title"] as? String
        //戻り値の設定（表示する中身)
        return didCell
    }
    
    //セルをタップした際に画面遷移をする
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DidToDetail", sender: indexPath)
    }
    
    //次のViewControllerに値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailViewController,
            let indexPath = sender as? IndexPath {
            //            detailVC.detailMessage = TodoKobetsunonakami[indexPath.row]
            //            detailVC.detailMemo = memo[indexPath.row]
            //            detailVC.detailDateTime = datetime[indexPath.row]
            detailVC.detailTodo = didList[indexPath.row]
            detailVC.index = indexPath.row
            detailVC.isFinished = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let didListDB = UserDefaults.standard.object(forKey: "didList") {
            didList = didListDB as! [[String:Any]]
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        //override前の処理を継続してさせる
        super.setEditing(editing, animated: animated)
        //tableViewの編集モードを切り替える
        tableView.isEditing = editing //editingはBool型でeditButtonに依存する変数
    }
    
    //削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //dataを消してから
        //        TodoKobetsunonakami.remove(at: indexPath.row)
        //        memo.remove(at: indexPath.row)
        //        datetime.remove(at: indexPath.row)
        didList.remove(at: indexPath.row)
        //        UserDefaults.standard.set( TodoKobetsunonakami, forKey: "TodoList" )
        //        UserDefaults.standard.set( memo, forKey: "memoList" )
        //        UserDefaults.standard.set( datetime, forKey: "dateTimeList" )
        UserDefaults.standard.set( didList, forKey: "didList" )
        
        
        //tableViewCellの削除
        tableView.deleteRows(at: [indexPath], with: .automatic)
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
