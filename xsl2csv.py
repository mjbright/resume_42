#!/usr/bin/env python

import xlrd
import csv
import sys

def csv_from_excel():

    wb = xlrd.open_workbook(sys.argv[1])
    sh = wb.sheet_by_name(sys.argv[2])
    #your_csv_file = open(sys.argv[3], 'wb')
    your_csv_file = open(sys.argv[3], 'w')

    #wr = csv.writer(your_csv_file, quoting=csv.QUOTE_ALL)
    wr = csv.writer(your_csv_file, quoting=csv.QUOTE_MINIMAL)

    for rownum in range(sh.nrows):
        wr.writerow(sh.row_values(rownum))
        #row_values=[]
        #for value in sh.row_values(rownum):
        #    if "," in value and value[0] == '"' and value[ len(value)-1 ] == '"':
        #        print("Changing value from <" + value + ">")
        #        value = value[1:-1]
        #        print("To                  <" + value + ">")
        # 
        #    row_values.append(value)
        #wr.writerow(row_values)

    your_csv_file.close()

csv_from_excel()

