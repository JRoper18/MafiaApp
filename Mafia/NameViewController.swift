//
//  NameViewController.swift
//  Mafia
//
//  Created by Jack Roper on 7/29/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Instruction"{
            let dvc = segue.destinationViewController as! InstructionViewController
        }
        else if segue.identifier == "Second"{
            let dvc = segue.destinationViewController as! SecondViewController
            dvc.playersName = "\(nameTextField.text!)"
        }
    }
}