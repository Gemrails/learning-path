#!/usr/bin/python
## -*- encoding: utf-8 -*-
import re, datetime, urllib, os, threading, time, random, errno, MySQLdb
from urlparse import urljoin, urlparse, urlunparse, urlsplit, urlunsplit

url = 'http://v.2345.com/moviecore/server/variety/index.php?ctl=newDetail&act=ajaxList&id=47&year=0&api=qiyi&month=0&time=1425537044206&timeStamp=1425537044206'

def delUrlParams(url):
    parsed = urlparse(url)
    empty = '', '', ''
    print parsed
    return urlunparse(parsed[:3] + empty) 

def getId(url, pattern=None):
    parsed = urlparse(url)
    matchObj = re.search(pattern, parsed.path)
    id = 0
    if matchObj:
        id = matchObj.group(1)
    return id

print delUrlParams(url)
print getId(url, '(\d+).html$')

test = 'sohu_con'
print test[:-4]

#合并两个dict
x = {'a':1, 'b': 2}
y = {'b':10, 'c': 11}
print dict(x.items() + y.items())

text = '<a href=sdf> hello </a>'
print re.sub(r'</?a[^<]*>', '', text)

matchObj = re.search(u'[\d^\D]*上映于(\d+)年[\d^\D]*' , u'2345电视剧提供平凡的世界在线观看和平凡的世界电视剧全集下载;平凡的世界电视剧上映于2015年由知名导演毛卫宁导演,并且由著名电视剧明星王雷、佟丽娅、袁弘主演此片,其中还包括平凡的世界演员表、分集剧情、剧照、影评等信息看电视剧就上2345电视剧大全')
year = matchObj.group(1)
print year

def makeAjaxParam(**params):
    defaultParam = {
        "ctl": "newDetail",
        "act": "ajaxList",
        "year": '0',
        "month": '0'
    }
    for key, value in params.items():
        defaultParam[key] = value
    pairs = [key+'='+str(value) for key,value in defaultParam.items()]
    return '&'.join(pairs)

print makeAjaxParam(id=1234, api="youku")

a = []
print len(a)
playSources = {}
print(len(playSources))

print datetime.datetime.strptime('2014-09-17', '%Y-%m-%d').date()

a = {"a":'123a', "b": '456b'}
if not a.has_key('c'):
    print "good, I can check key of a dict"

string ="    周迅饰演的外星人来到地球，通过美食的传递，与井柏然饰演的小厨师展开了一场颇为简单纯粹的感情，不甚复杂的故事中却道出了引人思考的爱情观。 展开全部 收起全部"
pattern = r'\s*展开全部\s*收起全部\s*'
newStr = re.sub(pattern, '', string)
print newStr





def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc:
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else: raise exc

baseDir = "/home/jason/shared/image"
url = "http://img3.2345.com/dianyingimg/zongyi/img/f/5/sup15012_223x310.jpg?1419516249"

parsed = urlparse(url)
print parsed
path = parsed[2]
fullPath = baseDir+path
fullDir = os.path.dirname(fullPath)
print fullDir 
if not os.path.exists(fullDir):
    mkdir_p(fullDir)

fileExists = os.path.exists(fullPath)
print "file exists? %s" % fileExists
try:
    if not fileExists:
        result = urllib.urlretrieve(url, fullPath)
        print result
except IOError, e:
    print "io error, maybe path does not exist: %s" % (fullPath,)
except Exception, e:
    raise e

# db = MySQLdb.connect('192.168.2.50', 'test', 'test', '1188test')
# cursor = db.cursor()
# cursor.execute('''SELECT count(1) from video_info''')
# rowCount = cursor.fetchone()[0]
# print rowCount


# def printTime(name):
#     for x in xrange(1,5):
#         print "Thread %s : time is %s" % (name, time.ctime(time.time()))
#         time.sleep(random.random())

# threads = []
# for job in xrange(1,10):
#     if 
#     t1 = threading.Thread(target = printTime, args=("Job %d" % (job),) )
#     threads.append(t1)
#     t1.start()
