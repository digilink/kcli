. venv/bin/activate
[ -d $HOME/.config ] || mkdir $HOME/.config
echo $COPR_BASE64 | base64 -d > $HOME/.config/copr
tar -C .. -Pczf /tmp/kcli.tar.gz --exclude=".*" kcli
mkdir -p $HOME/rpmbuild/{SOURCES,SRPMS}
mv /tmp/kcli.tar.gz $HOME/rpmbuild/SOURCES
export GIT_CUSTOM_VERSION=0.0.git.$(date "+%Y%m%d%H%M").$(git rev-parse --short HEAD)
export GIT_DIR_VCS=git+https://github.com/karmab/kcli#$(git rev-parse HEAD):
echo Using GIT_CUSTOM_VERSION $GIT_CUSTOM_VERSION
envsubst < kcli.spec > $HOME/rpmbuild/SOURCES/kcli.spec
git --no-pager log -n 30 --format="* %ad %an <%ae> %n- %s" --date=format:"%a %b %d %Y"
git --no-pager log -n 30 --format="* %ad %an <%ae> %n- %s" --date=format:"%a %b %d %Y" >> $HOME/rpmbuild/SOURCES/kcli.spec

rpmbuild -bs $HOME/rpmbuild/SOURCES/kcli.spec
copr-cli build --nowait kcli $HOME/rpmbuild/SRPMS/*src.rpm
