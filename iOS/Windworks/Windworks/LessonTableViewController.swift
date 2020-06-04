//
//  LessonTableViewController.swift
//  Lesson
//
//  Created by Jane Appleseed on 11/15/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class LessonTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var lessons = [Lesson]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the sample data.
        loadSampleLessons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "LessonTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LessonTableViewCell  else {
            fatalError("The dequeued cell is not an instance of LessonTableViewCell.")
        }
        
        // Fetches the appropriate lesson for the data source layout.
        let lesson = lessons[indexPath.row]
        
        cell.nameLabel.text = lesson.name
        cell.photoImageView.image = lesson.photo
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            lessons.remove(at: indexPath.row)
            saveLessons()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    
    //MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new lesson.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let lessonDetailViewController = segue.destination as? LessonViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedLessonCell = sender as? LessonTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "Unknown")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedLessonCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedLesson = lessons[indexPath.row]
            lessonDetailViewController.lesson = selectedLesson
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "Unknown")")
        }
    }

    
    //MARK: Actions
    
    @IBAction func unwindToLessonList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? LessonViewController, let lesson = sourceViewController.lesson {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing lesson.
                lessons[selectedIndexPath.row] = lesson
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new lesson.
                let newIndexPath = IndexPath(row: lessons.count, section: 0)
                
                lessons.append(lesson)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the lessons.
            saveLessons()
        }
    }
    
    //MARK: Private Methods
    
    private func loadSampleLessons() {
        
        let photo_all = UIImage(named: "all")
        let photo_bk = UIImage(named: "basickeelboat")
        let photo_bc = UIImage(named: "basiccruising")
        let photo_bbc = UIImage(named: "bareboatcruising")
        let photo_btb = UIImage(named: "basictobareboat")

        guard let lesson1 = Lesson(name: "All",
                                   photo: photo_all,
                                   url: "https://www.windworkssailing.com/wp-content/uploads/mobile/all.html") else {
            fatalError("Unable to instantiate lesson1")
        }

        guard let lesson2 = Lesson(name: "Basic Keelboat",
                                   photo: photo_bk,
                                   url: "https://www.windworkssailing.com/wp-content/uploads/mobile/bk.html") else {
            fatalError("Unable to instantiate lesson2")
        }

        guard let lesson3 = Lesson(name: "Basic Crusing",
                                   photo: photo_bc,
                                   url: "https://windworkssailing.com/wp-content/uploads/mobile/bc.html") else {
            fatalError("Unable to instantiate lesson3")
        }
        
        guard let lesson4 = Lesson(name: "Bareboat Cruising",
                                   photo: photo_bbc,
                                   url: "https://www.windworkssailing.com/wp-content/uploads/mobile/bbc.html") else {
            fatalError("Unable to instantiate lesson4")
        }
        
        guard let lesson5 = Lesson(name: "Basic To Bareboat",
                                   photo: photo_btb,
                                   url: "https://www.windworkssailing.com/wp-content/uploads/mobile/btb.html") else {
            fatalError("Unable to instantiate lesson5")
        }

        lessons += [lesson1, lesson2, lesson3, lesson4, lesson5]
    }
    
    private func saveLessons() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(lessons, toFile: Lesson.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Lessons successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save lessons...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadLessons() -> [Lesson]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Lesson.ArchiveURL.path) as? [Lesson]
    }

}
