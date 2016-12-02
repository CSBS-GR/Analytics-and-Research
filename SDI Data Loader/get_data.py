import urllib2, BeautifulSoup, os, re, wget, time, zipfile

# Define variables
path = "C:\Data\Load"
url = "https://www5.fdic.gov/sdi/download_large_list_outside.asp"
prefix = "https://www5.fdic.gov/sdi/Resource/AllReps/"
fileinfo = "fileinfo.txt"
html = BeautifulSoup.BeautifulSoup(urllib2.urlopen(url))
dl_counter = 0

# Local data
os.chdir(path)
local_files = [d+".zip" for d in os.listdir(path) if os.path.isdir(d)]

# local_timestamps = []
# for file in local_files:
#    local_timestamps.append(file+" | "+time.strftime("%a, %d %b %Y %H:%M:%S GMT",time.gmtime(os.path.getmtime(file))))

# Web data
web_files = list(html.findAll('td', text=re.compile('\\.zip')))
exist_files = list(set(local_files) & set(web_files))
new_files = list(set(web_files) - set(local_files))
new_files_counter = len(new_files)
# Retrieve stored file info
stored_fileinfo = [line.strip('\n') for line in open(fileinfo)]

# Get web file info for existing files
web_fileinfo = []
for file in exist_files:
    url = prefix + file
    u = urllib2.urlopen(url)
    meta = u.info()
    web_fileinfo.append(file+" | "+meta.getheaders("Last-Modified")[0] + " | " + meta.getheaders("Content-Length")[0])

stored_fileinfo.sort(reverse=True)
web_fileinfo.sort(reverse=True)
current_time = time.ctime(time.time())

# Download

if len(stored_fileinfo)==len(web_fileinfo):
	for w,s in zip(web_fileinfo, stored_fileinfo):
		if w.split(' | ')[1] != s.split(' | ')[1] or w.split(' | ')[2] != s.split(' | ')[2]:
			new_files.append(w.split(' | ')[0])

	# Download and extract new files
	for file in new_files:
		wget.download(prefix+file,path)
		dl_counter = dl_counter + 1
		# Extract
		zip_file = zipfile.ZipFile(file)
		zip_file.extractall(file.replace(".zip", ""))

	# Generate new File Info for next comparison
	txt = open(fileinfo,'w')
	for file in web_files:
		url = prefix + file
		u = urllib2.urlopen(url)
		meta = u.info()
		print >> txt, file+" | "+meta.getheaders("Last-Modified")[0] + " | " + meta.getheaders("Content-Length")[0]
	txt.close()
	# Write log
	with open('log.txt','a') as log:
		log.write("--------------------------\nDate of Execution: %s\nNumber of files on Web: %s\nNumber of files on local: %s\nNumber of new files: %s\nNumber of files downloaded: %s\n" % ( current_time,len(web_files),len(local_files),new_files_counter,dl_counter ))
else:
	log = open('log.txt','a')
	print ("Download failed. Please refer to the log file for the details.")
	print >> log, "--------------------------\n\nDate of Execution: %s\nLength of stored file info is inconsistent to existing file." % current_time
	log.close()
