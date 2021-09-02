// 1-Firebas ayarlari ve arayuz
// 2- arayuz segue ler
// 3- Kullici islemleri (Authentication Firebase)
// 4- Giris cikis islemleri (Scene Delegate UIwindows islemleri, kayitli kullanici hatirlama), (Kayitli kullanici cikisi)
// 5- Upload bolumunun tasarimi ve resim ve yazi kaydetme islemi (uploadView)
// 6- Upload butonu tiklandiktan sonraki fire bas islemleri (uploadView)
// 7- Birden fazla farkli data kaydedebilme
// 8- Verileri Kaydetme database kaydetme
// 9- Verileri dataBase'e kaydettikten sonra, yapilcak islemler (Fead'a gecis ve verileri orada gosterme)
// 10- Verileri gosterme, dataBase'den getirme 
// 11- Internetten fotograf cekmek (sd web image)
// 12- Tarihe gore fotogralari dizme ve filtreleme, class olusturma 


import UIKit
import Firebase // 3. firebase sinifi cagirildi


class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sifreTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    @IBAction func girisYapTiklandi(_ sender: Any) {
        
        if emailTextField.text != "" && sifreTextField.text != "" { //4. Kayitli email giris islemi
            Auth.auth().signIn(withEmail: emailTextField.text!, password: sifreTextField.text!) { (authdataresult, error) in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata Aldiniz Tekrar Deneyiniz")
                }else {
                    self.performSegue(withIdentifier: "toFeadVC", sender: nil)
                }
            }
        }else{
            hataMesaji(titleInput: "Hata", messageInput: "Email ve Parola Giriniz!")  // 4. Kayitli email giris islemi
        }
        
    }
    
    @IBAction func kayitOlTiklandi(_ sender: Any) {
      
        if emailTextField.text != "" && sifreTextField.text != ""{ // 3. eger email ve sifre bos degil ise
            //3.  Kayit olma islem
            Auth.auth().createUser(withEmail: emailTextField.text!, password: sifreTextField.text!) { (authdataresult, error) in
                if error != nil {   //3.firebase sinifini cagirip icindeki auth kullaniyoruz
                    self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata Aldiniz, Tekrar Deneyiniz")
                    //3. Hata mesaji firebase den geliyor, gelmez ise kendimize bir hata mesaji olusturduk
                }else{
                    self.performSegue(withIdentifier: "toFeadVC", sender: nil) // 3. Segue "auth" icinde olmali
                }
            }
            
            
        }else{
            hataMesaji(titleInput: "Hata", messageInput: "Email ve Parola Giriniz!")
        }
        
    }
    
    func hataMesaji(titleInput: String, messageInput: String){ //3. Uygulamada cok fazla hata mesaji kullanilacak onceden func. hazirlaniyor
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)  // 3.hata func.
    }
}

