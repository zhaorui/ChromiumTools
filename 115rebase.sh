#!/bin/bash

RESTORE='\033[0m'
ERROR='\033[00;31m'
PASS='\033[00;32m'
EM='\033[01;37m'
WARNING='\033[00;33m'

CURRENT_BASE="49.0.2623.75"
TARGET_BASE="50.0.2661.102"
SVN_SOURCE="/Users/zhaorui/49_svn/chromium49.0.2623.75/src/"

#
function isOnTrunk {
	return false
}

echo -e "${EM}reset branch 115 to 49.0.2623.75 checkout...${RESTORE}"
cd /Users/zhaorui/Chromium/src
	
git checkout -q $CURRENT_BASE
git branch -q -D 115 2> /dev/null
git checkout -b 115
#git reset --hard $CURRENT_BASE

#FIXME now we remove below repository manually
#If we are not at 49.0.2623.75, there must be different repo to remove
git clean -f -d
rm -rf third_party/flatbuffers
rm -rf third_party/libphonenumber/dist
rm -rf third_party/libvpx
rm -rf third_party/shaderc/

#gclient sync, not necessary
# gclient sync > /dev/null
# if [ "$?" -ne 0 ]; then
# 	echo -e "${WARNING}gclient sync failed, but let's go on...${RESTORE}"
# fi

echo -e "${EM}Merging 115 code to chromium ${RESTORE}"
rsync -a --delete --exclude-from="${SVN_SOURCE}/.gitignore" \
	  --exclude=".git" --exclude=".gitignore" 				\
	  --exclude="/third_party/WebKit/LayoutTests" 			\
	  --exclude="/third_party/android_platform"				\
	  --exclude="/third_party/libvpx"						\
	  --exclude="/third_party/libphonenumber/dist"			\
	  --exclude="/third_party/crashpad"						\
	  --exclude="/third_party/crashpad copy"				\
	  $SVN_SOURCE /Users/zhaorui/Chromium/src/

if [[ $? -ne 0 ]]; then
	echo -e "${ERROR} rsync failed to copy 115 source code to Chromium. errno: $? ${RESTORE}"
	exit 1
fi

git add -A .
git commit -m "Add 115 Patch"
PATCH_COMMIT=`git rev-list -n1 HEAD`
echo -e "Patch commit is ${PASS} ${PATCH_COMMIT} ${RESTORE}"
git clone --bare ../src ../src.git

# BACK_TO_MASTER_BASE=`echo $CURRENT_BASE | sed -e "s/^\(.*\)\..*$/\1.0/"`
# echo -e "${EM}Moving to ${BACK_TO_MASTER_BASE} ${RESTORE}"
# git branch -q -d 115onMaster
# git checkout -b 115onMaster ${BACK_TO_MASTER_BASE}^
# git cherry-pick $PATCH_COMMIT

# #FIXME should be a do-while loop here
# if [[ $? -ne 0 ]]; then
# 	echo -e "${WARNING}git cherry-pick failed to patch 115 to ${BACK_TO_MASTER_BASE} ${RESTORE}"
# 	echo -e "${WARNING}Run git mergetool to continue... ${RESTORE}"
# 	# git diff --name-only --diff-filter=U
# 	while :
# 	do
# 		git mergetool
# 		git cherry-pick --continue
# 		if [[ $? -eq 0 ]]; then
# 			break
# 		fi
# 	done
# fi

# git rebase 50.0.2625.0^

cd - > /dev/null


