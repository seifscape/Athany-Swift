//
//  PayerCollectoinViewCell.swift
//  Athany
//
//  Created by Seif Kobrosly on 5/25/21.
//

import UIKit

class PrayerCollectionViewCell: UICollectionViewCell {
 
    private let cardView = UIView()
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

    override init(frame: CGRect) {
        prayerTitle = UILabel()
        prayerTitle.translatesAutoresizingMaskIntoConstraints = false
        prayerTitle.text = "Prayer N"
        
        prayerTime = UILabel()
        prayerTime.translatesAutoresizingMaskIntoConstraints = false
        prayerTime.text = "14:00"
        
        athanButton = UIButton()
        athanButton.setImage(UIImage(systemName: "bell"), for: .normal)
        athanButton.tintColor = .black
        athanButton.sizeToFit()
        
        super.init(frame: frame)
        commonInit()

    }
    
    func commonInit() -> Void {

        contentView.addSubview(cardView)
        cardView.layer.cornerRadius = 4
        cardView.backgroundColor = .white
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowRadius = 4
        cardView.layer.shadowOffset = CGSize(width: -1, height: 2)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addConstraints([
            NSLayoutConstraint(item: cardView, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 0.95, constant: 0.0),
            NSLayoutConstraint(item: cardView, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 0.95, constant: 0.0),
            NSLayoutConstraint(item: cardView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: cardView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
            ])
        

        theStackView.addArrangedSubview(prayerTitle)
        theStackView.addArrangedSubview(prayerTime)
        theStackView.addArrangedSubview(athanButton)
        theStackView.setCustomSpacing(10, after: prayerTime)

        
        theStackView.frame = cardView.frame
        cardView.addSubview(theStackView)
        

        NSLayoutConstraint.activate([
            theStackView.topAnchor.constraint(equalTo: cardView.layoutMarginsGuide.topAnchor, constant: 0.0),
            theStackView.bottomAnchor.constraint(equalTo: cardView.layoutMarginsGuide.bottomAnchor, constant: 0.0),
            theStackView.leadingAnchor.constraint(equalTo: cardView.layoutMarginsGuide.leadingAnchor, constant: 0.0),
            theStackView.trailingAnchor.constraint(equalTo: cardView.layoutMarginsGuide.trailingAnchor, constant: 0.0),
            ])

        
//        let favoriteAccessory = UICellAccessory.CustomViewConfiguration(
//            customView: athanButton,
//            placement: .trailing(displayed: .always)
//        )
//
//        self.accessories = [.customView(configuration: favoriteAccessory)]
    }
    
    func setupConstraints() {
        prayerTitle.leftAnchor.constraint(equalTo:cardView.leftAnchor, constant:10).isActive = true
        prayerTitle.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
        prayerTitle.rightAnchor.constraint(equalTo:cardView.rightAnchor, constant: 40).isActive = true
        prayerTitle.heightAnchor.constraint(equalToConstant: cardView.frame.height/3).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
