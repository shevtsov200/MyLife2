//
//  ListPeopleViewController.swift
//  MyLife2
//
//  Created by Ivan Rublev on 12/2/16.
//  Copyright (c) 2016 Ivan Rublev. All rights reserved.
//

import UIKit

/**
    Class to control the table view of the scene.
 */
class ListPeopleViewController: UITableViewController, ListPeoplePresenterOutput {
    var output: ListPeopleInteractorInput!
    var router: ListPeopleRouter!
    
    // MARK: Object lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        ListPeopleConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: View lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showListOnLoad()
    }
    
    // MARK: Event handling
    func showListOnLoad() {
        output.showPeopleList(ListPeople.Request(index: 0))
    }
    
    // MARK: Display logic
    func displayList(_ viewModel: ListPeople.Response.ViewModel) {
        itemsViewModel = viewModel.itemsViewModel
        tableView.reloadData()
    }
    
    // MARK: Table View
    var itemsViewModel: [ListPeople.Response.ViewModel.ItemViewModel]?
    
    /**
     The table view calls this method to find out how many rows it should
     show in any one section.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // We only have a single section and want one row per person.
        return itemsViewModel?.count ?? 0
    }
    
    
    /// The table view calls this method to set up each cell in the table for display.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask the table view to create a cell for us to use to show a person.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PersonCell

        guard let itemsViewModel = itemsViewModel else {
            return cell
        }

        // Get the person we are displaying for this row.
        let viewModel = itemsViewModel[indexPath.row]
        
        // Set the text and image in the cell.
        cell.objectIdentifier = viewModel.identifier
        cell.textLabel!.text = viewModel.preparedName
        cell.imageView!.image = viewModel.preparedImage
        
        // Now the cell has been setup, return it to the table view.
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            let request = ListPeople.Request(index: indexPath.row)
            output.deletePerson(request)
        }
    }
    
    @IBAction func unwindToPersonList(_ sender: UIStoryboardSegue) { }
}
