import UIKit

class MenuTableViewController: UITableViewController {
	private let cellReuseIdentifier = "defaultCell"
	
	var viewModel: MenuViewModel?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = UITextConst.menu
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
		tableView.separatorStyle = .none
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel?.contentCount.value ?? 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) else { return UITableViewCell() }
		cell.textLabel?.text = viewModel?.getContentTitleFor(id: indexPath.row)
		cell.textLabel?.textAlignment = .center
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel?.startGameForContent(id: indexPath.row)
	}
}
