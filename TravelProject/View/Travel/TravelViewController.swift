import UIKit

final class TravelViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var travelInfo: [Travel] = TravelInfo.travel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName: TravelCell.id, bundle: nil),
            forCellReuseIdentifier: TravelCell.id
        )
        tableView.register(
            UINib(nibName: AdCell.id, bundle: nil),
            forCellReuseIdentifier: AdCell.id
        )
    }
    
    override func didReceiveMemoryWarning() {
        print("\(Self.self), \(#function)")
    }
}

extension TravelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // tableView.deselectRow(at: indexPath, animated: false)
        // - [도시 상세 정보 화면] 에서 관광지셀을 선택하면 push 로 전환되는 화면입니다.
        // - [다른 관광지 보러 가기] 를 선택하면 pop 이 됩니다.
        let model = travelInfo[indexPath.row]
        
        if let isAd = model.ad, isAd {
            guard let vc = storyboard?.instantiateViewController(
                withIdentifier: AdViewController.id
            ) as? AdViewController else {
                return
            }
            vc.adText = model.title
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        } else {
            guard let vc = storyboard?.instantiateViewController(
                withIdentifier: TouristAttractionViewController.id
            ) as? TouristAttractionViewController else {
                return
            }
            vc.info = model
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        travelInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = travelInfo[indexPath.row]
        
        if let isAd = model.ad, isAd {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AdCell.id, for: indexPath) as? AdCell else {
                return UITableViewCell()
            }
            cell.set(info: model)
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TravelCell.id, for: indexPath) as? TravelCell else {
                return UITableViewCell()
            }
            cell.set(info: model)
            cell.selectionStyle = .none
            let isNextCellAd = (indexPath.row + 1 < travelInfo.count) && (travelInfo[indexPath.row + 1].ad == true)
            
            if isNextCellAd {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            } else {
                cell.separatorInset = .zero
            }
            cell.likeAction = { [weak self] value in
                guard let self = self else { return }
                self.travelInfo[indexPath.row].like = value
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            return cell
        }
    }
}

