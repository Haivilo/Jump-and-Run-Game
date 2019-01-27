
import SpriteKit
class Play: SKScene {
    weak var vC: GameViewController!
    //connect to the view controller
    
    let person=SKSpriteNode(imageNamed: "running")
    //create a node for the stick man
    let bird=SKSpriteNode(imageNamed: "explosion1")
    //create a node for the bird
    let explosion=SKSpriteNode(imageNamed: "explosion1")
    //create a node for the explosion
    let heart=SKSpriteNode(imageNamed: "heart")
    //create the big heart to be collected
    let laserShot=SKSpriteNode.init(color: UIColor.red, size: CGSize(width: 100, height: 5))
    //define the laser
    var jumpSpeed:CGFloat=0
    //create a varible with CGfloat type to store the speed of elevating
    var runningSpeed=0.1
    //create a double variable as jump speed with initial of 0.1
    let block=SKSpriteNode.init(color: UIColor.black, size: CGSize(width: 10, height: 100))
    let block2=SKSpriteNode.init(color: UIColor.blue, size: CGSize(width: 10, height: 100))
    //create 2 blocks
    let laserGun=SKSpriteNode(imageNamed:"laserWeapon")
    //create laserGun
    let smallHeart=SKSpriteNode(imageNamed:"heartMark")
    let smallHeart2=SKSpriteNode(imageNamed:"heartMark")
    let smallHeart3=SKSpriteNode(imageNamed:"heartMark")
    //create 3 small hearts representing the lifes
    var blockSpeed:CGFloat=5
    var birdSpeed:CGFloat=2.5
    //create and initial block and bird moving speed
    var randomWidth:CGFloat=0
    var randomHeight:CGFloat=0
    var randomTime:CGFloat=0
    var randomWidth2:CGFloat=0
    var randomHeight2:CGFloat=0
    var randomTime2:CGFloat=0
    //create random sizes used for random location
    var speedIndex:CGFloat=0.98
    //create speed Index for speed increasing
    var collided=false
    //create a bool for determining collission
    var lifes=1
    //create and intial life of 1
    var laserCatched=false
    //create and initial no laser gun
    var fail=false
    //create and initial not fail game
    var mark=0
    //create a int variable recording mark
    let transparency=SKTexture.init(imageNamed: "transparent")
        //create a transparent background for hidden image
    let heartPic=SKTexture.init(imageNamed: "heartMark")
    //create heart for adding life
    let marklbl = SKLabelNode(fontNamed: "Papyrus")
    //create the label for displaying the mark
    let markPluslbl = SKLabelNode(fontNamed: "Papyrus")
    //create the label for displaying the mark
    let birdSound=SKAction.playSoundFileNamed("birdExplode.mp3", waitForCompletion: true)
    //create explosion sound for bird
    let laserGunLoadedSound=SKAction.playSoundFileNamed("laserGunSound.mp3", waitForCompletion: true)
    //create loaded sound for gun
    let lifeGotSound=SKAction.playSoundFileNamed("lifeSound.mp3", waitForCompletion: true)
    let backGrMusic=SKAudioNode(fileNamed:"background.mp3")
    //back ground music declare
    let building1=SKTexture.init(imageNamed: "building1")
    let building2=SKTexture.init(imageNamed: "building2")
    let building3=SKTexture.init(imageNamed: "building3")
    //declare various building shape
    let shooting=SKAudioNode(fileNamed:"shotSound.mp3")
    //create shooting sound
    func reLocateBlock() -> Void{
        let buildingArray=[building1,building2,building3]
        //define the array containing 3 building
        let index=Int(arc4random_uniform(UInt32(3)))
        //random an index for choosing the texture
        block.texture=buildingArray[index]
        //change texture
        randomWidth=CGFloat((arc4random_uniform((50))))+50
        randomHeight=CGFloat((arc4random_uniform(UInt32(0.3*size.height))))+0.1*size.height
        //resize the block
        randomTime=CGFloat((arc4random_uniform(500)))+500
        //define the new random time that it will spend to approach the screen
        block.size=CGSize(width: randomWidth, height: randomHeight)
        //resize
        block.position.x=size.width+block.size.width/2+randomTime
        block.position.y=randomHeight/2
        //relocate the block
    }
    func markPlus(score:Int) -> Void{
        //create a function to display the incresed mark
        markPluslbl.position = CGPoint(x: frame.midX+2*marklbl.frame.size.width, y: frame.size.height-30)
        //make it visible
        markPluslbl.text="+"+String(score)
        //display proper +1 or +5
        let fadedin=SKAction.sequence([SKAction.fadeOut(withDuration: 0.5),SKAction.fadeIn(withDuration: 0)])
        //fade in to disappear
        markPluslbl.run(fadedin, withKey: "disappear")
        //run animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
            self.markPluslbl.position.y+=30+self.markPluslbl.frame.height
            //when it disappeared, 0.4 sec later, relocate it so it's not visible
        }
    }
    func ifFail(){
        //when the game ends.
        let result = SKLabelNode(fontNamed: "Chalkduster")
        result.text = "Game Over!"
        result.fontSize = 65
        result.fontColor = SKColor.black
        result.position = CGPoint(x: frame.midX, y: frame.midY)
        //define the result label
        let fadein=SKAction.sequence([SKAction.fadeOut(withDuration: 0),SKAction.fadeIn(withDuration: 2)])
        //create the fade in animation
        addChild(result)
        result.run(fadein)
        //display the result label
        vC.Name.isHidden=false
        //display the textfield
        vC.resultBut.isHidden=false
        //display the button
        vC.endMark=mark
        //transfer the mark
    }
    func LaserAppear() -> Void{
        //when the laser should appear
        laserShot.position=CGPoint(x:0.5*laserShot.frame.width+person.frame.width*0.9,y:person.position.y+15)
        //laser appears
        if !fail{
            shooting.run(SKAction.play())
            
        }
        //play laser music when not end game
    }
    func LaserDisappear() -> Void{
        //when the laser should disappear
        laserShot.position=CGPoint(x:1.5*laserShot.frame.width+person.frame.width*0.9,y:-10)
        //laser disappears
        shooting.run(SKAction.stop())
        //stop music of laser
    }
    func relocateLaserGun() -> Void{
        var randomY:CGFloat=0.0
        //a CGFloat var to store random number
        randomY=CGFloat((arc4random_uniform(UInt32(0.3*size.height))))+0.5*size.height
        //randomHeight=30
        randomTime=CGFloat((arc4random_uniform(1000)))+1000
        laserGun.position.x=size.width+bird.size.width/2+randomTime
        //make sure the gun is out of the screen
        laserGun.position.y=randomY
        //use random number to locate the new coordinate of x,y
        if picTooClose(object1: laserGun, object2: heart)||picTooClose(object1: laserGun, object2: bird){
            relocateLaserGun()
            //run the function again if the objects are too close
        }
    }
    func relocateHeart() -> Void{
        var randomY:CGFloat=0.0
        //a CGFloat var to store random number
        randomY=CGFloat((arc4random_uniform(UInt32(0.3*size.height))))+0.5*size.height
        //randomHeight=30
        randomTime=CGFloat((arc4random_uniform(3000)))+1000
        heart.position.x=size.width+bird.size.width/2+randomTime
        //make sure the heart is out of the screen
        heart.position.y=randomY
        //use random number to locate the new coordinate of x,y
        if picTooClose(object1: heart, object2: bird)||picTooClose(object1: heart, object2: laserGun){
            relocateHeart()
            //run the function again if the objects are too close

        }
    }
    func picTooClose(object1: SKSpriteNode, object2: SKSpriteNode) -> Bool{
        //make a function to check if 2 objects are too close to each other
        let xA=object1.position.x
        let xB=object2.position.x
        //get the x coordinate of 2 objects
        let difference=abs(xA-xB)
        //find the distance between
        if difference<=200{
            //if closer than 200
            return true
        }
        return false
    }
    func reLocateBird() -> Void{
        var randomY:CGFloat=0.0
        //a CGFloat var to store random number
        randomY=CGFloat((arc4random_uniform(UInt32(0.3*size.height))))+0.5*size.height
        //randomHeight=30
        randomTime=CGFloat((arc4random_uniform(1000)))+1000
        bird.position.x=size.width+bird.size.width/2+randomTime
        //make sure the bird is out of the screen
        bird.position.y=randomY
        //use random number to locate the new coordinate of x,y
        if picTooClose(object1: bird, object2: laserGun)||picTooClose(object1: bird, object2: heart){
            reLocateBird()
            //run the function again if the objects are too close

        }
    }
    func reLocateBlock2() -> Void {
        let buildingArray=[building1,building2,building3]
        //define the array containing 3 building
        let index=Int(arc4random_uniform(UInt32(3)))
        //random an index for choosing the texture
        block2.texture=buildingArray[index]
        //change texture
        randomWidth2=CGFloat((arc4random_uniform((50))))+50
        randomHeight2=CGFloat((arc4random_uniform(UInt32(0.3*size.height))))+0.1*size.height
        //resize the block
       //randomHeight2=30
        randomTime2=CGFloat((arc4random_uniform(500)))+500
        //define the new random time that it will spend to approach the screen
        block2.position.x=block.position.x+randomTime2
        //make sure block2 has a distance from block1
        if block2.position.x<size.width{
            //if the distance is too small that it isn't out of the screen
            block2.position.x=size.width+randomTime2+0.5*randomWidth2
            //make it bigger
        }
        block2.size=CGSize(width: randomWidth2, height: randomHeight2)
        block2.position.y=randomHeight2/2
        //relocate the block
    }
    func collideResult() ->  Void{
        //actions after collided
        let posture=person.texture!
        //posture change to normal, no laser gun
        let transparency=SKTexture.init(imageNamed: "transparent")
        //texture for completing blink
        person.removeAction(forKey: "running")
        jumpSpeed=0
        //unable to jump
        let failArray=[transparency,posture]
        let failAnimation=SKAction.animate(with: failArray, timePerFrame: 0.4)
        person.run(SKAction.repeat(failAnimation, count: 3))
        //create and run blink animation
        guard !fail else{
            //run only when not end game
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8){
            self.person.position.y=self.size.height+self.person.frame.height/2
            self.person.run(SKAction.moveTo(y: 0.5*self.person.frame.height, duration: 1.2))
            //make the person drop from the air
            self.reLocateBlock()
            self.reLocateBlock2()
            self.reLocateBird()
            //relocate all objects
            
        }

 
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            self.collided = false
            //set collided to false, no collision
            self.person.run(SKAction.repeatForever(self.RunningAction(x:self.runningSpeed)), withKey: "running")
            //start running
        }
    }
    func hitTheBird() -> Void{
        let minY=bird.position.y-bird.frame.height/2
        let maxY=bird.position.y+bird.frame.height/2
        let minX=bird.position.x-bird.frame.width/2
        let maxX=bird.position.x+bird.frame.width/2
        let LocX=bird.position.x
        let LocY=bird.position.y
        //set the four sides location of the bird and its location
        let gunCheckPoint=person.position.y+15
        if minX>90 && maxX<frame.size.width{
            //when the bird is in the screen
            if gunCheckPoint>minY && gunCheckPoint<maxY{
                //when the laser meets bird
                explosion.run(explosionAction())
                //do explosion
                explosion.position=CGPoint(x:LocX,y:LocY)
                //set it to the bird position
                explosion.run(birdSound)
                //do the explosion sound
                reLocateBird()
                //relocate the bird
                mark+=5
                markPlus(score: 5)
                //add the mark and display it
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.72){
                    //after the animation compelets
                    self.explosion.position=CGPoint(x:2*self.frame.size.width,y:self.person.position.y+15)
                    //explosion goes away
                }
                
            }
        }
    }
    
    
    func RunningAction(x:Double) -> SKAction {
        let run1 = SKTexture.init(imageNamed: "running")
        let run2 = SKTexture.init(imageNamed: "running2")
        let run3 = SKTexture.init(imageNamed: "running3")
        let run4 = SKTexture.init(imageNamed: "running4")
        let run5 = SKTexture.init(imageNamed: "running5")
        let run6 = SKTexture.init(imageNamed: "running6")
        let run7 = SKTexture.init(imageNamed: "running7")
        //create 7 textures to store the animation
        let runningArray=[run1,run2,run3,run4,run5,run6,run7]
        //create an array representing the animation
        let runningAnimation = SKAction.animate(with: runningArray,
                                                timePerFrame: x)
        //create an action for the animation
        return runningAnimation
    }
    func laserAction(x:Double) -> SKAction {
        let laser1 = SKTexture.init(imageNamed: "laser1")
        let laser2 = SKTexture.init(imageNamed: "laser2")
        let laser3 = SKTexture.init(imageNamed: "laser3")
        let laser4 = SKTexture.init(imageNamed: "laser4")
        let laser5 = SKTexture.init(imageNamed: "laser5")
        let laser6 = SKTexture.init(imageNamed: "laser6")
        let laser7 = SKTexture.init(imageNamed: "laser7")
        //create 7 textures to store the animation for laser running
        let laserArray=[laser1,laser2,laser3,laser4,laser5,laser6,laser7]
        //create an array representing the animation
        let laserAnimation=SKAction.animate(with: laserArray,
                                            timePerFrame: x)
        return laserAnimation
    }
    func BirdAction(x:Double) -> SKAction {
        let bird1 = SKTexture.init(imageNamed: "bird1")
        let bird2 = SKTexture.init(imageNamed: "bird2")
        let bird3 = SKTexture.init(imageNamed: "bird3")
        let bird4 = SKTexture.init(imageNamed: "bird4")
        let bird5 = SKTexture.init(imageNamed: "bird5")
        let bird6 = SKTexture.init(imageNamed: "bird6")
        let bird7 = SKTexture.init(imageNamed: "bird7")
        let bird8 = SKTexture.init(imageNamed: "bird8")
        let bird9 = SKTexture.init(imageNamed: "bird9")

        
        //create 7 textures to store the animation for regular running
        let birdArray=[bird1,bird2,bird3,bird4,bird5,bird6,bird7,bird8,bird9]
        //create an array representing the animation
        let birdAnimation = SKAction.animate(with: birdArray,
                                                timePerFrame: x)
        //create an action for the animation
        return birdAnimation
    }
    func explosionAction() -> SKAction {
        let boom1=SKTexture.init(imageNamed: "explosion1")
        let boom2=SKTexture.init(imageNamed: "explosion2")
        let boom3=SKTexture.init(imageNamed: "explosion3")
        let boom4=SKTexture.init(imageNamed: "explosion4")
        let boom5=SKTexture.init(imageNamed: "explosion5")
        let boom6=SKTexture.init(imageNamed: "explosion6")
        let boom7=SKTexture.init(imageNamed: "explosion7")
        let boom8=SKTexture.init(imageNamed: "explosion8")
        let boom9=SKTexture.init(imageNamed: "explosion9")
        let boom10=SKTexture.init(imageNamed: "explosion10")
        let boom11=SKTexture.init(imageNamed: "explosion11")
        let boom12=SKTexture.init(imageNamed: "explosion12")
        //create 12 textures for the animation of boom
        let boomArray=[boom1,boom2,boom3,boom4,boom5,boom6,boom7,boom8,boom9,boom10,boom11,boom12]
        //create an array representing the animation
        let boomAnimation=SKAction.animate(with: boomArray, timePerFrame: 0.06)
        //create an action of animation
        return boomAnimation
    }
    func jumpSuccess(posXman:CGFloat,posYman:CGFloat,posXbox:CGFloat,widthBox:CGFloat, heightBox:CGFloat) -> Bool? {
        let minX=posXbox-0.5*widthBox
        let maxX=posXbox+0.5*widthBox
        let checkPoint=posYman-48
        let collide=(posXman>minX)&&(posXman<maxX)
        //create the transparent background
        let smallHeartArray=[smallHeart,smallHeart2,smallHeart3]
        //create the array to manipulate the hearts
        if collide{
            if checkPoint < heightBox{
                //if it really collides with block
                relocateLaserGun()
                relocateHeart()
                reLocateBird()
                //relocate flying object
                LaserDisappear()
                //laser disappears
                lifes-=1
                //decrease the life
                smallHeartArray[lifes].position.y=2*frame.size.height
                //one heart disappears
                if lifes==0{
                    //when no life
                    fail=true
                    //failed the game
                    ifFail()
                    //run function for fail condition
                }
                return false
            }
        }else{
            return true
        }
        return true
    }
    func checkIfLaser(object: SKSpriteNode) -> Bool {
        let HeightBottom=object.position.y-0.5*laserGun.size.height
        //find the value of the bottom of laser item
        let Left=object.position.x-0.5*laserGun.size.width
        //find the value of the left side of laser item
        let Right=object.position.x+0.5*laserGun.size.width
        //find the value of the right side of laser item
        let HeightTop=object.position.y+0.5*laserGun.size.height
        //find the value of the top of laser item
        let personTop=person.position.y+43
        //find the value of the top of stickman
        let personBottom=person.position.y-48
        //find the value of the bottom of stickman
        let personRight=person.position.x+47
        //find the right side of the stickman
        let collide=personRight>Left&&Right>50
        //see if x location meets
        let gun=(object==laserGun)
        //check if it is heart or gun
        if collide{
            //if their x loc meet
            if personBottom<HeightTop&&personBottom>HeightBottom{
                //if it meets from foot
                if gun{
                    person.run(laserGunLoadedSound)
                }else{
                    person.run(lifeGotSound)
                }
                //run proper sound
                return true
            } else if personTop>HeightBottom&&personTop<HeightTop{
                //meet from heat
                if gun{
                    person.run(laserGunLoadedSound)
                    
                }else{
                    person.run(lifeGotSound)
                }
                //run proper sound

                return true
            } else if personTop>HeightTop&&personBottom<HeightBottom{
                //meet through middle
                if gun{
                    person.run(laserGunLoadedSound)
                }else{
                    person.run(lifeGotSound)
                }
                //run proper sound
                return true
            }
            
        }
        return false
    }
    
    override func didMove(to view: SKView) {
       self.backgroundColor=UIColor.white
        //set the backgroung to white
        person.position=CGPoint(x:0.5*person.frame.width,y:0.5*person.frame.height)
        //define the position of the person to the right bottom
        block.position=CGPoint(x:0.5*size.width,y:0.5*block.frame.height)
        //define the block position
        relocateHeart()
        addChild(person)
        //show the person
        person.run(SKAction.repeatForever(RunningAction(x: runningSpeed)), withKey:"running")
        //make the person animate as it is running
        let run5 = SKTexture.init(imageNamed: "running5")
        //use run5 as jumping texture
        person.texture=run5
        //apply it to the person
        addChild(block)
        block2.position=CGPoint(x:0.5*size.width,y:0.5*block.frame.height)
        addChild(block2)
        //display block2
        reLocateBird()
        //randomize position of bird
        bird.run(SKAction.repeatForever(BirdAction(x: 0.05)), withKey:"bird")
        //bird with flying animation
        addChild(bird)
        //put bird on the screen
        relocateLaserGun()
        //randomize location of gun
        addChild(laserGun)
        //display gun
        laserShot.size.width=frame.size.width-person.size.width*0.8
        laserShot.position=CGPoint(x:0.5*laserShot.frame.width+person.frame.width*0.9,y:65)
        addChild(laserShot)
        //add laser gun to the screen
        explosion.position=CGPoint(x:2*frame.size.width,y:person.position.y+15)
        //make explosion out of the scene
        addChild(explosion)
        //make the explosion ready
        addChild(heart)
        //create heart.
        smallHeart.position=CGPoint(x:0.7*smallHeart.size.width, y:frame.size.height-0.75*smallHeart.size.height)
        smallHeart2.position=CGPoint(x:1.9*smallHeart.size.width, y:frame.size.height-0.75*smallHeart.size.height)
        smallHeart3.position=CGPoint(x:3.1*smallHeart.size.width, y:frame.size.height-0.75*smallHeart.size.height)
        //define positions of the hearts to top left.
        addChild(smallHeart)
        addChild(smallHeart2)
        addChild(smallHeart3)
        smallHeart2.position.y=2*frame.size.height
        smallHeart3.position.y=2*frame.size.height
        //put the 2 after hearts to disappear
        marklbl.text = String(mark)
        marklbl.fontSize = 30
        marklbl.fontColor = SKColor.black
        marklbl.position = CGPoint(x: frame.midX, y: frame.size.height-30)
        addChild(marklbl)
        //display the mark
        markPluslbl.text="+5"
        //display the increased mark number
        markPluslbl.fontColor = SKColor.black
        //set font
        self.markPluslbl.position.y=self.markPluslbl.frame.height+self.frame.size.height
        //set location of markplus out of screen first
        addChild(markPluslbl)
        //ready for display increase mark
        addChild(backGrMusic)
        //play backgroungmusic
        addChild(shooting)
        //prepare shooting music when laser is on
        shooting.run(SKAction.stop())
        //don't have laser sound at start
        let beam=SKTexture.init(imageNamed: "laserImage")
        laserShot.texture=beam
        //create the beam for laser shot
        reLocateBlock()
        reLocateBlock2()
        //randomize 2 block's position
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !collided && !fail else {
            return
        }
        //bird.removeAction(forKey: "bird")
        //bird.run(explosionAction())
        let dilation=frame.size.height/414.0
        //use the height of frame to declare proper speed figure
        if person.position.y == 0.5*self.person.frame.height{
            // if the person is at the ground
            jumpSpeed = -18*dilation
            //the speed of elevation is 18
            person.removeAction(forKey: "running")
            //stop the animation when in the air
            if laserCatched{
                //when it is carrying laser
            let run5 = SKTexture.init(imageNamed: "laser5")
                //create a sktexture in laser mode
                person.texture=run5
                //let the new image be the picture of the stick man when he is in the air.
                LaserAppear()
                //set laser following the person

            } else{
                //when it is just running
            let run5 = SKTexture.init(imageNamed: "running5")
                //create a sktexture in running mode
                person.texture=run5
                //let the new image be the picture of the stick man when he is in the air.

            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !collided && !fail else {
            return
        }//only when not collided or ended
        //when the click is done
        let dilation=frame.size.height/414.0
        //use the height of frame to declare proper speed figure
        if jumpSpeed < -10*dilation{
            //if the jumpSpeed is greater than 10
            jumpSpeed = -10*dilation
            //lower the jumpSpeed it to 10, in order to make it land quickly
        }
    }
    override func update(_ currentTime: TimeInterval) {
        guard !collided && !fail else {
            return
        }
        let dilation=frame.size.height/414.0
        //use the height of frame to declare proper speed figure
        let smallHeartArray=[smallHeart,smallHeart2,smallHeart3]
        //create the array to manipulate the hearts
        jumpSpeed+=0.6*dilation
        //the jump speed decreases because of the affect of gravity
        person.position.y-=jumpSpeed
        laserShot.position.y-=jumpSpeed
        //the person moves up and down based on the speed

        block.position.x-=blockSpeed
        block2.position.x-=blockSpeed
        //move blocks
        if block.position.x < -block.size.width/2{
            //when it passes the screen
            reLocateBlock()
            //relocate
            mark+=1
            //add mark if it passes the block1
            markPlus(score: 1)
            //display the mark increase
        if blockSpeed<12{
                runningSpeed=runningSpeed*Double(speedIndex)
                blockSpeed=blockSpeed/speedIndex
                birdSpeed=birdSpeed/speedIndex
            //increase speed of all objects only when blockSpeed<12

            }
        }

       
        if block2.position.x < -block2.size.width/2{
            //block2 passes
            reLocateBlock2()
            //relocate
            mark+=1
            //add mark if it passes the block2
            markPlus(score: 1)
            //display the mark increase
            if blockSpeed<12{
                runningSpeed=runningSpeed*Double(speedIndex)
                blockSpeed=blockSpeed/speedIndex
                birdSpeed=birdSpeed/speedIndex
                //increase speed of all objects only when blockSpeed<12

            }
            
        }


        if person.position.y<0.5*person.frame.height{
            //if the person is on the ground
            person.position.y=0.5*person.frame.height
            //don't let it go down, which will go out of the bound.
            LaserDisappear()
            //disappear the laser
            //remove sound
        }
        if laserShot.position.y < 65.0 {
            laserShot.position.y = 65.0
            //make laser shot on the ground
        }
        
        if jumpSpeed>0 && person.position.y<0.7*person.frame.height && 0.5*person.frame.height<person.position.y{
            //when it lands
            if laserCatched{
                //if it is carrying a laser gun
                person.run(SKAction.repeatForever(laserAction(x: runningSpeed)), withKey:"running")
                //start the laser running animation again when landed
                if laserGun.position.x < 1.3*size.width{
                    //when the new laser gun is comming
                    person.run(SKAction.repeatForever(RunningAction(x: runningSpeed)), withKey:"running")
                    //the running animation swtiches back to regular
                    let run5 = SKTexture.init(imageNamed: "run5")
                    //create a sktexture in laser mode
                    person.texture=run5
                    //let the new image be the picture of the stick man when he is in the air.
                    laserCatched=false
                    //laser gun dismissed
                }
            

            }else{
                //if it is only running
                person.run(SKAction.repeatForever(RunningAction(x: runningSpeed)), withKey:"running")
                //start the running animation again when landed
            }
            
        }
        if laserCatched && person.position.y<=0.5*person.frame.height{
            //when it is running on the ground with laser gun
            if laserGun.position.x < 1.3*size.width{
                    laserCatched=false
                //make laser gun dismissed
                    person.removeAction(forKey: "running")
                    //when the new laser gun is comming
                    person.run(SKAction.repeatForever(RunningAction(x: runningSpeed)), withKey:"running")
                    //the running animation swtiches back to regular
            
            }
            
        }
        
        if jumpSuccess(posXman: person.position.x, posYman: person.position.y, posXbox: block.position.x, widthBox: block.size.width, heightBox: block.size.height) == false{
            //check when collided with block1
            collided=true
            collideResult()
            //runcollided function and change collided to false
            laserCatched=false
            //the laserGun dismissed
        }
        
        if jumpSuccess(posXman: person.position.x, posYman: person.position.y, posXbox: block2.position.x, widthBox: block2.size.width, heightBox: block2.size.height) == false{
            //check when collided with block1
            collided=true
            collideResult()
            //runcollided function and change collided to false
            laserCatched=false
            //the laserGun dismissed
        }
 
 
        bird.position.x-=birdSpeed
        //the bird moves by birdSpeed everytime to left
        if bird.position.x < -bird.size.width/2{
            //if it is outside the screen
            reLocateBird()
            //relocate it
        }
        laserGun.position.x-=birdSpeed
        //the laserGun moves by birdSpeed everytime to left
        if laserGun.position.x < -laserGun.size.width/2{
            //if it is outside the screen
            relocateLaserGun()
            //relocate it
        }
        if checkIfLaser(object:laserGun){
            let run5 = SKTexture.init(imageNamed: "laser5")
            //create a sktexture in laser mode
            person.texture=run5
            //let the new image be the picture of the stick man when he is in the air.
            laserCatched=true
            relocateLaserGun()
            LaserAppear()
            //create the laser shot when in the sky

        }
        if laserCatched{
        hitTheBird()
            //run hit bird function when carrying a gun
        }
        if checkIfLaser(object:heart){
            //detect the collision between heart and person
            if lifes<=2{
                //when it doesn't have more lifes than2
            lifes+=1
            smallHeartArray[lifes-1].position.y=frame.size.height-0.75*smallHeart.size.height
                //give him a life
            }
            relocateHeart()
            //relocate teh heart to let it come again
        }
        //check if the bird is hit
        heart.position.x-=birdSpeed
        //move the heart
        marklbl.text=String(mark)
        //refresh mark
    }
    
    
}
