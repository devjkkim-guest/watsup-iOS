//
//  MainViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/21.
//

import UIKit

class MainViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerStackView: UIStackView!
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CalendarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.collectionViewLayout = getCollectionViewLayout()
        
        Calendar.current.veryShortWeekdaySymbols.forEach { weekday in
            let label = UILabel()
            label.text = weekday
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 14, weight: .semibold)
            headerStackView.addArrangedSubview(label)
        }
        
    }
    
    private func getCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = .zero
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/7, height: 50)
        layout.scrollDirection = .vertical
        return layout
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(scrollViewDidEndScrollingAnimation(_:)), with: scrollView, afterDelay: 0.1)
    }
    
    @objc func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView,
           let indexPaths = collectionView.indexPathsForVisibleItems.first {
            let _ = indexPaths.section
            let weeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: Date())
            collectionViewHeight.constant = CGFloat(weeks?.count ?? 0)*50
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CalendarCollectionViewCell {
            let components = Calendar.current.dateComponents([.year, .month], from: Date())
            if let firstOfMonth = Calendar.current.date(from: components) {
                let weekDay = Calendar.current.component(.weekday, from: firstOfMonth)
                let dayOffset = indexPath.item-(weekDay-1)
                let newDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: firstOfMonth, wrappingComponents: false)
                
                let day = Calendar.current.component(.day, from: newDate!)
                cell.dayLabel.text = "\(day)"
                
                var components = DateComponents()
                components.month = 1
                components.day = -1
                if let lastOfMonth = Calendar.current.date(byAdding: components, to: firstOfMonth) {
                    let lastDay = Calendar.current.component(.day, from: lastOfMonth)
                    print("lastDay: \(lastDay)")
                    if dayOffset < 0 || dayOffset > lastDay-1 {
                        cell.dayLabel.textColor = .lightGray
                    }
                }
            }
            
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        currentMonth = indexPath.section
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let weeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: Date())
        print(weeks!.count*7)
        return weeks!.count*7
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
