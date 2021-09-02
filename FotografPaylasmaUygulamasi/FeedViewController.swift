//
//  9- Verileri dataBase'e kaydettikten sonra, mainStoryboard ayarlari, tableViewCell ayarlari
// 10- Verileri gosterme, dataBase'den getirme
// 11- Internetten fotograf cekmek (sd web image)
// 12- Tarihe gore fotogralari dizme ve filtreleme, class olusturma 

import UIKit
import Firebase
import SDWebImage // 11.

class FeedViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
   /* var emailDizisi = [String]()  // 10 database den gelen dizi ogeleri icin yeni bir dizi olusturduk
    var yorumDizisi = [String]()  // 10
    var gorseDizisi = [String]()   // 10 */
     
    @IBOutlet weak var table: UITableView!
    
    var postDizisi = [Post]() // 12 dizide sinif kullanmak
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.dataSource = self   //9. TableView
        table.delegate = self   // 9. TableView
        
        firebaseVerilerial() // 10
    }
    func firebaseVerilerial(){
        let firestoreDatabase = Firestore.firestore()  // // 10 database ulastik
        
        firestoreDatabase.collectionGroup("Post").order(by: "tarih", descending: true) //12. whereField() veri cekerken filtreleme, order neye gore siralayacagini gosteriyor
            .addSnapshotListener { (snapshot, error) in
            // 10. dataBase den "Post" a ulastik
            if error != nil{
                print(error?.localizedDescription) // 10 hata varsa yazdirdik
            }else{
                if snapshot?.isEmpty != true && snapshot != nil { // 10. dataBase den gelen dizileri
                    
                    //self.emailDizisi.removeAll(keepingCapacity: false) // 11. Fotograflari tekrar gosterme
                    //self.gorseDizisi.removeAll(keepingCapacity: false) // 11.Fotograflari tekrar gosterme
                    //self.yorumDizisi.removeAll(keepingCapacity: false) // 11.Fotograflari tekrar gosterme
                    self.postDizisi.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{   // 10.for loop ile teker teker dondurduk
                        // let documentId = document.documentID  // 10. documan id alma islemi
                        
                        if let gorselUrl = document.get("gorselUrl") as? String{
                            //self.gorseDizisi.append(gorselUrl) // 10. gelen any'leri string e cast ettik ve olusturdugumuz diziye ekledik
                            if let yorum = document.get("yorum") as? String{
                                //self.yorumDizisi.append(yorum)
                                if let email = document.get("email") as? String{
                                    //self.emailDizisi.append(email)
                                    
                                    let post = Post(email: email, yorum: yorum, gorselUrl: gorselUrl)
                                    self.postDizisi.append(post)// 12. Sinif kullanma
                                }
                            }
                        
                        }
                        
                    }
                    self.table.reloadData() // 10. en son tableView da gosterdik
                }
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDizisi.count  // 10. TableView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! feedCell
        cell.emailText.text = postDizisi[indexPath.row].email
        cell.yorumText.text = postDizisi[indexPath.row].yorum
        cell.postImageView.sd_setImage(with: URL(string: self.postDizisi[indexPath.row].gorselUrl)) // 11. cell degiskenine sd image ekliyoruz
        return cell   // 9. TableView normal tableView dan farkli feedCell cast edip icindeki ogeleri aliyoruz
    }


}
