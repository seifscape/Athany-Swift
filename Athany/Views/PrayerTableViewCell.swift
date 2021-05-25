//
//  PrayerTableViewCell.swift
//  Athany
//
//  Created by Seif Kobrosly on 1/13/21.
//

import UIKit

class PrayerTableViewCell: UITableViewCell {

    var cellStackView:UIStackView?
    var prayerTitle: UILabel
    var prayerTime: UILabel
    var athanButton: UIButton
    
    
    let theStackView: UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .horizontal
        v.alignment = .center
        v.distribution = .fill
        v.spacing = 5
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        prayerTitle = UILabel()
        prayerTitle.translatesAutoresizingMaskIntoConstraints = false
        prayerTitle.text = "Prayer N"
        
        prayerTime = UILabel()
        prayerTime.translatesAutoresizingMaskIntoConstraints = false
        prayerTime.text = "14:00"
        
        athanButton = UIButton()
        athanButton.setImage(UIImage(systemName: "bell"), for: .normal)
        athanButton.sizeToFit()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        addSubviews()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func addSubviews() {
//
//        //contentView.addSubview(prayerTitle)
//        //contentView.addSubview(prayerTime)
//        accessoryView?.addSubview(athanButton)
//    }
    
    func commonInit() -> Void {

        backgroundColor = .white

        theStackView.addArrangedSubview(prayerTitle)
        theStackView.addArrangedSubview(prayerTime)

        theStackView.frame = contentView.frame
        contentView.addSubview(theStackView)
        

        NSLayoutConstraint.activate([
            theStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 0.0),
            theStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: 0.0),
            theStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 0.0),
            theStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: 0.0),
            ])

        self.accessoryView = athanButton
    }
    
    func setupConstraints() {
        prayerTitle.leftAnchor.constraint(equalTo:self.leftAnchor, constant:10).isActive = true
        prayerTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        prayerTitle.rightAnchor.constraint(equalTo:self.rightAnchor, constant: 40).isActive = true
        prayerTitle.heightAnchor.constraint(equalToConstant: self.frame.height/3).isActive = true
    }
    
    func configureCellWith(item: NSObject) {
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//    }

}
