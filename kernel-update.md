Browser Kernel Update Guide
--------------------------------
Things become pretty easy once involve git to the kernel update procedure.
The basic idea is using `git rebase` to update our branch **115** to a higher version of the `master` branch.

our current position in the git revision tree
         
         	 		 	    o--..--o 115
	    				   /
		 	   o--o--...--o 49.0.2623.75
			  /
	   A--B--C--...--X--Y--Z master
	   
After we do `git rebase --onto C 49.0.2623.75 115`

			   o--..--o 115 
			  /
			  | o--o--...--o 49.0.2623.75
		      |/
		A--B--C--...--X--Y--Z master

Last phase, do the rebase again, `git rebase 115 master`

			   o--o--...--o 49.0.2623.75
		      /
		A--B--C--...--X--Y--Z master
							 \
							  o--..--o 115
Let git handle the rebase work, we only need to focus on merge, and fix conficts.

	

Update Steps
------------
**Step 1**, add a git remote to the chromium project repository, and fetch the latest change. 

	#Make sure you are at "master" branch first
	#orgin: git@gitlabapp.115rc.com:115browser/src.git
	
	git remote add google https://chromium.googlesource.com/chromium/src.git
	git fetch google
	git branch -u origin/master master
	git push origin master
	
**Step 2**, get dependencies for both Windows and Mac. You could refer to the chromium documentation [working with release branches](https://www.chromium.org/developers/how-tos/get-the-code/working-with-release-branches)
	
	# Assume you're upgrade to 50.0.xxxx.xx
	git checkout -b your_branch 50.0.xxxx.xx
	gclient sync --with_branch_heads --jobs 16
	
Now you are at the targe branch, use script **cpdep.py** to separate the dependencis, you could find the script at [https://github.com/zhaorui/ChromiumTools/blob/master/cpdep.py](https://github.com/zhaorui/ChromiumTools/blob/master/cpdep.py) To use the script is very simple

	 cpdep /path/to/115/src /path/to/platform/dep [--platform=[win,mac]]
dependencies would saved to *path/to/platform/dep*, zip the dependencies then upload it to share folder.


**Step 3**, rebase 115 branch onto master branch, if it's not on it.
	
	git rebase --onto tags/49.0.2623.0^ 115  (not tested, but should work)
	
or you could use `git cherry-pick` to do the job
	
	git checkout -b new_115_branch 49.0.2623.0^
	
	#A is the first commit of 115 branch, B is the last
	git cherry-pick A..B 
	
You probably would see conflicts or files need to merge. Just simply run

	git mergetool

**Step 4**, rebase 115 branch onto the higer version commit of the master. This step is just like **step 3**, but there would be more files needed to be merge.



	