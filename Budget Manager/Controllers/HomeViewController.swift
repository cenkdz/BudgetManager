import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    private let contacts = ContactAPI.getContacts() // model
    let contactsTableView = UITableView() // view
    let contacts: [String] = []
    
    



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        view.addSubview(contactsTableView)
        
        contactsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        contactsTableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        contactsTableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        contactsTableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        contactsTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        contactsTableView.dataSource = self
        contactsTableView.delegate = self

        
//      contactsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "contactCell")
        contactsTableView.register(HomeViewController.self, forCellReuseIdentifier: "contactCell")


    

        navigationItem.title = "Contacts"
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//      let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! EntryCellVC

//      cell.textLabel?.text = contacts[indexPath.row].name
        cell.categoryIcon = UIImageView(image: #imageLiteral(resourceName: "ic_feedback"))

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    


}
