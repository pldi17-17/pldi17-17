import operator
import os
import sys
import csv

def all_within_rate(l, v):
  for f in l:
    f = float(f)
    # Even 1% noise is big in compiler performance test.
    if (f < 0.99 * v) or (1.01 * v < f):
      return False
  return True

def baseval(l):
  return l[1:6]
def basemed(l):
  return l[6]
def competitorval(l):
  return l[7:12]
def competitormed(l):
  return l[12]
def slowdown(l):
  return l[13]

def simplify(s):
  return s.split("/")[0] + "/" + s.split("/")[-1]

def slowdown_and_sort(inputfilepath, outputfilepath, filterout_fluctuatingresult):
  inputfhandler = open(inputfilepath, "rb")
  outputfhandler = open(outputfilepath, "wb")
  reader = csv.reader(inputfhandler, delimiter=',')
  writer = csv.writer(outputfhandler, delimiter=',')
  
  header = reader.next()
  header.append("Slowdown(%)")
  writer.writerow(header)

  alldata = []
  totelapsedtime = None
  totfailure = None
  for row in reader: 
    if row[0] == "Total failure":
      totfailure = row
      totfailure.append("")
      continue
    if row[0] == "Total elapsed time":
      totelapsedtime = row
      sd = (float(competitormed(row)) / float(basemed(row)) - 1) * 100.0
      totelapsedtime.append(sd)
      continue
    bmed = basemed(row) # base median
    cmed = competitormed(row) # codegen-freezecopy median
    noVariation = True
    if bmed == "" or bmed == "-" : 
      row.append(0) # zero slowdown
    else : 
      bmed = float(bmed)
      cmed = float(cmed)
      if not filterout_fluctuatingresult or (all_within_rate(baseval(row), bmed) \
          and all_within_rate(competitorval(row), cmed)):
        # There's no much variation!
        if bmed == 0.0:
          if cmed == 0.0 : 
            rate = 0.0
          else:
            # super slowdown
            rate = 100.0
        else:
          rate = (cmed / bmed) - 1
          rate = rate * 100.0
        row.append(rate)
      else:
        noVariation = False
    if noVariation:
      alldata.append(row)
  #alldata_sorted = sorted(alldata, key=operator.itemgetter(9))
  alldata_sorted = sorted(alldata, key=slowdown)
  alldata_sorted.reverse()
  writer.writerows(alldata_sorted)
  writer.writerow(totelapsedtime)
  if totfailure : 
    writer.writerow(totfailure)
  return (alldata_sorted, totelapsedtime)

if len(sys.argv) <> 3:
  print "python sort-lnt.py <input-rt.csv> <output-rt.csv>"
  exit(1)

slowdown_and_sort(sys.argv[1], sys.argv[2], True)

