from __future__ import print_function
import csv
import glob

f1 = open('output.txt','w')
with open('ListofFiles.txt') as f:
    content = f.readlines()
d = ','

for ind in range(len(content)):
    print('\n'+str(ind)+'\n', file=f1)
    datafilenames = glob.glob('/Data/Load/*/*_'+str(content[ind]).rstrip()+'.csv')

    ncols = []
    filecol = dict()
    fileok = dict()

    for filenm in datafilenames:
        f = open(filenm, 'r')
        reader = csv.reader(f, delimiter=d)
        text = next(reader)
        filecol[filenm] = text
        ncol = len(text)
        ncols.append(ncol)
    testcase = '/Data/Load\\All_Reports_20150930\\All_Reports_20150930_'+str(content[ind]).rstrip()+'.csv'
    for filenm in datafilenames:
        if filecol[filenm] == filecol[testcase]:
            fileok[filenm] = 'Valid'
    for key,value in sorted(fileok.items()):
        print(key, value, file=f1)
    print(ncols, file=f1)
    print('\n\n', file=f1)


