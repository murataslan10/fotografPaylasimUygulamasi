//
//
// 4. Kayitli kullanici cikis islemi

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cikisYapTiklandi(_ sender: Any) { //4. Kayitli kullanici cikis islemi
        
        do{                         // 4.segue den once cikis islemi
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        }catch{
            print("Hata")
        }
        
        
        
    }
    
}
