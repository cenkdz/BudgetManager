//
//  AddIncomeTableViewController.swift
//  BudgetManager
//
//  Created by Cenk Donmez on 1.12.2020.
//  Copyright © 2020 Cenk Donmez. All rights reserved.
//

import QuickTableViewController
import UIKit

class AddIncomeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
         tableContents = [
            Section(title: "Switch", rows: [
                SwitchRow(text: "Setting 1", switchValue: true, action: { _ in }),
                SwitchRow(text: "Setting 2", switchValue: false, action: { _ in })
                ]),
            
            Section(title: "Tap Action", rows: [
                TapActionRow(text: "Tap action", action: { [weak self] in self?.showAlert($0) })
                ]),
            
            Section(title: "Navigation", rows: [
                NavigationRow(text: "CellStyle.default", detailText: .none, icon: .named("gear")),
                NavigationRow(text: "CellStyle", detailText: .subtitle(".subtitle"), icon: .named("globe")),
                NavigationRow(text: "CellStyle", detailText: .value1(".value1"), icon: .named("time"), action: { _ in }),
                NavigationRow(text: "CellStyle", detailText: .value2(".value2"))
                ], footer: "UITableViewCellStyle.Value2 hides the image view."),
            
            RadioSection(title: "Radio Buttons", options: [
                OptionRow(text: "Option 1", isSelected: true, action: didToggleSelection()),
                OptionRow(text: "Option 2", isSelected: false, action: didToggleSelection()),
                OptionRow(text: "Option 3", isSelected: false, action: didToggleSelection())
                ], footer: "See RadioSection for more details.")
        ]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func showAlert(_ sender: Row) {
        // ...
    }
    
    private func didToggleSelection() -> (Row) -> Void {
        return { [weak self] row in
            // ...
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
