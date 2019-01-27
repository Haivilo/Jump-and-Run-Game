//
//  resultVC.swift
//  Guo_Rongan(Steve)ISP
//
//  Created by Rongan Guo on 2018-01-26.
//  Copyright © 2018 Rongan Guo. All rights reserved.
//

import UIKit

class resultVC: UIViewController {
    var newMark=1
    //a int variable receive new mark
    var newName="anonymous"
    //a string variable receive name
    var scoreArray=[0,0,0]
    var nameArray=["","",""]
    //2 arrays represent score and name
    var rank=4
    //declare the rank of new person, if not in leader, assign4
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var name3: UILabel!
    @IBOutlet weak var mark1: UILabel!
    @IBOutlet weak var mark2: UILabel!
    @IBOutlet weak var mark3: UILabel!
    //declare the labels storing marks and names
    @IBOutlet weak var currentMark: UILabel!
    //declare the label displays mark
    @IBOutlet weak var feedBack: UILabel!
    //declare the label tells new rank
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if newName == ""{
            newName="anonymous"
        }//don't let the name empty
        if let storedArray=UserDefaults.standard.object(forKey: "result") as? Array<Int>{
            scoreArray=storedArray
            //if there is a stored number array, put it into scorearray
        }
        if let storedNameArray=UserDefaults.standard.object(forKey: "name") as? Array<String>{
            nameArray=storedNameArray
            //if there is a stored name array, put it into namerray
        }
        var counter=2
        for _ in 0...2{
            if scoreArray[counter]<=newMark{
                let temp=scoreArray[counter]
                let tempName=nameArray[counter]
                scoreArray[counter]=newMark
                nameArray[counter]=newName
                //replace the mark and name if it is bigger or equal, save a temp to use later
                rank=counter+1
                //record the rank
                if counter<2{
                    scoreArray[counter+1]=temp
                    nameArray[counter+1]=tempName
                    //if the second one changes, it becomes the third one, so does first one
                }
            }
            counter-=1
            //to decrease the comparing index
        }
        
        UserDefaults.standard.set(scoreArray, forKey: "result")
        UserDefaults.standard.set(nameArray, forKey: "name")
        //save the data of score and name to userDefault
        print(scoreArray)
        print(newMark)
        name1.text=nameArray[0]
        name2.text=nameArray[1]
        name3.text=nameArray[2]
        //display ranked name
        mark1.text=String(scoreArray[0])
        mark2.text=String(scoreArray[1])
        mark3.text=String(scoreArray[2])
        //display ranked mark
        currentMark.text="Your mark: "+String(newMark)
        //display the new mark
        if rank<=3{
            feedBack.text="You are N0."+String(rank)
        }//give positive feed back if in the leader board
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
