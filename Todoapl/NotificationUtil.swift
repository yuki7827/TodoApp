//
//  NotificationUtil.swift
//  Todoapl
//
//  Created by Apple on 2018/10/27.
//  Copyright © 2018年 Baminami. All rights reserved.
//

import Foundation
import UserNotifications

//通知に関わるクラス
class NotificationUtil {
    static let center = UNUserNotificationCenter.current()
    /*
     *通知許可ダイアログを表示する
     */
    static func viewNotificationDialog() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            // エラー処理
        }
    }
    
    /*
     *起動から5秒後にテスト通知がなる
     */
    static func testNotificationSetting() {
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
    }
    
    /*
     *    通知の内容を作成し、登録する
     */
    static func notificationSetting(title: String, body: String, fromDate: Date, addTime: Int = 0) {
        // 通知内容の設定
        let content = UNMutableNotificationContent()
        
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: body, arguments: nil)
        content.sound = UNNotificationSound.default()
        
        var fromDt = fromDate
        let comps = DateComponents(minute: -addTime)
        
        fromDt = Calendar.current.date(byAdding: comps, to: fromDate) ?? fromDate
        let date = Calendar.current.dateComponents([.calendar, .year, .month, .day, .hour, .minute], from: fromDt)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: false)
        let request = UNNotificationRequest(identifier: title, content: content, trigger: trigger)
        
        // 通知を登録
        print("\(title)を登録、\(date)")
        center.add(request) { (error : Error?) in
            if error != nil {
                print("\(title)の登録失敗")
            }
        }
    }
    static func deleteNotification(identifier: String) {
        self.center.removePendingNotificationRequests(withIdentifiers: [identifier])
        print("\(identifier)を削除")
    }
}
