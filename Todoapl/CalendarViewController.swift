import UIKit
import FSCalendar
import CalculateCalendarLogic


class CalendarViewController: UIViewController,FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    //UITableView、numberOfRowsInSectionの追加(表示するcell数を決める)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var parsedTodoDict = parseDateTimeTodoList(TodoList: todoList)
        var sectionArray = createSectionTitleArray(TodoList: todoList)
        let thisSectionTodoList = parsedTodoDict[sectionArray[section]] as? Array<[String:Any]>
        //戻り値の設定(表示するcell数)
        return thisSectionTodoList?.count ?? 0
    }
    
    //UITableView、cellForRowAtの追加(表示するcellの中身を決める)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //変数を作る
        let TodoCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CalendarTodoCell", for: indexPath)
        var parsedTodoDict = parseDateTimeTodoList(TodoList: todoList)
        var sectionArray = createSectionTitleArray(TodoList: todoList)
        let thisSectionTodoList = parsedTodoDict[sectionArray[indexPath.section]] as? Array<[String:Any]>
        //変数の中身を作る
        TodoCell.textLabel!.text = thisSectionTodoList?[indexPath.row]["title"] as? String
        
        //戻り値の設定（表示する中身)
        return TodoCell
    }
    
    //セルをタップした際に画面遷移をする
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CalendarToDetail", sender: indexPath)
    }
    
    //次のViewControllerに値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailViewController,
            let indexPath = sender as? IndexPath {
            //            detailVC.detailMessage = TodoKobetsunonakami[indexPath.row]
            //            detailVC.detailMemo = memo[indexPath.row]
            //            detailVC.detailDateTime = datetime[indexPath.row]
            var parsedTodoDict = parseDateTimeTodoList(TodoList: todoList)
            var sectionArray = createSectionTitleArray(TodoList: todoList)
            let thisSectionTodoList = parsedTodoDict[sectionArray[indexPath.section]] as? Array<[String:Any]>
            let todo = thisSectionTodoList?[indexPath.row]
            for (index,info) in todoList.enumerated() {
                if let todoTitle = todo?["title"] as? String,
                    let infoTitle = info["title"] as? String,
                     todoTitle == infoTitle  {
                    detailVC.index = index
                    break
                }
            }
            detailVC.detailTodo = todo
            detailVC.isFinished = false
        }
    }
    // カレンダータップ時に日付情報を取得する
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        tableView.reloadData()


//        let year = tmpDate.component(.year, from: date)
//        let month = tmpDate.component(.month, from: date)
//        let day = tmpDate.component(.day, from: date)
//        print("\(year)/\(month)/\(day)")
    }

    // Section数
    func numberOfSections(in tableView: UITableView) -> Int {
        return createSectionTitleArray(TodoList: todoList).count
    }
    
    // Sectionのタイトル
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return createSectionTitleArray(TodoList: todoList)[section]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
    
    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }
        
        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }
        
        return nil
    }
    
    // TodoListの期日をセクションタイトル用に配列に格納する
    private func createSectionTitleArray(TodoList: Array<[String:Any]>) -> [String] {
        var sectionTitleArray: [String] = []
        let f = DateFormatter()
        f.timeStyle = .none
        f.dateStyle = .full
        f.locale = Locale(identifier: "ja_JP")
        for todo in TodoList {
            if let dateTime = todo["dateTime"] as? Date {
                let strDateTime = f.string(from: dateTime)
                if !sectionTitleArray.contains(strDateTime) && selectedDate > dateTime {
                    sectionTitleArray.append(strDateTime)
                }
            }
        }
        sectionTitleArray.sort(by: {$0 < $1})
        return sectionTitleArray
    }
    
    // Todoを期日ごとに分ける
    private func parseDateTimeTodoList(TodoList: Array<[String:Any]>) -> [String:Any] {
        var parsedDict: [String:Any]  = [:]
        let f = DateFormatter()
        f.timeStyle = .none
        f.dateStyle = .full
        f.locale = Locale(identifier: "ja_JP")
        for todo in TodoList {
            var tmpArray: Array<[String:Any]> = []
            if let dateTime = todo["dateTime"] as? Date {
                let strDateTime = f.string(from: dateTime)
                if !parsedDict.keys.contains(strDateTime) {
                    parsedDict[strDateTime] = [] as Array<[String:Any]>
                }
                tmpArray = parsedDict[strDateTime] as? Array<[String:Any]> ?? []
                tmpArray.append(todo)
                parsedDict[strDateTime] = tmpArray
            }
        }
        return parsedDict
    }
    
    
}
