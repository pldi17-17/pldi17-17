import os
import sys
import csv

if len(sys.argv) <= 2:
  print "analyze-memfoot-csv.py <output.csv> <input1.csv> <input2.csv> ..."
  exit(1)

outputf = sys.argv[1]
filelist = sys.argv[2:]
print "filelist : " , filelist
result = list() # (totaltime, maxrsstime, maxrss, maxvsztime, maxvsz) list
for eachf in filelist:
  f = open(eachf, "r")
  rdr = csv.reader(f)
  header = None
  maxrss = 0
  maxrsst = 0
  maxvsz = 0
  maxvszt = 0
  totaltime = 0
  for row in rdr:
    if header == None :
      header = row
      continue
    rss = None
    vsz = None
    t = 0
    if len(row) == 3:
      # Normal case.
      rss = int(row[1])
      vsz = int(row[2])
      t = int(row[0])
    elif len(row) == 5:
      idx = 0
      for itm in header:
        if "bin/clang" in itm and itm[0:3] == "RSS":
          rss = int(row[idx])
        elif "bin/clang" in itm and itm[0:3] == "VSZ":
          vsz = int(row[idx])
        idx = idx + 1
      assert (rss != None)
      t = int(row[0])
    else:
      print "len(row) : ", len(row)
      assert (len(row) == 3 or len(row) == 5)
    
    if maxrss < rss:
      maxrsst = t
      maxrss = rss
    if maxvsz < vsz:
      maxvsz = vsz
      maxvszt = t
    if totaltime < t:
      totaltime = t
  result.append([(totaltime * 0.02), (maxrsst * 0.02), maxrss, (maxvszt * 0.02), maxvsz])

of = open(outputf, "wb")
writer = csv.writer(of)
writer.writerow(["Total times", "MAX RSS time", "MAX RSS", "MAX VSZ time", "MAX VSZ"])
writer.writerows(result)
