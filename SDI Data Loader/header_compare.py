import os, sys, re
# os.chdir("H:\\")
old_path = sys.argv[1]
new_path = sys.argv[2]

old_csv_list = [f for f in os.listdir(old_path) if f.endswith('.csv')]
new_csv_list = [f for f in os.listdir(new_path) if f.endswith('.csv')]

def compare(file1,file2):
    with open(old_path+"\\"+file1, 'r') as f:
        old_headers = f.readline().rstrip('\n').split(',')
        old_nCols = len(old_headers) 
    
    with open(new_path+"\\"+file2, 'r') as f:
        new_headers = f.readline().rstrip('\n').split(',')
        new_nCols = len(new_headers)
    
    if new_nCols <> old_nCols:
        print "Length not Equal"
    elif new_headers != old_headers:
        for new_header, old_header in zip(new_headers,old_headers):
            if new_header != old_header:
                print old_header + " ==> " + new_header
    else:
        print "Headers from two CSVs are Equal."

for file1,file2 in zip(old_csv_list,new_csv_list):
    compare(file1,file2)