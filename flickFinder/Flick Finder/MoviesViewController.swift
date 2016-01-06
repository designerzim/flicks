//
//  MoviesViewController.swift
//  Flick Finder
//
//  Created by Eric Zim on 1/5/16.
//  Copyright © 2016 Eric Zim. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	
	var movies: [NSDictionary]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		
		
		// Do any additional setup after loading the view.
		
		let apiKey = "f90b40fed338ec99e894fc21438657ba"
		let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
		let request = NSURLRequest(URL: url!)
		let session = NSURLSession(
			configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
			delegate:nil,
			delegateQueue:NSOperationQueue.mainQueue()
		)
		
		let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
			completionHandler: { (dataOrNil, response, error) in
    if let data = dataOrNil {
			if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
				data, options:[]) as? NSDictionary {
					NSLog("response: \(responseDictionary)")
					
					self.movies = responseDictionary["results"] as? [NSDictionary]
					self.tableView.reloadData()
			}
    }
		});
		task.resume()

	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		if let movies = movies
		{
			print("indexes: \(movies.count)")
			return movies.count
		}
		else
		{
			print("movies is nil")
			return 0
		}
		
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
		
		let movie = self.movies![indexPath.row]
		let title = movie["title"] as! String
		let overview = movie["overview"] as! String
		
		cell.titleLabel.text = title
		cell.overviewLabel.text = overview

		print("row \(indexPath.row)")
		
		return cell
	}
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}