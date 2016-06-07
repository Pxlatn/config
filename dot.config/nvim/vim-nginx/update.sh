# https://github.com/LeonB/vim-nginx
owd="$(pwd)";
cd "$( dirname "$0" )";
if test -d .git; then
	git checkout -b rebase
	git fetch nginx master
	git reset --hard nginx/master
	git filter-branch -f --subdirectory-filter contrib/vim HEAD -- --all
	git checkout master
	git merge rebase
	git branch -D rebase
else
	git init
	git remote add nginx git@github.com:nginx/nginx.git
	git pull -u nginx master
	git filter-branch --subdirectory-filter contrib/vim HEAD -- --all
	git reset --hard
	git gc
	git prune
fi
cd "$owd";
