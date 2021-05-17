import json
import os
import numpy as np
import matplotlib.pyplot as plt
import sys

if not sys.warnoptions:
    import warnings
    warnings.simplefilter("ignore")

with open('all_result.json') as f:
  r = json.load(f)

if not os.path.exists('results'):
    os.makedirs('results')

all ={}

for each_ret in r.keys():
  r[each_ret].remove('')
  l = [0,2,3,4,6,7,8,9,10,11,12,13,14,15,16,18,20,21,22,23,24,25,26,27,28,30]
  for i in range(6,17):
    r[each_ret][i] = r[each_ret][i][:15] + ':' + r[each_ret][i][16:]
  for i in l:
    r[each_ret][i] = r[each_ret][i].replace(' ', '').split(':')
  d = {}
  d[r[each_ret][0][0]] = [r[each_ret][0][1]]
  for each in range(1,len(r[each_ret])):
    if isinstance(r[each_ret][each], str) == True and r[each_ret][each] != '':
      c = r[each_ret][each]
      d[c] = []
    else:
      if r[each_ret][each] != '':
        d[c].append(r[each_ret][each])
  all[each_ret] = d

def plot(t,d):
  ir = d['Interpolated Recall - Precision Averages:']
  recall = np.array([float(level[0][2:]) for level in ir])
  precision = np.array([float(level[1]) for level in ir])

  i=recall.shape[0]-2

  while i>=0:
      if precision[i+1]>precision[i]:
          precision[i]=precision[i+1]
      i=i-1

  fig, ax = plt.subplots()
  for i in range(recall.shape[0]-1):
      ax.plot((recall[i],recall[i]),(precision[i],precision[i+1]),'k--',label='',color='blue') #vertical
      ax.plot((recall[i],recall[i+1]),(precision[i+1],precision[i+1]),'k--',label='',color='blue') #horizontal

  ax.plot(recall,precision,'k-o',color='red')
  ax.set_title('Interpolated Recall - Precision Averages:')
  ax.set_xlabel("recall")
  ax.set_ylabel("precision")

  if not os.path.exists('results/'+ t):
    os.makedirs('results/'+ t)
  fig.savefig('results/'+ t+'/Recall - Precision.png')


  p = d['Precision:']
  doc = [int(''.join(x for x in level[0] if x.isdigit())) for level in p]
  precision = np.array([float(level[1]) for level in p])

  fig, ax = plt.subplots()

  ax.plot(doc,precision,'k-o',color='blue')
  ax.set_title('Precision:')
  ax.set_xlabel("doc")
  ax.set_ylabel("precision")

  fig.savefig('results/'+ t+'/Precision.png')

def save(t, d):

  with open('results/'+ t + "/Output.txt", "w+") as text_file:
    text_file.write(t.capitalize() + ' Result: \n\n')
    text_file.write('Queryid(Num): '+ d['Queryid(Num)'][0] + '\n')
    text_file.write('Average precision (non-interpolated) for all rel docs(averaged over queries): ' + d['Average precision (non-interpolated) for all rel docs(averaged over queries)'][0][0] + '\n')
    text_file.write('R-Precision (precision after R (= num_rel for a query) docs retrieved): ' + d['R-Precision (precision after R (= num_rel for a query) docs retrieved):'][0][1] + '\n')
    text_file.write('Total number of documents over all queries: ' + '\n')
    text_file.write('Retrieved: ' + d['Total number of documents over all queries'][0][1] + '\n')
    text_file.write('Relevant: ' + d['Total number of documents over all queries'][1][1] +'\n')
    text_file.write('Rel_ret: ' + d['Total number of documents over all queries'][2][1] +'\n')

for each in all.keys():
  plot(each[:-6], all[each])
  save(each[:-6], all[each])