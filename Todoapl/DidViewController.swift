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
        
        //navigationItem.leftBarButtonItem = editButtonItem

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

    // Cellのスワイプ処理
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let swipeCellToDelete = UITableViewRowAction(style: .default, title: "削除") { action, index in
            self.swipeDelete(indexPath: indexPath)// 押されたときの動きを定義しています
        }
        let swipeCellToNoFinish = UITableViewRowAction(style: .default, title: "未完了") { action, index in
            self.swipeNoFinish(index: index.row, indexPath: indexPath)
        }
        
        // 背景色
        swipeCellToDelete.backgroundColor = .red
        swipeCellToNoFinish.backgroundColor = .green
        // 配列の右から順で表示される
        return [swipeCellToNoFinish, swipeCellToDelete]
    }
    
    // trueを返すことでCellのアクションを許可しています
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // スワイプされたとき用のメソッド
    func swipeDelete(indexPath: IndexPath) {
        didList.remove(at: indexPath.row)
        UserDefaults.standard.set( didList, forKey: "didList" )
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func swipeNoFinish(index: Int, indexPath: IndexPath) {
        todoList.append(didList[index])
        didList.remove(at: index)
        UserDefaults.standard.set( todoList, forKey: "todoList" )
        UserDefaults.standard.set( didList, forKey: "didList" )
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
