//
//  NotificationsViewController.swift
//  ForEvents
//
//  Created by luis gomez alonso on 18/10/18.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit
import VACalendar

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var monthHeaderView: VAMonthHeaderView! {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL"
            
            let appereance = VAMonthHeaderViewAppearance(
                monthTextColor: .orange,
                previousButtonImage: #imageLiteral(resourceName: "previous"),
                nextButtonImage: #imageLiteral(resourceName: "next"),
                dateFormatter: dateFormatter
                
            )
            monthHeaderView.delegate = self
            monthHeaderView.appearance = appereance
        }
    }
    
    @IBOutlet weak var weekDaysView: VAWeekDaysView! {
        didSet {
            let appereance = VAWeekDaysViewAppearance(symbolsType: .short,
                                                      weekDayTextColor: .white,
                                                      separatorBackgroundColor: .orange,
                                                      calendar: defaultCalendar)
            weekDaysView.appearance = appereance
        }
    }
    
    let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()
    
    var calendarView: VACalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set title
        title = "Calendario de eventos"
        
        let calendar = VACalendar(calendar: defaultCalendar)
        calendarView = VACalendarView(frame: .zero, calendar: calendar)
        calendarView.showDaysOut = true
        calendarView.selectionStyle = .single
        calendarView.monthDelegate = monthHeaderView
        calendarView.dayViewAppearanceDelegate = self
        calendarView.monthViewAppearanceDelegate = self
        calendarView.calendarDelegate = self
        calendarView.scrollDirection = .horizontal
        calendarView.setSupplementaries([
            (Date(), [VADaySupplementary.bottomDots([.green, .magenta])]),
            (Date().addingTimeInterval((60 * 60 * 40)), [VADaySupplementary.bottomDots([.cyan])]),
            (Date().addingTimeInterval((60 * 60 * 80)), [VADaySupplementary.bottomDots([.red])]),
            (Date().addingTimeInterval((60 * 60 * 370)), [VADaySupplementary.bottomDots([.blue, .darkGray])]),
            (Date().addingTimeInterval((60 * 60 * 430)), [VADaySupplementary.bottomDots([.orange, .purple, .cyan])])
            ])
        view.addSubview(calendarView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Configure navigationBar opaque and black, status bar white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if calendarView.frame == .zero {
            calendarView.frame = CGRect(
                x: 0,
                y: weekDaysView.frame.maxY,
                width: view.frame.width,
                height: view.frame.height * 0.3
            )
            calendarView.setup()
        }
    }
    
    @IBAction func changeMode(_ sender: Any) {
        calendarView.changeViewType()
    }
}

extension CalendarViewController: VAMonthHeaderViewDelegate {
    
    func didTapNextMonth() {
        calendarView.nextMonth()
    }
    
    func didTapPreviousMonth() {
        calendarView.previousMonth()
    }
    
}

extension CalendarViewController: VAMonthViewAppearanceDelegate {
    
    func leftInset() -> CGFloat {
        return 10.0
    }
    
    func rightInset() -> CGFloat {
        return 10.0
    }
    
    func verticalMonthTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    func verticalMonthTitleColor() -> UIColor {
        return .white
    }
    
    func verticalCurrentMonthTitleColor() -> UIColor {
        return .red
    }
    
}

extension CalendarViewController: VADayViewAppearanceDelegate {
    
    func textColor(for state: VADayState) -> UIColor {
        switch state {
        case .out:
            return UIColor(red: 214 / 255, green: 214 / 255, blue: 219 / 255, alpha: 1.0)
        case .selected:
            return .white
        case .unavailable:
            return .lightGray
        default:
            return CustomColors.orangeColor
        }
    }
    
    func textBackgroundColor(for state: VADayState) -> UIColor {
        switch state {
        case .selected:
            return .orange
        default:
            return .clear
        }
    }
    
    func shape() -> VADayShape {
        return .circle
    }
    
    func dotBottomVerticalOffset(for state: VADayState) -> CGFloat {
        switch state {
        case .selected:
            return 2
        default:
            return -3
        }
    }
    
}

extension CalendarViewController: VACalendarViewDelegate {
    
    func selectedDates(_ dates: [Date]) {
        calendarView.startDate = dates.last ?? Date()
        print(dates)
    }
    
}

