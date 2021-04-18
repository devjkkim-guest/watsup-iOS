//
//  MainViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/21.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class MainViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dayStackView: UIStackView!
    @IBOutlet weak var registerEmotionView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    var months = [Date?]()
    let emotions = DatabaseWorker.shared.getEmotionList()
    var selectedEmotions: Results<Emotion>?
    var emotionToken: NotificationToken?
    
    // Model
    let disposeBag = DisposeBag()
    let viewModel = MainViewModel(selectedDate: Date().startOfDay)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        loadData()
        bindModel()
    }
    
    private func setUI() {
        self.title = Date().monthSymoble
        
        Calendar(identifier: .gregorian).shortWeekdaySymbols.forEach { str in
            let label = UILabel()
            label.text = str
            label.textAlignment = .center
            self.dayStackView.addArrangedSubview(label)
        }
        
        // 현재 Month 전후로 3개씩 추가
        (-3...3).forEach { offset in
            self.months.append(Date.getNewMonth(offset: offset, from: Date()))
        }
        
        let initialSection = months.count/2
        if let month = months[initialSection],
           let weeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: month) {
            collectionViewHeight.constant = CGFloat(weeks.count*50)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CalendarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.collectionViewLayout = getCollectionViewLayout()
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: initialSection), at: .top, animated: false)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EmotionListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "RegisterEmotionTableViewCell", bundle: nil), forCellReuseIdentifier: "registerCell")
    }
    
    func bindModel() {
        emotionToken = emotions.observe { changes in
            switch changes {
            case .update:
                // TO DO: reload tableView only if inserted data belongs to currently selected day.
                if let selectedDate = try? self.viewModel.selectedDate.value() {
                    self.reloadSelectedEmotions(selectedDate: selectedDate)
                }
            case .initial:
                self.tableView.reloadData()
            default:
                break
            }
        }
        
        viewModel.selectedDate
            .subscribe(onNext: { [weak self] selectedDate in
                self?.collectionView.reloadData()
                // reload tableView after filtering emotions for currently selected day.
                self?.reloadSelectedEmotions(selectedDate: selectedDate)
            })
            .disposed(by: disposeBag)
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
    
    private func reloadSelectedEmotions(selectedDate: Date) {
        if let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) {
            let startTime = selectedDate.timeIntervalSince1970
            let endTime = nextDay.timeIntervalSince1970
            selectedEmotions = emotions.filter("createdAt >= \(startTime) AND createdAt < \(endTime)")
            tableView.reloadData()
        }
    }
    
    // MARK: - Useful Funcs
    /// 달력 section의 첫번째 날 반환
    func getFirstDate(of section: Int) -> Date? {
        let date = months[section] ?? Date()
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        return Calendar.current.date(from: components)
    }
    
    // MARK: - API
    func loadData() {
        API.shared.getUserEmotions { result in
            switch result {
            case .success(_):
                return
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CalendarCollectionViewCell {
            if let firstDate = getFirstDate(of: indexPath.section),
               let currentDate = firstDate.getDate(offset: indexPath.item){
                let day = Calendar.current.component(.day, from: currentDate)
                
                let components: Set = [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day]
                let firstDay = Calendar.current.dateComponents(components, from: firstDate)
                let today = Calendar.current.dateComponents(components, from: Date())
                let currentDay = Calendar.current.dateComponents(components, from: currentDate)
                
                if firstDay.month == currentDay.month {
                    cell.dayLabel.text = "\(day)"
                    
                    // set label textColor & font-weight
                    if Date() < currentDate {
                        // 오늘 이후의 날짜는 gray
                        cell.dayLabel.textColor = .systemGray3
                    }else{
                        if let selectedDate = try? viewModel.selectedDate.value() {
                            if selectedDate == currentDate {
                                // 선택된 경우 항상 흰색
                                cell.dayLabel.textColor = .white
                                cell.dayLabel.font = .boldSystemFont(ofSize: 17)
                            }else if currentDate == Date().startOfDay {
                                // 오늘인데 선택되지 않은 경우 빨간색
                                cell.dayLabel.textColor = .red
                                cell.dayLabel.font = .boldSystemFont(ofSize: 17)
                            }else{
                                // 그 외 검정색
                                cell.dayLabel.textColor = .black
                                cell.dayLabel.font = .systemFont(ofSize: 17)
                            }
                        }else{
                            if currentDate == Date().startOfDay {
                                cell.dayLabel.textColor = .white
                                cell.dayLabel.font = .boldSystemFont(ofSize: 17)
                            }else{
                                cell.dayLabel.textColor = .black
                                cell.dayLabel.font = .systemFont(ofSize: 17)
                            }
                        }
                    }
                    // set dayMark
                    if let selectedDate = try? viewModel.selectedDate.value() {
                        if selectedDate == currentDate
                            && selectedDate == Date().startOfDay {
                            cell.dayMark.backgroundColor = .red
                        }else if selectedDate == currentDate {
                            cell.dayMark.backgroundColor = .black
                        }else{
                            cell.dayMark.backgroundColor = nil
                        }
                    }else{
                        if today == currentDay {
                            cell.dayMark.backgroundColor = .red
                        }else{
                            cell.dayMark.backgroundColor = nil
                        }
                    }
                    
                    // selection 가능 여부
                    if Date() < currentDate {
                        cell.isUserInteractionEnabled = false
                    }else{
                        cell.isUserInteractionEnabled = true
                    }
                }else{
                    // 다른 월의 날짜는 지움
                    cell.dayLabel.text = nil
                    cell.dayMark.backgroundColor = nil
                    cell.isUserInteractionEnabled = false
                }
            }
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDataSource
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let date = getFirstDate(of: indexPath.section)?.getDate(offset: indexPath.item) {
            viewModel.selectedDate.onNext(date)
        }
    }
}

// MARK: - UITableDataSource
extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (selectedEmotions?.count ?? 0)+1
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == selectedEmotions?.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath) as! RegisterEmotionTableViewCell
            cell.delegate = self
            cell.date = try? viewModel.selectedDate.value()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmotionListTableViewCell
            if let emotion = selectedEmotions?[indexPath.row] {
                cell.configure(emotion: emotion)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UIScrollViewDelegate
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
            // 중앙 지점의 섹션으로 이동
            let indexPaths = self.collectionView.indexPathsForVisibleItems
                .sorted { $0.section < $1.section }
            let center = indexPaths[indexPaths.count/2]
            targetContentOffset.pointee.y = scrollView.contentOffset.y
            collectionView.scrollToItem(at: IndexPath(item: 0, section: center.section), at: .top, animated: true)
            
            if let date = months[center.section] {
                self.title = date.monthSymoble
            }
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

extension MainViewController: RegisterEmotionTableViewCellDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RegisterEmotionViewController {
            vc.date = sender as? Date
        }
    }
    
    func didClickRegister(_ date: Date) {
        self.performSegue(withIdentifier: "pushToRegisterEmotionViewController", sender: date)
    }
}
