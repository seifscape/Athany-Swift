//
//  ViewController.swift
//  Athany
//
//  Created by Seif Kobrosly on 12/3/20.
//

import UIKit
import Adhan

class NewViewController: UIViewController {
    
    fileprivate let headerView = PrayerHeaderView()
    var safeArea: UILayoutGuide!
    var timer: Timer!
    var tomorrowPrayer:Date!
    var nextPrayer:Date!
    
    fileprivate let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register( PrayerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .white
        cv.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 10,right: 0)
        return cv
    }()

    
    
    var tomorrowPrayers:PrayerTimes? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var prayers:PrayerTimes? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Today"
        self.navigationController?.title = "Today"
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
//        var config = UICollectionLayoutListConfiguration(appearance:
//          .plain)
//        config.backgroundColor = .systemPurple
//        collectionView.collectionViewLayout =
//          UICollectionViewCompositionalLayout.list(using: config)

        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        self.setupTableView()
        setupPrayerTimes()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true) // Repeat "func Update() " every second and update the label
        
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(settingsTapped))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

    func setupPrayerTimes() {
        let coordinates = Coordinates(latitude: 38.8816, longitude: -77.0910)
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let now = Calendar.current.dateComponents(in: .current, from: Date())
        let date = cal.dateComponents([.year, .month, .day], from: Date())

        let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1)
        //let dateTomorrow = Calendar.current.date(from: tomorrow)!

        var params = CalculationMethod.northAmerica.params
        params.madhab = .hanafi
        
        prayers = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params)
        
        if let nextPrayerUnwrapped = prayers?.nextPrayer() {
            nextPrayer = (prayers?.time(for: nextPrayerUnwrapped))!
        }
        // Tomorrow
        else {
            tomorrowPrayers = PrayerTimes(coordinates: coordinates, date: tomorrow, calculationParameters: params)
            nextPrayer = tomorrowPrayers?.time(for: .fajr)
        }
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
    
    @objc func settingsTapped() {
        print("right bar button action")
    }
        
    func setupTableView() {
        view.addSubview(headerView)
        view.addSubview(collectionView)
        collectionView.clipsToBounds = true
        collectionView.layer.cornerRadius = 10.0
        headerView.backgroundColor = .lightGray
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}

extension NewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width - 20, height: collectionView.frame.width/5.5)

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PrayerCollectionViewCell
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

        default:
            cell.prayerTime.text = "nil"
        }
        return cell
        
    }
}
