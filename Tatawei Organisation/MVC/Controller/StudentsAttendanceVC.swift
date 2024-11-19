//
//  StudentsAttendanceVC.swift
//  Tatawei Organisation
//
//  Created by Wesam Kadah on 16/11/2024.
//

import UIKit

struct Student {
    let id: String
    let name: String
    let image: UIImage
    var isAttended: Bool
}

class StudentsAttendanceVC: UIViewController, Storyboarded {
    
    //MARK: - Varibales
    var coordinator: MainCoordinator?
    var allStudents: [Student] = [
        Student(id: "111", name: "وسام شكري قدح", image: UIImage(named:"personal")!, isAttended: false),
        Student(id: "222", name: "جاستن بيبر الغامدي", image: UIImage(named:"personal")!, isAttended: false),
        Student(id: "333", name: "بيلي ايليش الزهراني", image: UIImage(named:"personal")!, isAttended: false),
        Student(id: "444", name: "ترامب العتيبي", image: UIImage(named: "personal")!, isAttended: false),
        Student(id: "555", name: "معاذ هند القحطاني", image: UIImage(named: "personal")!, isAttended: false),
        Student(id: "666", name: "توباك الحربي", image: UIImage(named: "personal")!, isAttended: false)
    ]
    var filteredStudents: [Student] = []

    //MARK: - IBOutleats
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filteredStudents = allStudents

        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    }
    //MARK: - @IBAction
    @IBAction func didPressedView(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    
    
    //MARK: - Functions

    @objc func textFieldDidChange(_ textField: UITextField) {
          guard let query = textField.text?.lowercased(), !query.isEmpty else {
              // If the text field is empty, show all students
              filteredStudents = allStudents
              tableView.reloadData()
              return
          }
          
          // Filter students by name
          filteredStudents = allStudents.filter { $0.name.lowercased().contains(query) }
          tableView.reloadData()
      }

}

extension StudentsAttendanceVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStudents.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentsAttendanceCell", for: indexPath) as! StudentsAttendanceCell
        let rank = indexPath.row + 1
        let student = filteredStudents[indexPath.row]
        
        cell.config(image: student.image, name: student.name, numbering: rank, isAttended: student.isAttended)
        
        cell.attendanceButtonTapped = { [weak self] isAttended in
            guard let self = self else { return }
            
            // Find the student in `allStudents` and toggle their state
            if let index = self.allStudents.firstIndex(where: { $0.name == student.name }) {
                self.allStudents[index].isAttended = isAttended
            }

        }
        return cell
    }
    
    
}

