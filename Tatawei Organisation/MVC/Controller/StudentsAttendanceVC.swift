//
//  StudentsAttendanceVC.swift
//  Tatawei Organisation
//
//  Created by Wesam Kadah on 16/11/2024.
//

import UIKit

class StudentsAttendanceVC: UIViewController, Storyboarded, StudentsAttendanceDelegate {
    
    //MARK: - Varibales
    var coordinator: MainCoordinator?
    var opportunityID: String?
    var opportunityStudents: [Student] = []
    var filteredStudents: [Student] = []
    
    var indexSearchedContacts: Int?
    var indexContactsArray: Int?

    //MARK: - IBOutleats
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllStudents()
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.hideKeyboardWhenTappedAround()
    }
    
    //MARK: - @IBAction
    @IBAction func didPressedView(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    //MARK: - Functions
    
    func loadAllStudents() {
        if let opportunityID = opportunityID {
            let allStudents = StudentRealmService.shared.getStudentsForOpportunity(opportunityID: opportunityID)
            print(allStudents)
            self.opportunityStudents = allStudents
            filteredStudents = opportunityStudents
            tableView.reloadData()
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
          guard let query = textField.text?.lowercased(), !query.isEmpty else {
              // If the text field is empty, show all students
              filteredStudents = opportunityStudents
              tableView.reloadData()
              return
          }
          
          // Filter students by name
          filteredStudents = opportunityStudents.filter { $0.name.lowercased().contains(query) }
          tableView.reloadData()
      }

}

extension StudentsAttendanceVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStudents.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentsAttendanceCell", for: indexPath) as! StudentsAttendanceCell
        let rank = indexPath.row + 1
        let student = filteredStudents[indexPath.row]
        
        cell.config(image: student.gender == .male ? #imageLiteral(resourceName: "man.svg") : #imageLiteral(resourceName: "women.svg"), name: student.name, numbering: rank, isAttended: student.isAttended ?? false)
        
        cell.indexPath = indexPath
        cell.delegate = self
 
        return cell
    }
    
    func chooceNumberTapped(at index: IndexPath) {
        // Toggle attendance for the tapped student
        let student = filteredStudents[index.row]
        let isAttended = !(student.isAttended ?? false)
        filteredStudents[index.row].isAttended = isAttended
        
        // Sync changes to opportunityStudents
        if let studentIndex = opportunityStudents.firstIndex(where: { $0.id == student.id }) {
            opportunityStudents[studentIndex].isAttended = isAttended
        }
        StudentRealmService.shared.updateIsAttendedForStudentInOpportunity(studentID: student.id, opportunityID: opportunityID!, isAttended: isAttended)
        tableView.reloadRows(at: [index], with: .automatic)
    }
    
}

