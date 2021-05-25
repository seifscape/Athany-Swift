//
//  PrayerHeaderView.swift
//  Athany
//
//  Created by Seif Kobrosly on 1/15/21.
//

import UIKit

class PrayerHeaderView: UIView {


    let backgroundImage = UIImage()
    let nextPrayerCounterLabel = UILabel()
    let nextPrayerLabel = UILabel()
    
    let stackView: UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .vertical
        v.alignment = .leading
        v.distribution = .fill
        v.backgroundColor = .white
        v.spacing = 0
        return v
    }()

    
    let someImageView: UIImageView = {
         let theImageView = UIImageView()
         theImageView.image = UIImage(named: "ramadan-landscape-background-sunset_1048-1789")
         theImageView.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
         return theImageView
      }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLabels()
        self.bringSubviewToFront(nextPrayerLabel)
        self.bringSubviewToFront(nextPrayerCounterLabel)
//        setupConstraints()
        sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func someImageViewConstraints() {
        someImageView.translatesAutoresizingMaskIntoConstraints = false

        someImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        someImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        someImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        someImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func addLabels() {
        self.addSubview(nextPrayerLabel)
        self.addSubview(nextPrayerCounterLabel)
        nextPrayerLabel.translatesAutoresizingMaskIntoConstraints = false
        nextPrayerLabel.font = .systemFont(ofSize: 25)
        nextPrayerLabel.adjustsFontSizeToFitWidth = true
        nextPrayerLabel.numberOfLines = 1
        nextPrayerLabel.textColor = .white

        
        nextPrayerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true

        nextPrayerLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 33).isActive = true
//        nextPrayerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nextPrayerLabel.bottomAnchor.constraint(equalTo: nextPrayerCounterLabel.topAnchor, constant: 3).isActive = true

        nextPrayerCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        nextPrayerLabel.text = "Next Prayer"
        nextPrayerCounterLabel.text = "02:34:56s"

        nextPrayerCounterLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        nextPrayerCounterLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 20).isActive = true

        nextPrayerCounterLabel.textColor = .white
        nextPrayerCounterLabel.font = .systemFont(ofSize: 40)
        nextPrayerCounterLabel.adjustsFontSizeToFitWidth = true
        nextPrayerCounterLabel.numberOfLines = 1

        self.addSubview(someImageView) //This add it the view controller without constraints
        someImageViewConstraints() //This function is outside the viewDidLoad function that controls the constraints

        
    }
    
    private func addSubviews() {
        self.addSubview(stackView)


        stackView.setCustomSpacing(UIStackView.spacingUseDefault, after: nextPrayerLabel)

        nextPrayerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nextPrayerLabel.font = .systemFont(ofSize: 20)
        nextPrayerLabel.adjustsFontSizeToFitWidth = true
        nextPrayerLabel.numberOfLines = 1
        
        nextPrayerCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        nextPrayerLabel.text = "Next Prayer"
        nextPrayerCounterLabel.text = "02:34:56s"

        nextPrayerCounterLabel.font = .systemFont(ofSize: 30)
        nextPrayerCounterLabel.adjustsFontSizeToFitWidth = true
        nextPrayerCounterLabel.numberOfLines = 1


        
        nextPrayerCounterLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nextPrayerLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        
        stackView.addArrangedSubview(nextPrayerLabel)
        stackView.addArrangedSubview(nextPrayerCounterLabel)
    }
    
    private func setupConstraints() {
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
