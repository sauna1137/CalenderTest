//
//  ViewController.swift
//  CalenderTest
//
//  Created by KS on 2023/03/16.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic

class ViewController: UIViewController,
                      FSCalendarDataSource,
                      FSCalendarDelegate,
                      FSCalendarDelegateAppearance {

    @IBOutlet weak var calendarView: UIView!
    var calendar = FSCalendar()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalender()
    }

    func setupCalender() {
        calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: calendarView.frame.size.width, height: calendarView.frame.size.height))
        calendar.dataSource = self
        calendar.delegate = self
        setDetail()
        calendarView.addSubview(calendar)
    }

    func setDetail() {
        calendar.appearance.headerDateFormat = "yyyy年 MM月" //ヘッダー表示のフォーマット
        calendar.appearance.headerTitleColor = UIColor.systemBlue //ヘッダーテキストカラー
        calendar.locale = Locale(identifier: "ja") //表示の言語の設置（日本語表示の場合は"ja"）
        calendar.appearance.titleWeekendColor = .gray //週末（土、日曜の日付表示カラー）
        calendar.appearance.weekdayTextColor = .gray //曜日表示のテキストカラー
        //カレンダー日付表示
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 16) //日付のテキストサイズ
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular) //日付のテキスト、ウェイトサイズ
        calendar.appearance.todayColor = .clear //本日の選択カラー
        calendar.appearance.titleTodayColor = .systemBlue //本日のテキストカラー
        calendar.appearance.selectionColor = .systemBlue //選択した日付のカラー
        calendar.appearance.titleSelectionColor = .white //選択した日付のテキストカラー
        //        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .systemRed // 日曜日赤
    }

    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }

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

    // ラベル追加
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {

        let taijulabel = UILabel(frame: CGRect(x: 12, y: 30, width: 40, height: 20))
        taijulabel.font = UIFont.systemFont(ofSize: 8, weight: .bold)
        taijulabel.text = "30000円"
        taijulabel.textColor = UIColor.gray
        taijulabel.layer.cornerRadius = cell.bounds.width/2
        cell.addSubview(taijulabel)
    }

    // カレンダーのセルタップ時
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // セル（日付）がタップされた時の処理
        print("Selected date: \(date)")
    }

    //　カレンダーがスクロールされたら
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年M月"
        let currentPageDate = calendar.currentPage
        print(currentPageDate)
    }

}

