//
//  ViewController.swift
//  Athany
//
//  Created by Seif Kobrosly on 12/3/20.
//

import UIKit
import Adhan

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate let headerView = PrayerHeaderView()
    fileprivate let tableView = UITableView()
    var safeArea: UILayoutGuide!
    var timer: Timer!
    var nextPrayer:Date!


    var prayers:PrayerTimes? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Today"
        self.navigationController?.title = "Today"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(PrayerTableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        self.setupTableView()
        setupPrayerTimes()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true) // Repeat "func Update() " every second and update the label

        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(settingsTapped))

        
        if #available(iOS 11.0, *) {
            self.tableView.insetsContentViewsToSafeArea = false;
            self.tableView.contentInsetAdjustmentBehavior = .never;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func UpdateTime() {
            let userCalendar = Calendar.current
            // Set Current Date
            let date = Date()
            let components = userCalendar.dateComponents([.hour, .minute, .month, .year, .day, .second], from: date)
            let currentDate = userCalendar.date(from: components)!
            
            
            let futureComponents = userCalendar.dateComponents([.hour, .minute, .month, .year, .day, .second], from: nextPrayer)
            let eventDate = userCalendar.date(from: futureComponents)
        

                
            // Change the seconds to days, hours, minutes and seconds
        let timeLeft = userCalendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: eventDate!)
            
            // Display Countdown
        headerView.nextPrayerCounterLabel.text = "\(timeLeft.hour!)h \(timeLeft.minute!)m \(timeLeft.second!)s"
            
            // Show diffrent text when the event has passed
        endEvent(currentdate: currentDate, eventdate: eventDate!)
        }
        
        func endEvent(currentdate: Date, eventdate: Date) {
            if currentdate >= eventdate {
                // Stop Timer
                timer.invalidate()
                if let nextPrayerUnwrapped = prayers?.nextPrayer() {
        //            let formatter = DateFormatter()
                    nextPrayer = (prayers?.time(for: nextPrayerUnwrapped))!
                    timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true) // Repeat "func Update() " every second and update the label

                }
            }
        }
    
    
    func setupPrayerTimes() {
        let coordinates = Coordinates(latitude: 38.8816, longitude: -77.0910)
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let date = cal.dateComponents([.year, .month, .day], from: Date())
        var params = CalculationMethod.northAmerica.params
        params.madhab = .hanafi
        prayers = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params)
//        if let nextPrayerUnwrapped = prayers?.currentPrayer(at: Date()) {
//            nextPrayer = (prayers?.time(for: nextPrayerUnwrapped))!
//        }
        if let nextPrayerUnwrapped = prayers?.nextPrayer() {
            nextPrayer = (prayers?.time(for: nextPrayerUnwrapped))!
        }
    }
    
    @objc
    func settingsTapped() {
        print("right bar button action")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PrayerTableViewCell(style: .default, reuseIdentifier: "cell")
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        switch indexPath.row {
        case 0:
            cell.prayerTitle.text = "Fajr"
            cell.prayerTime.text = formatter.string(from: prayers!.fajr)
            if Date() > prayers!.fajr {
                cell.isUserInteractionEnabled = false
                cell.prayerTitle.isEnabled = false
                cell.prayerTime.isEnabled = false
                cell.athanButton.isEnabled = false
            }
        case 1:
            cell.prayerTitle.text = "Sunrise"
            cell.prayerTime.text = formatter.string(from: prayers!.sunrise)
            if Date() > prayers!.sunrise {
                cell.isUserInteractionEnabled = false
                cell.prayerTitle.isEnabled = false
                cell.prayerTime.isEnabled = false
                cell.athanButton.isEnabled = false
            }
        case 2:
            cell.prayerTitle.text = "Dhuhr"
            cell.prayerTime.text = formatter.string(from: prayers!.dhuhr)
            if Date() > prayers!.dhuhr {
                cell.isUserInteractionEnabled = false
                cell.prayerTitle.isEnabled = false
                cell.prayerTime.isEnabled = false
                cell.athanButton.isEnabled = false
            }
        case 3:
            cell.prayerTitle.text = "Asr"
            cell.prayerTime.text = formatter.string(from: prayers!.asr)
            if Date() > prayers!.asr {
                cell.isUserInteractionEnabled = false
                cell.prayerTitle.isEnabled = false
                cell.prayerTime.isEnabled = false
                cell.athanButton.isEnabled = false
            }
        case 4:
            cell.prayerTitle.text = "Maghrib"
            cell.prayerTime.text = formatter.string(from: prayers!.maghrib)
            if Date() > prayers!.maghrib {
                cell.isUserInteractionEnabled = false
                cell.prayerTitle.isEnabled = false
                cell.prayerTime.isEnabled = false
                cell.athanButton.isEnabled = false
            }
        case 5:
            cell.prayerTitle.text = "Isha"
            cell.prayerTime.text = formatter.string(from: prayers!.isha)
            if Date() > prayers!.isha {
                cell.isUserInteractionEnabled = false
                cell.prayerTitle.isEnabled = false
                cell.prayerTime.isEnabled = false
                cell.athanButton.isEnabled = false
            }
        default:
            cell.prayerTime.text = "nil"
        }
            return cell
    }

    func setupTableView() {
        view.addSubview(headerView)
        view.addSubview(tableView)
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10.0
        headerView.backgroundColor = .lightGray
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        headerView.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
//        headerView.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
//        tableView.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32.0).isActive = true
//        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120.0).isActive = true
//        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32.0).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32.0).isActive = true

        
        
//      tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
//      tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//      tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

}

extension Date {
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

        return localDate
    }
}
