//
//  MainViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/21.
//

import UIKit

class MainViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dayStackView: UIStackView!
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    var months = [Date?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (-3...3).forEach { offset in
            self.months.append(Date.getNewMonth(offset: offset, from: Date()))
        }
        
        let initialSection = months.count/2
        if let month = months[initialSection],
           let weeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: month) {
            collectionViewHeight.constant = CGFloat(weeks.count*50)
        }
        setUI()
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: initialSection), at: .top, animated: false)
    }
    
    private func setUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CalendarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.collectionViewLayout = getCollectionViewLayout()
        
        Calendar(identifier: .gregorian).shortWeekdaySymbols.forEach { str in
            let label = UILabel()
            label.text = str
            label.textAlignment = .center
            self.dayStackView.addArrangedSubview(label)
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
    
    private func getCurrentWeeks(in scrollView: UIScrollView) -> Int? {
        let indexPaths = self.collectionView.indexPathsForVisibleItems
            .sorted { $0.section < $1.section }
        if let month = months[indexPaths[indexPaths.count/2].section],
           let weeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: month) {
            return weeks.count
        }else{
            return nil
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CalendarCollectionViewCell {
            let date = months[indexPath.section] ?? Date()
            let components = Calendar.current.dateComponents([.year, .month], from: date)
            if let firstDate = Calendar.current.date(from: components) {
                let weekDay = Calendar.current.component(.weekday, from: firstDate)
                let dayOffset = indexPath.item-(weekDay-1)
                let newDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: firstDate, wrappingComponents: false)
                let day = Calendar.current.component(.day, from: newDate!)
                cell.dayLabel.text = "\(day)"
                
                if dayOffset < 0 || dayOffset >= Calendar.current.component(.day, from: date.endOfMonth) {
                    cell.dayLabel.textColor = .lightGray
                }else{
                    cell.dayLabel.textColor = .black
                }
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let month = months[section],
           let weeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: month) {
            return weeks.count*7
        }else{
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return months.count
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxOffset = scrollView.contentSize.height-scrollView.frame.height
        if scrollView == collectionView {
            if scrollView.contentOffset.y < 200 {
                if let firstDate = months.first,
                   let date = firstDate {
                    print("previous data added")
                    months.insert(Date.getNewMonth(offset: -1, from: date), at: 0)
                    months.insert(Date.getNewMonth(offset: -2, from: date), at: 0)
                    let oldContentSize = collectionView.contentSize
                    collectionView.reloadData()
                    collectionView.layoutIfNeeded()
                    let newContentSize = collectionView.contentSize
                    let contentOffsetY = collectionView.contentOffset.y + newContentSize.height - oldContentSize.height
                    let newOffset = CGPoint(x: collectionView.contentOffset.x, y: contentOffsetY)
                    collectionView.setContentOffset(newOffset, animated: false)
                }
            }
            if scrollView.contentOffset.y > maxOffset-200 {
                if let lastDate = months.last,
                   let date = lastDate {
                    print("next months added")
                    months.append(Date.getNewMonth(offset: 1, from: date))
                    months.append(Date.getNewMonth(offset: 2, from: date))
                    collectionView.reloadData()
                }
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let collectionView = scrollView as? UICollectionView {
            let indexPaths = self.collectionView.indexPathsForVisibleItems
                .sorted { $0.section < $1.section }
            let center = indexPaths[indexPaths.count/2]
            targetContentOffset.pointee.y = scrollView.contentOffset.y
            collectionView.scrollToItem(at: IndexPath(item: 0, section: center.section), at: .top, animated: true)
        }
        
        if let weeks = getCurrentWeeks(in: scrollView) {
            let height = CGFloat(50*weeks)
            self.collectionViewHeight.constant = height
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
