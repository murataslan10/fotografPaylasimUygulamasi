//
//  9- Verileri dataBase'e kaydettikten sonra, yapilcak islemler (Fead'a gecis ve verileri orada gosterme)
//

import UIKit

class feedCell: UITableViewCell {
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var yorumText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
