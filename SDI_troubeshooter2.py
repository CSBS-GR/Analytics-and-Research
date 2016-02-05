from __future__ import print_function
import csv
import glob

f1 = open('output2.txt','w')
with open('ListofFiles.txt') as f:
    content = f.readlines()
d = ','

for ind in [24,40,41]:
    print('\n'+str(ind)+'\n', file=f1)
    datafilename = glob.glob('/Data/Load/*/*_'+str(content[ind]).rstrip()+'.csv')

    ncols = []
    filecol = dict()
    fileok = dict()

    for files in datafilename:
        f = open(files, 'r')
        reader = csv.reader(f, delimiter=d)
        text = next(reader)
        filecol[files] = text
        ncol = len(text)
        ncols.append(ncol)
    for key,value in sorted(filecol.items()):
        print(key, value, file=f1)
    print(ncols, file=f1)

