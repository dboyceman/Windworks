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
        
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30.0)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)

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
        
        cell.captionLabel.numberOfLines = 0
        cell.captionLabel.lineBreakMode = .byWordWrapping
        cell.captionLabel.font = cell.captionLabel.font.withSize(14)
        cell.captionLabel.textColor = .cyan
        cell.captionLabel.text = lesson.caption
        
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
        let photo_windshare = UIImage(named: "windshare")
        let photo_racing = UIImage(named: "racing")
        let photo_liveaboard = UIImage(named: "liveaboard")
        let photo_powerboat = UIImage(named: "powerboat")
        let photo_navigation = UIImage(named: "navigation")
        let photo_event = UIImage(named: "event")
        let photo_skippered = UIImage(named: "skippered")
        
        guard let lessonSingleDayCharter = Lesson(
            name: "US Sailing Day Courses",
            caption: "Want to charter a boat for the day?  View all lessons required for sailors to charter a day trip.",
            photo: photo_bk,
            url: "https://fareharbor.com/embeds/book/windworkssailing/items/?selected-items=36436,15027,214078,15033,218171,15035,218180,15036,15038,15041&flow=19676&full-items=yes") else {
                fatalError("Unable to instantiate lessonSingleDayCharter")
            }

        guard let lessonMultiDayCharter = Lesson(
            name: "US Sailing Overnight Courses",
            caption: "Dreaming of a trip to the San Juan Islands?  View all lessons required for sailors to charter a multi-day trip.",
            photo: photo_bc,
            url: "https://fareharbor.com/embeds/book/windworkssailing/?selected-items=15043,218184,25037,218264,242147,40395,218302,50279&full-items=yes&flow=19676") else {
                fatalError("Unable to instantiate lessonMultiDayCharter")
            }

        guard let lessonPowerboating = Lesson(
            name: "US Powerboating Course",
            caption: "Interested in crusing on a powerboat?  Ready to learn more about displacement hulls and bow thrusters?",
            photo: photo_powerboat,
            url: "https://fareharbor.com/embeds/book/windworkssailing/?selected-items=15077") else {
                fatalError("Unable to instantiate lessonAll")
            }

        guard let lessonNavigation = Lesson(
            name: "Navigation Courses",
            caption: "Tides and Currents and Dead reckoning, oh my! - get ready to read maps and plot a course.",
            photo: photo_navigation,
            url: "https://fareharbor.com/embeds/book/windworkssailing/?selected-items=43781,15059,15075,72013&full-items=yes&flow=19676") else {
                fatalError("Unable to instantiate lessonLiveAboard")
            }
        
       guard let lessonClinics = Lesson(
            name: "Clinics",
            caption: "Want to learn something new or touch up on a skill?  Visit our clinics for upcoming classes",
            photo: photo_bbc,
            url: "https://fareharbor.com/embeds/book/windworkssailing/?selected-items=15096,15081,21830,15084,15093,72013&full-items=yes&flow=19676") else {
               fatalError("Unable to instantiate lessonClinics")
            }

        guard let lessonEvents = Lesson(
             name: "Events",
             caption: "Join in on the fun with other sailors by signing up for one of our scheduled events",
             photo: photo_event,
             url: "https://fareharbor.com/embeds/book/windworkssailing/?selected-items=15113,18509,29299&full-items=yes&flow=19676") else {
                fatalError("Unable to instantiate lessonClinics")
             }

       guard let lessonRaces = Lesson(
            name: "Races",
            caption: "Race time - see all the race events.",
            photo: photo_racing,
            url: "https://fareharbor.com/embeds/book/windworkssailing/?selected-items=15109,108194,218301,45885&full-items=yes&flow=19676") else {
               fatalError("Unable to instantiate lessonRaces")
            }
        
        guard let lessonWindshare = Lesson(
            name: "Windshare (Members Only)",
            caption: "Want to join in on an existing charter?  Check out all the charters available for joining",
            photo: photo_windshare,
            url: "https://fareharbor.com/embeds/book/windworkssailing-members/items/calendar/") else {
                fatalError("Unable to instantiate lessonWindshare")
            }
        
        guard let lessonCharterRentals = Lesson(
            name: "Charter Fleet Rentals",
            caption: "Ready to schedule your charter?  Check out the fleet availability and schedule your next adventure",
            photo: photo_btb,
            url: "https://www.planyo.com/booking.php?calendar=21980") else {
                fatalError("Unable to instantiate lessonCharterRentals")
            }

        guard let lessonSkippered = Lesson(
            name: "Skippered Charters",
            caption: "Ready for a new adventure but want some help?  Learn more about our skippered charters.",
            photo: photo_skippered,
            url: "https://www.windworkssailing.com/skippered-charters-mobile/") else {
                fatalError("Unable to instantiate lessonCharterRentals")
            }

        guard let lessonPrivate = Lesson(
            name: "Private Lessons",
            caption: "Have specific skills you want help with?  Learn more about our private lessons.",
            photo: photo_all,
            url: "https://www.windworkssailing.com/contact-mobile/") else {
                fatalError("Unable to instantiate lessonCharterRentals")
            }

        lessons += [lessonSingleDayCharter, lessonMultiDayCharter, lessonPowerboating, lessonNavigation, lessonClinics, lessonRaces, lessonWindshare, lessonCharterRentals, lessonSkippered, lessonPrivate]
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
