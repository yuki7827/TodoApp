//
//  DetailViewController.swift
//  Todoapl
//
//  Created by Apple on 2018/08/26.
//  Copyright © 2018年 Baminami. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailLabel: UILabel!
    var detailMessage: String?
    var index: Int? 
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if let indexPath = index {
            TodoKobetsunonakami.remove(at: indexPath)
            //変数の中身をUDに追加
            UserDefaults.standard.set( TodoKobetsunonakami, forKey: "TodoList" )
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailLabel.text = detailMessage
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
