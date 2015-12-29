
source='engine1'
target_dir='siege/'

#find all csv siege_results on remote machine - will copy the directory structure too! 
rsync -avP --include="*/" --include="*.csv" --exclude="*" $source:/home/peter/vagrant/server-perf/ $target_dir
#find all the csv files and copy them to the root of the target directory
cd $target_dir	
find . -name *.csv -exec mv {} $target_dir \;
#remove all the dirs copied over during the rsync
find * -maxdepth 0 -type d -exec rm -fr {} \;
#should just have the csv files left over
ls -lh 
cd -
