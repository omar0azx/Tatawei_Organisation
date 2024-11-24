//
//  StudentsAttendanceVC.swift
//  Tatawei Organisation
//
//  Created by Wesam Kadah on 16/11/2024.
//

import UIKit

class StudentsVC: UIViewController, Storyboarded, StudentsAttendanceDelegate {
    
    enum Mode {
        case attendance
        case acceptance
    }
    
    
    //MARK: - Varibales
    
    var mode: Mode = .attendance
    
    var coordinator: MainCoordinator?
    var opportunityID: String?
    var opportunityStudents: [Student] = []
    var filteredStudents: [Student] = []
    
    var studnetIDsAccepted: [String] = []
    
    var indexSearchedContacts: Int?
    var indexContactsArray: Int?

    //MARK: - IBOutleats
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definePageType()
        loadAllStudents()
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.hideKeyboardWhenTappedAround()
    }
    
    func definePageType() {
        if mode == .acceptance {
            descriptionLabel.text = "الرجاء إختيار وقبول الطالب"
            buttonView.isHidden = false
            buttonView.alpha = 1
        } else {
            descriptionLabel.text = "الرجاء تحديد الدائرة الرمادية لتحضير الطلاب"
            buttonView.isHidden = true
            buttonView.alpha = 0
        }
        
    }
    
    //MARK: - @IBAction
    
    
    @IBAction func didPressedView(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didPressedAccept(_ sender: UIButton) {
        guard let opportunityID = opportunityID else {return}
        
        guard let opportunity = OpportunityRealmService.shared.getOpportunityById(opportunityID) else { return }
        let totalAcceptedStudents = opportunity.acceptedStudents + studnetIDsAccepted.count
        
        if  totalAcceptedStudents > opportunity.studentsNumber {
            let errorView = MessageView(message: "عدد الطلاب المقبولين اكبر من المطلرب ب(\(totalAcceptedStudents - opportunity.studentsNumber)) طلاب", animationName: "warning", animationTime: 1)
            errorView.show(in: self.view)
        } else {
            if !studnetIDsAccepted.isEmpty {
                StudentDataService.shared.updateStudentsAcceptance(opportunityID: opportunityID, studentIDs: studnetIDsAccepted) { error in
                    if error == nil {
                        print("Success students acceptance")
                        let successView = MessageView(message: "تم قبول الطلاب بنجاح", animationName: "correct", animationTime: 1)
                        successView.show(in: self.view)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            OpportunityDataService.shared.updateOpportunityStatus(opportunityID: opportunityID, status: .inProgress)
                            OpportunityDataService.shared.updateOpportunityNumberStudents(opportunityID: opportunityID, studentsNumbser: self.studnetIDsAccepted.count)
                            self.dismiss(animated: true)
                        }
                    } else {
                        let errorView = MessageView(message: "يوجد مشكلة في قبول الطلاب، او تجاوز العدد المطلوب", animationName: "warning", animationTime: 1)
                        errorView.show(in: self.view)
                        print("Failed students acceptance")
                    }
                }
            } else {
                let errorView = MessageView(message: "لا يوجد طلاب حتى الآن لقبولهم", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
            }
        }
    }
    
    
    //MARK: - Functions
    
    func loadAllStudents() {
        if let opportunityID = opportunityID, let organisation = Organization.currentOrganization {
            if mode == .attendance {
                let allStudents = StudentRealmService.shared.getStudentsForOpportunity(opportunityID: opportunityID)
                print(allStudents)
                self.opportunityStudents = allStudents
                filteredStudents = opportunityStudents
                tableView.reloadData()
            } else {
                let loadView = MessageView(message: "يرجى الإنتظار", animationName: "loading", animationTime: 1)
                loadView.show(in: self.view)
                StudentDataService.shared.getStudentsForAcceptance(organisationID: organisation.id, opportunityID: opportunityID) { error, students in
                    if let error = error {
                        print("Error loading students for acceptance: \(error.localizedDescription)")
                    } else {
                        print(students)
                        self.opportunityStudents = students
                        self.filteredStudents = self.opportunityStudents
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }

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

extension StudentsVC: UITableViewDelegate, UITableViewDataSource {
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
            if mode == .attendance {
                opportunityStudents[studentIndex].isAttended = isAttended
            } else {
                if isAttended {
                    // Add to accepted list if attended
                    if !studnetIDsAccepted.contains(opportunityStudents[studentIndex].id) {
                        studnetIDsAccepted.append(opportunityStudents[studentIndex].id)
                    }
                } else {
                    // Remove from accepted list if unmarked
                    if let indexToRemove = studnetIDsAccepted.firstIndex(of: opportunityStudents[studentIndex].id) {
                        studnetIDsAccepted.remove(at: indexToRemove)
                    }
                }
            }
        }
        
        if mode == .attendance {
            StudentRealmService.shared.updateIsAttendedForStudentInOpportunity(studentID: student.id, opportunityID: opportunityID!, isAttended: isAttended)
        }
        
        // Update the specific row in the table view
        tableView.reloadRows(at: [index], with: .automatic)
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mode == .acceptance {
            coordinator?.viewStudentInfo(student: filteredStudents[indexPath.row])
        }
    }
    
}

