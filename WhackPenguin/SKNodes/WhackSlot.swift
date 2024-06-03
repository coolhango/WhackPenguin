// Last Updated: 2 June 2024, 3:42PM.
// Copyright © 2024 Gedeon Koh All rights reserved.
// No part of this publication may be reproduced, distributed, or transmitted in any form or by any means, including photocopying, recording, or other electronic or mechanical methods, without the prior written permission of the publisher, except in the case of brief quotations embodied in reviews and certain other non-commercial uses permitted by copyright law.
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHOR OR COPYRIGHT HOLDER BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// Use of this program for pranks or any malicious activities is strictly prohibited. Any unauthorized use or dissemination of the results produced by this program is unethical and may result in legal consequences.
// This code have been tested throughly. Please inform the operator or author if there is any mistake or error in the code.
// Any damage, disciplinary actions or death from this material is not the publisher's or owner's fault.
// Run and use this program this AT YOUR OWN RISK.
// Version 0.1

// This Space is for you to experiment your codes
// Start Typing Below :) ↓↓↓

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    
    var charNode: SKSpriteNode!
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        
        cropNode.addChild(charNode)
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + hideTime * 3.5) {
            [weak self] in
            self?.hide()
        }
        
        if let sparkParticles = SKEmitterNode(fileNamed: "Spark") {
            sparkParticles.position = charNode.position
            addChild(sparkParticles)
            
            sparkParticles.removeFromParent()
        }
        
    }
    
    func hide() {
        if !isVisible { return }
     
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
        if let sparkParticles = SKEmitterNode(fileNamed: "Spark") {
            sparkParticles.position = charNode.position
            addChild(sparkParticles)
            
            sparkParticles.removeFromParent()
        }
    }
    
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run {
            [weak self] in
            self?.isVisible = false
        }

        let sequence = SKAction.sequence([delay, hide, notVisible])
        charNode.run(sequence)
        
        guard let smokeParticles = SKEmitterNode(fileNamed: "Smoke") else { return }
        smokeParticles.position = charNode.position
        addChild(smokeParticles)
        
        smokeParticles.removeFromParent()
        
    }
    
}
