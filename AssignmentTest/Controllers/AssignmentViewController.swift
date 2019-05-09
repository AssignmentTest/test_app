//
//  AssignmentViewController.swift
//  AssignmentTest
//

import UIKit
import MBProgressHUD

class AssignmentViewController: UIViewController {

    //Mark :- Initalize Tableview Outlet
    @IBOutlet weak var postTableView: UITableView!
    
    //Mark :- Variables Declaration
    var arrayOfPosts:[Hits] = []
    let dateFormatter = DateFormatter()
    var page = 0
    var totalPages :Int!
    var selectedPost = 0
    var firstTime = true
    
    var progressHUD = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.postTableView.tableFooterView = UIView()
        self.page = 1
        
        progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.mode = .indeterminate
        progressHUD.tintColor = .black
        progressHUD.label.text = "Fetching  Posts"
        self.getPosts(page: page)
        self.firstTime = false
        // Do any additional setup after loading the view.
    }
    
    //Mark :- Switch Toggle Action
    @IBAction func switchToggle(_ sender: UISwitch) {
        let getPosts = arrayOfPosts[sender.tag]
        getPosts.isSelected = sender.isOn
        if sender.isOn{
            selectedPost = selectedPost + 1
        }else{
            selectedPost = selectedPost - 1
            selectedPost = selectedPost > 0 ? selectedPost : 0
        }
        self.title = "Selected Posts \(selectedPost)"
    }
    
    //Mark :- Date Converter
    func getDateFormat(strDate:String)->String{
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard dateFormatter.date(from: strDate) != nil else{return ""}
        
        let getDate = dateFormatter.date(from: strDate)!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: getDate)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// Mark :- TableView Delegate And Datasource Methods
extension AssignmentViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hitCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HitsResultTableViewCell
        hitCell.toggle.tag = indexPath.row
        let obj = arrayOfPosts[indexPath.row]
        
        hitCell.lblTitle.text = obj.lblTitle!
        hitCell.lblDate.text = getDateFormat(strDate: obj.lblDate)
        hitCell.toggle.setOn(obj.isSelected, animated: false)
        return hitCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! HitsResultTableViewCell
        cell.toggle.setOn(cell.toggle.isOn ? false : true, animated: true)
        self.switchToggle(cell.toggle)
    }
    
    //Mark :- Scrolling Pagination Method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.page <= self.totalPages{
            
            if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height )){
                
                    self.page = self.page + 1
                    self.getPosts(page: self.page)
                }
        }
    }
    
}

//Mark :- API Integration
extension AssignmentViewController{
    func getPosts(page:Int){
        
        APIManager.shared.searchByDateWith(tag: "story", page: "\(self.page)") { (response, success, message, page, totalpage) in
            
            DispatchQueue.main.async {
                self.progressHUD.hide(animated: true)

                if success!{
                    for i in response!{
                        self.arrayOfPosts.append(i)
                    }
                    self.page = page!
                    self.totalPages = totalpage
                    self.postTableView.reloadData()

                }else{
                    print(message ?? "")
                    self.totalPages = 0
                }
            }

        }
    }
}

