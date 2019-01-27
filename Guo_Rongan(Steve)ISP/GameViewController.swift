import UIKit
import SpriteKit

class GameViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var Name: UITextField!
    //declare the label contains name
    @IBOutlet weak var resultBut: UIButton!
    var endMark=0
    //declare the game scene
    var gameScene:Play!
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = Play(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        //automatically set the scene and present
        gameScene = scene as Play
        gameScene.vC = self
        //connect view controller and game controller
        Name.isHidden=true
        resultBut.isHidden=true
        //hide the object to display data
    }
    @IBAction func toResult(_ sender: Any) {
        //when going to the result page
        gameScene.backGrMusic.run(SKAction.stop())
        //stop backgroung music
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let leaderBoard=segue.destination as! resultVC
        //create a instance of resultVC to reference
        leaderBoard.newMark=gameScene.mark
        //pass mark integer to it
        guard Name != nil||Name.text=="" else {
            return
        }
        //prevent nothing in the name label
        leaderBoard.newName=Name.text!
        //pass name string to it
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
