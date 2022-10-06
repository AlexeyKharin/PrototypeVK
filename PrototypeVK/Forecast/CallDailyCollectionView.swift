
import Foundation
import UIKit

final class CallDailyCollectionView: UIView {
    
    var delegate: CreateDailySummaryViewController?
    
    var modelDaily: RealmModelDaily? {
        didSet {
            modelUI = modelDaily?.weatherDaily.map { UIModelDailyCollectionCell(tempNight: $0.tempNight, tempDay: $0.tempDay, pop: $0.pop, weatherDescription: $0.weatherDescription, dataOfdailyForecast: $0.dataForTableView)}
        }
    }
    
   private var modelUI: [UIModelDailyCollectionCell]?
    
    let dailyForecast: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(red: 39/255, green:39/255, blue: 34/255, alpha: 1)
        label.textAlignment = .center
        label.toAutoLayout()
        label.text = "Ежедневный прогноз"
        label.backgroundColor = .white
        return label
    }()
    
    private var attrs = [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
        NSAttributedString.Key.foregroundColor : UIColor(red: 39/255, green:39/255, blue: 34/255, alpha: 1),
        NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
    
    private var attributedString = NSMutableAttributedString(string:"")
    
    lazy var moreSevenDays: UIButton = {
        let button = UIButton(type: .system)
        let buttonTitleStr = NSMutableAttributedString(string:"7 дней", attributes: self.attrs)
        attributedString.append(buttonTitleStr)
        button.setAttributedTitle(self.attributedString, for: .normal)
        button.addTarget(self, action: #selector(moreDays), for: .touchUpInside)
        button.toAutoLayout()
        return button
    }()
    
    @objc func moreDays() {
        guard let  modelDaily = modelDaily else { return }
        delegate?.createDailySummaryViewController(modelDaily)
    }
    
    private let layout = UICollectionViewFlowLayout()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.toAutoLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(
            DailyCollectionCell.self,
            forCellWithReuseIdentifier: String(describing: DailyCollectionCell.self)
        )
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout.scrollDirection = .vertical
        
        addSubview(collectionView)
        addSubview(dailyForecast)
        addSubview(moreSevenDays)
        
        let constraints = [
            
            dailyForecast.topAnchor.constraint(equalTo: topAnchor),
            dailyForecast.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            
            moreSevenDays.centerYAnchor.constraint(equalTo: dailyForecast.centerYAnchor),
            moreSevenDays.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            moreSevenDays.heightAnchor.constraint(equalToConstant: 20),
            moreSevenDays.widthAnchor.constraint(equalToConstant: 83),
            
            collectionView.topAnchor.constraint(equalTo: dailyForecast.bottomAnchor, constant: 10),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CallDailyCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelUI?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: DailyCollectionCell.self),
            for: indexPath) as! DailyCollectionCell
        
        cell.contentDaily = modelUI?[indexPath.row]
        
        return cell
    }
}

extension CallDailyCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (collectionView.bounds.width - 16 * 2)
        return CGSize(width: width, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: .zero, left: 16, bottom: 20, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let  modelDaily = modelDaily else { return }
        delegate?.createDailySummaryViewController(modelDaily)
    }
}
