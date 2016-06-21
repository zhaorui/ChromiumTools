#Basic Git You Need to Know

##Get the code
Create your working folder, then get the source code.
		
	mkdir ~/115Browser 
	git clone http://gitlabapp.115rc.com/115browser/src.git

Now, get the dependencies for your platform.

* Go to smb or ftp share server. 
	* For **Windows**, go to \\\\zhaoruis-imac\GitMigrate
	* For **Mac**, go to smb://zhaoruis-imac.local/GitMigrate
 
* Download dpendencies. ~~Temporarily, the dependencies are managed by svn server, go to **src/115chrome/dependencies/49.0.2623.75** to download~~. 
	*  For **Windows**, download dep_win.tar.gz  
	*  For **Mac**, download dep_mac.tar.gz
* Extract the dependency to your src folder.
* Make sure you deploy your **depot_tools** well in your platform, if not please refer to the chromium documentation [depot_tools setup](https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools_tutorial.html#_setting_up). You can find **depot_tools.zip** in the our share folder.
* You'd better install [lantern](https://github.com/getlantern/lantern) to your machine, it helps us to go through the GFW(the great fire wall), we still need to download some very small dependencies from the Internet.
* Download file **.gclient** from share folder, and put it to your *~/Chromium*.  
  Then run below command, it would fetch 
	
		gclient sync --with_branch_heads	
		
##Workflow with Git
Please make yourself be familiar with below commands, there are plenty of resources about them in the Internet.

+ git branch
+ git checkout
+ git add 
+ git commit
+ git fetch
+ git merge
+ git push

### Simplest workflow
Always work on the **115** branch, if not just checkout the branch by `git checkout 115`.
Work on the code, when you're finished, try to commit to your local 115 branch
	
	git add file
	git commit -m "Fix a bug"
	
Before you push your commit to git server, make sure you're on the top of the **remote/origin/115**

	git fetch

If your commit is diverged from the **remotes/origin/115**, merge it.

	git reset --soft HEAD^	  #undo your commit
	git merge				  #fast-forward to the latest 115
	git commit -m "Fix a bug" #commit again

Finally, your branch is the latest, push your commit.

	git push origin 115
	
### Advanced workflow (optional)
This workflow require you're familiar with `git rebase`
Before you start coding, checkout your own branch.
	
	git checkout -b "FIX"

Same as the [Simplest workflow](#Simplest workflow), commit you change to your own branch _FIX_

	git add file
	git commit -m "Fix a bug"

Done with the code, before you push your commit to remote, check if remote updated

	git fetch origin
	git rebase origin/115
	
	#optional, to squash your mutiple commit into one.
	git rebase -i origin/115
	
Solved merge conflicts if it exists, then push your change to remote.
	
	git checkout 115
	git rebase FIX
	git fetch  #check if you're on the latest 115
	git push origin 115 #if you're push your change
	
####Good articles about rebase work flow
[A rebase-based workflow](http://unethicalblogger.com/2010/04/02/a-rebase-based-workflow.html)  
[Git team workflows: merge or rebase?](https://www.atlassian.com/git/articles/git-team-workflows-merge-or-rebase/)

##FAQ

###What if I am not at branch 115?  
	git checkout -b 115 remotes/origin/115
	
###I met the file conflict, what should I do?
	git mergetool
	
###How to undo my misbehaviour?
find out which point you want to go back
	
	git reflog
then go back
	
	git reset --hard HEAD@{53}


