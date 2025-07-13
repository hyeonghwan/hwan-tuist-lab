import UIKit

// 쇼핑목록, 즐겨찾기 여부, 구매완료 여부를 구조체로 관리
struct ShoppingItem {
    var isPurchased: Bool
    var isFavorite: Bool
    var content: String
}

final class ShoppingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var text: String = ""
    private var data: [ShoppingItem] = [
        ShoppingItem(isPurchased: false, isFavorite: false, content: "")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        tableView.register(
            UINib(nibName: AddPurcasedCell.id, bundle: nil),
            forCellReuseIdentifier: AddPurcasedCell.id
        )
        
        tableView.register(
            UINib(nibName: ShoppingListCell.id, bundle: nil),
            forCellReuseIdentifier: ShoppingListCell.id
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(keyboardDismiss(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func keyboardDismiss(_ sender: Any) {
        self.view.endEditing(true)
    }
}

extension ShoppingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 58
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : data.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            return nil
        }
        
        let deletAction = UIContextualAction(
            style: .normal,
            title: "삭제")
        { [weak self] (action, view, completionHandler) in
            self?.data.remove(at: indexPath.row)
            self?.tableView.reloadData()
            completionHandler(true)
        }
        deletAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deletAction])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddPurcasedCell.id) as? AddPurcasedCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            
            cell.action = { [weak self] string in
                if string.isEmpty {
                    if let controller = self?.alert("Empty", "비어있습니다. 글자를 입력해주세요")
                        .ok( { _ in }) {
                        self?.present(controller, animated: true)
                    }
                    return
                }
                
                if let flag = self?.data.contains(where: { $0.content == string }), flag {
                    if let controller = self?.alert("Duplicate", "Duplicated Value exist")
                        .ok( { _ in }) {
                        self?.present(controller, animated: true)
                    }
                    return
                }
                
                let item = ShoppingItem(isPurchased: false, isFavorite: false, content: string)
                self?.data.append(item)
                self?.tableView.reloadSections(.init(integer: 1), with: .automatic)
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingListCell.id) as? ShoppingListCell else {
                return UITableViewCell()
            }
            
            cell.checkAction = { [weak self] indexPath, flag in
                guard let self, let indexPath else {
                    return
                }
                self.data[indexPath.row].isPurchased = flag
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
            
            cell.favoriteAction = { [weak self] indexPath, flag in
                guard let self, let indexPath else {
                    return
                }
                self.data[indexPath.row].isFavorite = flag
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
            
            cell.indexPath = indexPath
            let data = data[indexPath.row]
            cell.changeState(data.isPurchased, data.isFavorite, data.content)
            
            if indexPath.row == 0 {
                cell.contentView.isHidden = true
            } else {
                cell.contentView.isHidden = false
            }
            return cell
        }
    }
}
