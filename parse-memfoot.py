import sys
import os
import csv

if len(sys.argv) <> 3:
  print "python parse-memfoot.py <resultfile> <output.csv>"
  exit(1)

curtime = None
allmeminfo = dict() # (pid, cmd) -> ((time, rss, vsz) list)
eachmeminfo = dict() # pid -> (rss, vsz, cmd)

def update(allmeminfo, eachmeminfo, curtime):
  if eachmeminfo:
    for eachpid in eachmeminfo:
      (rss,vsz,cmd) = eachmeminfo[eachpid]
      newkey = (eachpid, cmd)
      if newkey not in allmeminfo:
        allmeminfo[newkey] = []
      allmeminfo[newkey].append((curtime, rss, vsz))

filename = sys.argv[1]
csvname = sys.argv[2]
filehandler = open(filename, "r")

for eachline in filehandler:
  eachline = eachline.strip()
  words = eachline.split()

  if len(words) == 0:
    continue
  
  if words[0] == "TIME":
    assert (curtime != words[1])
    if (curtime != None):
      update(allmeminfo, eachmeminfo, curtime)
    eachmeminfo = dict()
    curtime = int(words[1])
  
  elif words[0] == "clang":
    assert (words[1] == "PID")
    continue
  
  elif words[0] == "RSS":
    assert (words[1] == "VSZ")
    assert (words[2] == "PID")
    assert (words[3] == "COMMAND")
  
  elif words[0] == "-":
    # Pass!
    pass

  else:
    # <rss> <vsz> <pid> <command>
    rss = int(words[0])
    vsz = int(words[1])
    pid = int(words[2])
    cmd = words[3] + " " + words[-1]
    #if pid in eachmeminfo:  # Even in the moment ps result can change.. this assertion is wrong
    #  if eachmeminfo[pid] != (rss, vsz, cmd):
    #    print "DIFFERENT! org value : ", eachmeminfo[pid]
    #    print "\tnew value : ", (rss, vsz, cmd)
    #  assert (eachmeminfo[pid] == (rss, vsz, cmd))
    eachmeminfo[pid] = (rss, vsz, cmd)

if (curtime != None):
  update(allmeminfo, eachmeminfo, curtime)

of = open(csvname, "wb")
writer = csv.writer(of)

header = ["Time"]
for key in allmeminfo:
  (keypid, keycmd) = key
  if "clang-3.9" in keycmd:
    header += ["RSS {0}".format(keycmd)]
    header += ["VSZ {0}".format(keycmd)]
writer.writerow(header)

def new_emptyline(idx):
  return [idx] + (["-"] * (len(header) - 1))

body = []
j = 0
for key in allmeminfo:
  (keypid, keycmd) = key
  if "clang-3.9" not in keycmd:
    continue
  trace = allmeminfo[key]
  (starttime, _, _) = trace[0]
  i = 0
  for eachitm in trace:
    (t, rss, vsz) = eachitm
    if (t - starttime) <> i:
      print "Timeline different! t : {0}, starttime : {1}, i : {2}".format(t, starttime, i)
      print "\tKey : {0}".format(key)
      assert ((t - starttime) == i)
    if len(body) <= i:
      body.append(new_emptyline(len(body)))
    body[i][j * 2 + 1] = rss
    body[i][j * 2 + 2] = vsz
    i = i + 1
  j = j + 1

writer.writerows(body)
