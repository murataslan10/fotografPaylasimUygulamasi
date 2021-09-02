//
// 5- Upload bolumunun tasarimi ve resim ve yazi kaydetme islemi//
// 6- upload butonu tiklandiktan sonraki fire bas islemleri
// 7- Birden fazla farkli data kaydedebilme (UUID)
// 8- Verileri firebase veriTabanina yuklleme
// 9- Verileri dataBase'e kaydettikten sonra, yapilcak islemler (Fead'a gecis ve verileri orada gosterme)


import UIKit
import Firebase // 6.

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate { //5. class ekleme
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var yorumTexyField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true  // 5. Image'i islem yapilabilir hale getirdim
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec)) //5. image tiklanabilir hale getirdim
        imageView.addGestureRecognizer(gestureRecognizer) //5. G.Rec. image'a ekliyorum
        
    }
    @objc func gorselSec(){
        
        let pickerController = UIImagePickerController()  // 5.fotograf secme func.
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil) // 5. gosterme
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {               // 5. Gorsel secildikten sonra ne olacak
        imageView.image = info[.originalImage] as? UIImage  // 5. bize ANY verilen degeri uiimage cast ettik ve image koyduk
        self.dismiss(animated: true, completion: nil)   // 5. geri donus
    }
    
    @IBAction func uploadButtonTiklandi(_ sender: Any) {
        
        let storage = Storage.storage()    // 6. Firebase bes storage icin degiskene atiyoruz, birkac yerde kullanilacak
        let storageReference = storage.reference()  //6. reference, firebase de depolama konumunu belirtiyor
        
        let mediaFolder = storageReference.child("media") // 6. Firebase de konuma bir klasor ekliyoruz
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){ // 6. image olarak depolanamayacagi icin DATA'ya ceviriyoruz
            
            let uuid = UUID().uuidString // 7. her fotografa bir string id atiyoruz
            let imageReference = mediaFolder.child("\(uuid).jpg")  // 6. olusturdugum datayi firebase media klasorune atiyorum, 7. uuid tanimi
            
            imageReference.putData(data, metadata: nil) { (storemetadata, error) in  //6. hazir olan fotoyu yukleme islemi
                if error != nil{      // 6. eger hata mesaji bos degil ise
                    self.hataMesajiGoster(titleInput: "Hata", messageInput: "Bir hata olustu, tekrar deneyiniz")  // 6. hata mesaji varsa, hataMesajiGoster devreye giriyor
                }else{
                    imageReference.downloadURL { (url, error) in  // 6. yuklenen fotonun URL'sini aliyoruz
                        if error == nil{    // 6. eger hata mesaji yok ise
                            let imageUrl = url?.absoluteString   // 6. Foto URL'sini Stringe ceviriyor
                            
                            if let imageUrl = imageUrl {  // opsiyonel imageUrl'yi opsiyonelden cikariyoruz
                            
                            let firestoreDatabase = Firestore.firestore()  // 8. firebase database'ne ulasiyoruz
                                
                                let firestorePost = ["gorselUrl": imageUrl, "yorum": self.yorumTexyField.text!, "email": Auth.auth().currentUser!.email, "tarih": FieldValue.serverTimestamp()] as [String: Any] // 8. bizden dataBase koyulacak klasorler ve degerleri isteniyor, burada olusturuldu
                                
                                firestoreDatabase.collection("Post").addDocument(data: firestorePost) { (error) in
                                    if error != nil {  // 8. databe'in icine post klasoru ve alt klasorleri olusturuluyor
                                        self.hataMesajiGoster(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Bir hata olustu, tekrar deneyiniz") // 8.hata mesaji varsa func. uygula, yoksa yukleme basarili
                                    }else{
                                        
                                        self.imageView.image = UIImage(named: "Tikla")
                                        self.yorumTexyField.text = ""
                                        self.tabBarController?.selectedIndex = 0
            // 9. dataBase'e yuklendikten sonra sayfayi Fead atiyorum ve resim ve yorum sayfasini bosaltiyorum
                                    }
                                }
                                
                                
                            }
                            
                        }
                    }
                }
            }
            
        }
        
    }
    
    func hataMesajiGoster(titleInput: String, messageInput: String){ //7. Uygulamada cok fazla hata mesaji kullanilacak onceden func. hazirlaniyor
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)  // 7.hata func.
    }
        
    
    
}
